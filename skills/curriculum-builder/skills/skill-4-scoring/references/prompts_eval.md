# references/prompts_eval.md — V3 / V4 프롬프트 전문

Skill 4의 핵심 평가 프롬프트 3종.
- V3: AI 변화 폭 평가 (Q1/Q2/Q3 분리)
- V4 primary: feature 매칭 + 인용 4요소
- V4 secondary: 재질의 (조건부)

---

## 1. V3 평가 프롬프트 (Q1/Q2/Q3 분리 구조)

```
당신은 이 task에 AI를 적용했을 때의 **변화 폭**을 평가합니다.

[Task 정보]
one_liner: {task.one_liner}
action: {task_cards.action}
inputs: {task_cards.inputs}
immediate_output: {task_cards.immediate_output}

[평가 rubric — 3단 앵커]
1점 = 속도 절감 (기존에 사람이 하던 일의 시간만 단축. 결과물 형태·품질 동일)
      예: "회의록 AI로 더 빨리 작성" / "메일 답신 자동 생성"
3점 = 품질 개선 (사람이 놓칠 수 있는 것을 AI가 일관·정확하게 식별)
      예: "계약서 누락 조항 일관 식별" / "응대 톤 일관 유지"
5점 = 질적 전환 (사람이 수작업으로는 사실상 불가능한 일이 가능해짐)
      예: "수백 건 인터뷰를 정량 테마 분포로 변환" / "경쟁사 30곳 제안서 일괄 비교"

[아래 3개 질문에 분리해서 답하세요]

Q1. 이 task가 1 / 3 / 5 중 어느 앵커에 가장 가까운가? (2, 4점 금지)
Q2. Q1 판정의 근거는? (task 서술을 반드시 인용하여 한 문장)
Q3. 1점 앵커("속도 절감")의 예시 문구와 얼마나 유사한가?
    유사도: 상 / 중 / 하

※ Q3 유사도가 '상'이면 Q1 판정을 다시 검토하세요 (속도 절감 task가 고득점 받는 편향 방지).

[출력 JSON 형식]
{
  "score": <1, 3, or 5>,
  "label": <"속도 절감" | "품질 개선" | "질적 전환">,
  "rationale": "<Q2 답변 — task 서술 인용 포함>",
  "q3_speed_similarity": <"상" | "중" | "하">
}
```

---

## 2. V4 primary 평가 프롬프트 (매칭 + 인용)

```
당신은 이 task를 이 툴로 지원할 수 있는지 평가합니다.

[Task 정보]
one_liner: {task.one_liner}
action: {task_cards.action}
immediate_output: {task_cards.immediate_output}

[툴 기능 목록 — {tool_name}의 features 전문]
{tool-features.json의 해당 툴 블록에서 features 배열 전문 + version_info + completeness_note}

[평가 규칙 — 반드시 준수]

1. 매칭되는 feature마다 아래 4요소(+ metadata 1요소)를 반드시 반환:
   - feature_name: tool-features.json의 name (정확히 일치)
   - task_quote: task 서술(action / inputs / immediate_output)에서 이 feature가 지원하는 구체 부분 (원문 인용)
   - strength: "직접" / "부분" / "우회" 중 택1
   - rationale: 어떻게 지원하는지 한 줄
   - feature_caveats: tool-features.json의 해당 feature.caveats **값 그대로 복사** (null이면 null). 점수에 영향 X, LD 인지 목적 metadata

2. 인용(task_quote) 없이 "매칭됨"이라고만 주장하는 매칭은 **무효**. matches 배열에 포함하지 마세요.

3. "우회" 정의: feature의 일반 능력(추론·종합·탐색·변환 등)이 task에 활용 가능한 경우 포함. 단, 근거 인용 필수.

[점수 산출]
- 매칭 0개, 또는 모두 무효 → primary_score = 0
- 우회 매칭 1~2개만 있고 직접 매칭 없음 → 1
- 직접 매칭 1개, 또는 부분 매칭 2~3개 → 3
- 직접 매칭 2개 이상 + 핵심 행위 전반 커버 → 5

(2, 4점 금지 — 애매하면 하위로 판정, 보수 판정)

[출력 JSON 형식]
{
  "primary_score": <0, 1, 3, or 5>,
  "matches": [
    {
      "feature_name": "<...>",
      "task_quote": "<task 서술에서 원문 인용>",
      "strength": "<직접 | 부분 | 우회>",
      "rationale": "<한 줄 설명>",
      "feature_caveats": <"<tool-features.json의 caveats 값 그대로>" | null>
    },
    ...
  ]
}
```

---

## 3. V4 secondary 재질의 프롬프트 (조건부)

**트리거 조건**:
- `v4.primary_score ≤ 1` (기본)
- tool-features.json의 `completeness_note`에 "자체 점검 미충족" 사유가 있으면 임계값을 `≤ 2`로 상향

```
당신은 이 task에 이 툴이 지원할 수 있는 **목록에 없는** feature를 추정합니다.

[Task 정보]
one_liner: {task.one_liner}
action: {task_cards.action}

[현재 조사된 feature 목록]
{tool-features.json의 해당 툴 블록 features 전문}

[지시]
이 task를 지원하려면 위 목록 외에 어떤 feature가 필요할 수 있는지 추정하세요.
각 추정에 다음 3요소를 반드시 포함:

- estimated_feature: 기능 이름 + 간단 설명
- grounding: 추정 근거 (유사 툴 기능 / 공식 로드맵 / 베타 기능 / 일반적 패턴 중 택)
- confidence: "high" / "medium" / "low"

**근거 없는 상상은 금지**. grounding을 제시할 수 없으면 빈 배열 반환.

[주의]
- 이 결과는 주 점수(primary_score)에 **반영되지 않습니다**.
- LD 수동 판단을 돕는 참고 정보로만 사용됩니다.
- 따라서 무리하게 추정을 늘리지 말고, 근거가 명확한 것만 반환하세요.

[출력 JSON 형식]
{
  "missed_feature_estimates": [
    {
      "estimated_feature": "<기능 이름 + 설명>",
      "grounding": "<근거>",
      "confidence": "<high | medium | low>"
    },
    ...
  ]
}
```
