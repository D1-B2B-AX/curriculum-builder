# Prompts: [F2] criticality 판정

Plan v2 공정 1 (Tool Feature Factcheck) Step S4에서 사용하는 [F2] criticality 판정 프롬프트 전문.
재구성 깊이 [F3]의 semi-critical 분기 결정을 단독으로 위임받는 LLM 호출이다.

## 호출 시점

시그널이 탈락(A·C-지역·B-2·B 보수) 판정된 feature에 대해 대체 루프 진입 직전.

## LLM 호출 파라미터 (결정성 확보)

- **temperature**: 0
- **response_format**: json_schema (아래 스키마 강제)
- 동일 입력 → 동일 출력 보장. grep·step 비율 등 외부 조건에 의존하지 않음.

## 프롬프트 전문

```
[시스템]
너는 AI 교육 커리큘럼 설계자이다. 주어진 feature가 특정 실습 모듈에서 "치명적(critical)"인지 판정한다.
판정 결과는 후속 공정의 Level 결정(Level 1~4)에 단독으로 사용되므로 정확한 근거와 level_decision 값을 제시해야 한다.

[입력]
- feature: {feature_name + description}
- 등장 모듈: {module_id (m1/m2/m3/m4)}
- 모듈 본문: {module_md_content}
- 관련 task: {task_name + task_card trigger/inputs/action/output}
- 툴의 다른 가용 feature: {tool-features.json의 같은 툴 내 나머지 features 요약}

[판정 질문]
이 feature를 제거하고 이 툴의 다른 feature만으로 같은 task를 다루는 실습을 설계 가능한가?
다음 중 하나로 답하라:

(a) 대체 가능 (non-critical) — 이 툴의 다른 feature로 같은 task의 실습 구성 가능
(b) 부분 대체 가능 (semi-critical) — 다른 feature로 일부 단계는 대체 가능하나 실습 골자의 일부를 재설계해야 함
(c) 대체 불가 (critical) — 이 feature가 이 task 실습의 핵심이며, 다른 feature로는 같은 학습 목표를 달성 불가 → task 자체 교체 고려

[추가 질문 — Level 2/3 분기용 (LLM 단독 결정)]
(b) semi-critical 판정 시 반드시 답하라:
  "feature 교체만으로 실습 골자(학습 목표·task 내용)를 유지할 수 있는가?"
  - yes → `level_decision: "level2"` (rationale에 "부분 교체로 충분" 취지 근거 명시)
  - no → `level_decision: "level3"` (rationale에 재작성 필요성 명시)

non-critical은 항상 `level_decision: "level2"`, critical은 `level_decision: "level3"` (loop<2) 또는 `null` (loop≥2, Level 4로 escalate).

[LLM 호출 파라미터 (결정성 확보)]
- temperature: 0
- response_format: json_schema (아래 스키마 강제)
- 동일 입력 → 동일 출력 보장. grep·step 비율 등 외부 조건에 의존하지 않음.

[출력 JSON 스키마]
{
  "criticality": "non-critical" | "semi-critical" | "critical",
  "rationale": "구체 근거 2~4문장. '왜 그런가'를 학습 목표·task 구조 기반으로 설명",
  "level_decision": "level2" | "level3" | null,
  "level_decision_rationale": "level_decision의 근거 1~2문장",
  "candidate_replacements": ["tool-features.json 내 대체 후보 feature name 0~3개"],
  "_meta": {
    "changed_steps_ratio": 0.0
  }
}

[필드 설명]
- `level_decision`: non-critical→"level2" 고정, semi-critical→LLM 판정, critical→"level3"(loop<2) 또는 null(loop≥2로 Level 4 escalate). 이 필드가 Level 결정의 단독 소스.
- `level_decision_rationale`: Level 선택 근거. rationale의 부분집합 또는 독립 서술 모두 허용.
- `_meta.changed_steps_ratio`: 사후 검증용 보조 메타데이터. 실습 step 중 교체 시 수정 필요한 비율 (0.0~1.0). 결정에 불개입. 미산출 시 null.
- `candidate_replacements`: 같은 툴 내 tool-features.json features 배열에서 이 feature를 대신할 수 있는 후보 name 0~3개. 후보가 없으면 빈 배열.
```

## 조건 분기 규칙 (프롬프트 출력 → 다음 단계)

```
criticality == "non-critical"
  → 재구성 깊이 [F3] Level 1 또는 Level 2 (feature 교체만)
  → level_decision 항상 "level2" (출력 강제)

criticality == "semi-critical"
  → 재구성 깊이 [F3] Level 2 또는 Level 3
  → [F2] 프롬프트 출력의 level_decision 값이 Level 결정의 단독 소스
  → level_decision == null 발생 시 [F2] 재호출 1회 → 여전히 null이면 보수적 Level 3

criticality == "critical"
  → 재구성 깊이 [F3] Level 3 (loop<2) 또는 Level 4 (loop≥2)
  → 대체 루프 2회 초과 시 LD 선택지 제공 시점에 criticality 판정 함께 전달
```

## rationale 작성 수락 기준

- "왜 그런가"를 **학습 목표 문구 또는 task action 키워드**와 연결하여 구체적으로 서술.
- 다음 체크리스트 4개 중 최소 **2개 이상** 포함 (Validation v2 기준 2 (C) 검증 대상):
  1. 학습 목표 문구 인용 (예: "M4 학습 목표 '데이터 시각화'를 달성하려면...")
  2. task action 키워드 인용 (예: "task action '보고서 작성'의 핵심 단계인...")
  3. feature description의 구체 동사 인용 (예: "이 feature는 'XYZ를 자동 생성'하는 유일한 방법이므로...")
  4. 다른 feature와의 차이 명시 (예: "대안 feature A는 수동 입력이 필요하나 이 feature는 자동...")
- 빈 문자열 또는 추상 표현("중요함", "필요함")만 있으면 fail 처리 → [F2] 재호출.

## 허용 동의 표현 리스트 (rationale 내 grep 대상, 보조 메타데이터)

다음 3개 표현 중 1개 이상 rationale에 포함되었는지는 `rationale_keyword_present: true/false` 플래그로 기록 (Level 결정에 영향 없음, Validation v2 기준 2 (C) 보조 신호):

1. "부분 교체로 충분"
2. "경량 수정 가능"
3. "feature 교체만으로 실습 성립"

## 호출 예시 (의사코드)

```python
response = llm.call(
    model="claude-opus-4-7",
    temperature=0,
    response_format={"type": "json_schema", "schema": F2_SCHEMA},
    messages=[
        {"role": "system", "content": F2_SYSTEM_PROMPT},
        {"role": "user", "content": f"""
[입력]
- feature: {feature_name} — {description}
- 등장 모듈: {module_id}
- 모듈 본문:
{module_md_content}
- 관련 task: {task_name} (trigger={trigger}, inputs={inputs}, action={action}, output={output})
- 툴의 다른 가용 feature: {other_features_summary}
        """}
    ]
)

assert response["level_decision"] in ("level2", "level3", None)
# semi-critical인데 level_decision=null이면 재호출 1회, 여전히 null이면 보수적 Level 3
```
