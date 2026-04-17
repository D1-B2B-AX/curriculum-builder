---
name: top3-task-scorer
description: curriculum-builder 실습 task top3 선정. Skill 2(task 리스트 + DNA + workflow)와 Skill 3(tool-features) 결과를 받아 V4(툴 적합성)/V3(AI 변화 폭)/V2(직무 임팩트) 3축으로 점수화, Killer Criteria 필터 후 상위 3개 task를 top3-tasks.json에 저장. Skill 5~7이 M4~M2 설계에 이 결과를 참조.
---

# Skill 4: 실습 task top3 선정

Skill 2가 도출한 직무 task 목록 중 **메인 실습(M4)에 가장 적합한 top 3**를 선정한다.
V4(툴 적합성), V3(AI 변화 폭), V2(직무 임팩트) 3축으로 평가하고, Killer Criteria로 사전 필터 후 가중합 점수로 상위 3개를 뽑는다.

## 왜 이 스킬이 필요한가

Skill 2가 도출한 task 목록 중 "실습으로 가장 가치 있는 3개"를 **객관적·반복 가능한 기준**으로 고르기 위함. 기준 없이 고르면 매번 다른 결과가 나온다. Skill 5~7은 이 top3와 평가 근거를 M4·M3·M2 설계의 **교육적 설명 소스**로 활용한다.

---

## 전제: references/ 전체 Read 강제 (핵심 규정)

Skill 4 실행 시 반드시 아래 5개 파일을 **전체 Read 후** 작업을 시작한다.
SKILL.md 요약만으로 판단하지 말고 references의 canonical 정의·프롬프트 전문·rubric을 그대로 적용한다.

| 파일 | 담는 것 |
|---|---|
| `references/rubric.md` | V3·V4·V2 점수 매핑 + 인용 규칙 + K1/K2/K3 필드 체크 규정 + LD 변환 규칙 (LLM 호출 없이 기계적으로 참조) |
| `references/prompts_eval.md` | V3 / V4 primary / V4 secondary 프롬프트 전문 |
| `references/prompts_v2.md` | V2 duration / V2 topic_fit 프롬프트 전문 |
| `references/prompts_killer.md` | K4 / K5 LLM 프롬프트 전문 (판정 로직 포함) |
| `references/prompts_meta.md` | multi_topic 감지 / 다양성 체크 / matched_topic 태깅 / LD 요약 생성 프롬프트 전문 |

**이 규정의 근거**: Skill 2 v3+ 테스트(LG생활건강)에서 "references 미독 시 ontology 위반 다수 발생, 읽고 실행 시 0 위반" 실효성 검증됨.

---

## Input

아래 6개 파일을 읽는다. 모두 Skill 1·2·3이 생성한 `curriculum-builder-output/{run_folder}/` 하위에 있다.

| 파일 | 읽는 필드 | 용도 |
|---|---|---|
| `input.json` | `company`, `role`, `tools[]`, `topic`, `run_folder` | 실행 맥락, 복수 툴 처리 |
| `tool-features.json` | 툴명 키 dict의 features + completeness_note | V4 매칭·재질의, K5 판정 |
| `tasks.json` | task_id 목록 + one_liner | 평가 대상 식별 |
| `task-research/task-cards.json` | trigger, inputs, action, immediate_output, cadence | K3 체크, V2 빈도, LLM 평가 입력 |
| `task-research/task-dna.json` | primitive_lv1/2, domain_lv1/2, mechanism_lv1/2, classification_status | K1/K2 체크 |
| `task-research/workflow.json` | DAG edges | V2 중심성 |

---

## Output: top3-tasks.json

**저장 경로**: `curriculum-builder-output/{run_folder}/top3-tasks.json` (단일 파일)

### 최상위 구조

```json
{
  "meta": {
    "run_folder": "...",
    "executed_at": "2026-04-17T15:30:00",
    "input_snapshot": {"company": "...", "role": "...", "tools": ["ChatGPT"], "topic": "..."},
    "weights": {"v4": 0.45, "v3": 0.35, "v2": 0.2}
  },
  "topic_input": {
    "is_composite": true,
    "topic_elements": ["AI 디자인", "타이포그라피"]
  },
  "per_tool": {
    "ChatGPT": {
      "killer_filtered_out": [...],
      "top3": [...],
      "notable_outside_top3": [...],
      "diversity_check": {...}
    },
    "Claude Code": { ... }
  }
}
```

- `per_tool` 블록은 `input.tools` 배열의 각 툴마다 반복. 단일 툴이면 키 1개.
- `topic_input.topic_elements`는 단일 주제 시 1개 요소 배열, 복수 주제 시 N개.

### top3 항목 구조

```json
{
  "rank": 1,
  "task_id": "T001",
  "task_one_liner": "...",
  "task_summary": {"action": "...", "immediate_output": "..."},
  "final_score": 4.25,

  "v3": {
    "score": 5,
    "label": "질적 전환",
    "rationale": "...(task 서술 인용)",
    "q3_speed_similarity": "하"
  },

  "v4": {
    "primary_score": 4,
    "matches": [
      {"feature_name": "Canvas 모드", "task_quote": "...", "strength": "직접", "rationale": "...", "feature_caveats": null}
    ],
    "missed_feature_estimates": [],
    "high_potential_low_match": false
  },

  "v2": {
    "score": 3.6,
    "breakdown": {
      "frequency":    {"score": 4, "interpretation": "..."},
      "duration":     {"score": 3, "interpretation": "..."},
      "source_trust": {"score": 5, "interpretation": "..."},
      "centrality":   {"score": 3, "interpretation": "..."},
      "topic_fit":    {"score": 3, "interpretation": "..."}
    },
    "caveats": ["..."]
  },

  "matched_topic": "AI 디자인"
}
```

### 필드 조건부 규칙

- `missed_feature_estimates`: `v4.primary_score ≤ 1` (completeness_note 미충족 시 ≤ 2) 트리거 시에만 채워짐. 아니면 빈 배열.
- `matched_topic`: 복수 주제(`topic_input.is_composite = true`)일 때 값. 단 task가 여러 주제에 걸쳐 있거나 불명확하면 `null` 허용 (억지 선택 방지). 단일 주제면 항상 `null`. Phase 1 한정 단일 값 구조 — 다중 매칭(배열)은 Phase 2 확장 과제.
- `high_potential_low_match`: `v3.score ≥ 5 && v4.primary_score ≤ 1`일 때 `true`.
- `killer_filtered_out`: JSON 전용. **LD 출력에 노출 금지** (정보 과부하 방지).

### notable_outside_top3 항목 구조

top3와 동일하되 `rank`가 4~6 사이, `high_potential_low_match`는 반드시 `true`.

### diversity_check 구조

```json
{
  "performed": true,
  "topic_coverage": {"AI 디자인": 3, "타이포그라피": 0},
  "balanced": false,
  "skewed_to": "AI 디자인"
}
```

- `performed`: `topic_input.is_composite = true`일 때만 `true`. 아니면 `false`로 나머지 필드는 `null`.

---

## 실행 절차 (7 Step)

### Step 1. 파일 로드
`input.json`의 `run_folder`로 하위 경로 파악 → 위 Input 섹션 6개 파일 모두 로드한다.

### Step 2. 복수 주제 감지
`references/prompts_meta.md`의 multi_topic 감지 프롬프트로 `input.topic` 분석.
결과를 최종 output의 `topic_input`에 기록한다.

### Step 3. 툴별 독립 실행 (분담 방식)
`input.tools` 배열을 순회하며 각 툴마다 Step 4~7 반복. 결과는 `per_tool[tool]` 블록에 저장.

### Step 4. Killer Criteria 필터

각 task에 대해 K1 → K2 → K3 → K4 → K5 순서로 판정. 하나라도 발동하면 **즉시 `killer_filtered_out`에 기록 후 다음 task로**.

| Killer | 방식 | 참조 |
|---|---|---|
| K1 | task-dna.json 필드 체크 | references/rubric.md §K1 |
| K2 | task-dna.json 필드 체크 | references/rubric.md §K2 |
| K3 | task-cards.json 필드 체크 | references/rubric.md §K3 |
| K4 | LLM 호출 (본질적 비윤리·불법) | references/prompts_killer.md §K4 |
| K5 | LLM 호출 (모달리티 불일치) | references/prompts_killer.md §K5 |

**남은 task가 3개 미만**일 경우 LD에게 즉시 경고:
```
⚠ Killer Criteria 필터 이후 남은 task가 {N}개뿐입니다.
Skill 2 결과 품질을 먼저 점검해주세요.
```

### Step 5. V3 → V4 → V2 평가 (순차)

**순서 고정** (앵커링 방지). 각 task에 대해:

#### 5-1. V3 평가
- `references/prompts_eval.md`의 V3 프롬프트 (Q1/Q2/Q3 분리 구조)
- 결과: `score` (1/3/5) + `label` + `rationale` + `q3_speed_similarity`
- label 값: 1점 "속도 절감" / 3점 "품질 개선" / 5점 "질적 전환" — 내부 JSON 전용, LD 출력에는 rubric.md §LD 변환 규칙의 의미 문장으로 변환

#### 5-2. V4 primary 평가
- `references/prompts_eval.md`의 V4 primary 프롬프트
- 매칭 4요소(feature_name + task_quote + strength + rationale) 강제 + metadata 1요소(feature_caveats)
- 인용 없는 매칭은 무효 → 해당 매칭 제거. 모든 매칭 무효면 `primary_score = 0`
- 결과: `primary_score` (0/1/3/5) + `matches` 배열
- **feature_caveats**는 tool-features.json의 해당 feature.caveats 값 그대로 복사. 점수에 영향 X, LD 인지 목적. 실제 환경 충돌 판단은 Skill 5(M4 설계) 영역

#### 5-3. V4 secondary 재질의 (조건부)
- 트리거: `primary_score ≤ 1`. 단 `tool-features.json`의 `completeness_note`에 "자체 점검 미충족" 사유가 있으면 임계값을 **≤ 2로 상향**.
- `references/prompts_eval.md`의 V4 secondary 프롬프트
- 결과: `missed_feature_estimates` 배열. **점수에 반영 X**.

#### 5-4. V2 평가 (5개 proxy 단순 평균)

| proxy | 방식 |
|---|---|
| ① `frequency` | task-cards.json의 `cadence`를 rubric.md 매핑표로 변환 (LLM 호출 없음) |
| ② `duration` | `references/prompts_v2.md`의 duration 프롬프트 (LLM 추정) |
| ③ `source_trust` | task-research의 `source_tier`를 rubric.md 매핑표로 변환 (LLM 호출 없음) |
| ④ `centrality` | workflow.json의 DAG 연결 수(in+out)를 rubric.md 매핑표로 변환 (LLM 호출 없음) |
| ⑤ `topic_fit` | `references/prompts_v2.md`의 topic_fit 프롬프트 (LLM 판정) |

`v2.score = (① + ② + ③ + ④ + ⑤) / 5`. 각 proxy는 `{score, interpretation}` 쌍으로 `breakdown`에 기록.
`caveats`에는 고정 주의사항 포함 (rubric.md §V2 caveats 참조).

### Step 6. 가중합 · 정렬 · 타이브레이커 · top3 확정

각 task에 대해:
```
final_score = v4.primary_score × 0.45 + v3.score × 0.35 + v2.score × 0.2
```

내림차순 정렬. 동점 시 타이브레이커 순서:
1. V4 높은 것 (툴 매칭 = 실습 가능성 우선)
2. V3 높은 것
3. task 원본 순서 (deterministic)

상위 3개를 `top3`에 저장. Killer 통과 task가 3개 미만이면 그대로 반환 (경고는 Step 4에서 이미 표시).

### Step 7. 고잠재력 외부 노출 + 다양성 체크 + matched_topic + 저장

#### 7-1. 고잠재력 저매칭 (4~6위)
4위부터 6위까지 스캔, `v3.score ≥ 5 && v4.primary_score ≤ 1`인 task를 `notable_outside_top3`에 기록. 플래그 `high_potential_low_match = true`.

#### 7-2. matched_topic 태깅 (복수 주제일 때만)
`topic_input.is_composite = true`인 경우, `references/prompts_meta.md`의 matched_topic 태깅 프롬프트로 각 top3·notable task에 `matched_topic` 필드 채움.

#### 7-3. 다양성 체크 (복수 주제일 때만)
`references/prompts_meta.md`의 다양성 체크 프롬프트로 top3의 matched_topic 분포 판정 → `diversity_check` 블록 기록.

#### 7-4. JSON 저장
최종 구조를 `curriculum-builder-output/{run_folder}/top3-tasks.json`에 저장.

#### 7-5. LD 자연어 요약 생성 (실시간 출력, JSON 미포함)

`references/prompts_meta.md`의 LD 요약 생성 프롬프트로 top3 + notable을 **자연어 문장**으로 변환 출력.
- rubric 라벨 대신 **의미 문장** 사용 (rubric.md §LD 변환 규칙 참조)
- Killer 탈락은 LD에 미노출 (남은 task 3개 미만 경고만 예외)

---

## LD 출력 템플릿

```
✅ Top 3 실습 task 후보 선정 완료

[ChatGPT 대상]

Top 1: {task_one_liner}
  이 task가 추천되는 이유:
  • AI 전환 가치 (V3 {score}점): {V3 의미 문장}
  • 툴 적합성 (V4 {primary_score}점): {V4 의미 문장}
    관련 기능:
    - {feature_name_1}
      {feature_caveats가 null이 아니면 →} ⚠ 참고: {feature_caveats}
    - {feature_name_2}
    ...
  • 직무 중요도 (V2 {score}점):
    - 빈도: {interpretation}
    - 1회 소요시간: {interpretation}
    - 출처: {interpretation}
    - 중심성: {interpretation}
    - 주제 정합: {interpretation}
    ※ 간접 측정이라 실제 중요도와 다를 수 있습니다.
  종합: {final_score}/5

Top 2: ...
Top 3: ...

[top3 중 high_potential_low_match인 것이 있으면]
  ⚠ 이 task는 AI 전환 가치는 크지만 현재 툴의 직접 매칭은 약한 편입니다.
     재설계로 실습 가능 여부를 추가 검토하시기 바랍니다.
     참고 — 놓친 기능 추정:
     - {missed_feature_estimates[0].estimated_feature}
       근거: {grounding}, 확신도: {confidence}

[주목할 task — top3 외 (notable_outside_top3가 있을 때만)]
  • {task_one_liner} (전체 {rank}위)
    AI 전환 가치는 매우 크지만 툴 매칭이 약해 top3에 들지 못했습니다.
    재설계로 실습 가능할지 검토해주시기 바랍니다.

[복수 주제 + 쏠림 시]
  ⚠ Top 3이 '{skewed_to}' 주제로 쏠려 있습니다.
     다른 주제({주제 목록}) 반영을 위해 재실행하시겠습니까?

산출물: curriculum-builder-output/{run_folder}/top3-tasks.json

확인 후 다음 단계(M4 메인 실습 설계)로 넘어가겠습니다.
```

---

## 실패 처리

### 자동 재시도 (LD에게 알리지 않음)
LLM 호출(K4/K5, V3, V4, V2 topic_fit·duration, meta 프롬프트) 실패 시 **최대 2회 자동 재시도**.

### Case A (LD 조치 가능)
- Killer 필터 이후 남은 task가 3개 미만
- 복수 주제 + 다양성 쏠림
- 고잠재력 저매칭 task가 top3 내 있음

→ LD에게 안내 + 판단 요청 (위 LD 출력 템플릿 참조)

### Case B (시스템 오류)
- Input 파일 누락 (6개 중 하나라도 없음)
- references/ 파일 접근 실패
- LLM 재시도 2회 모두 실패

→ 템플릿:
```
⚠ Skill 4 실행 중 시스템 오류가 발생했습니다
원인: {구체 사유}
해결: {사용자가 할 수 있는 행동 — 예: "Skill 2 결과를 다시 생성한 후 재실행"}
```

---

## LD 피드백 처리

요약 출력 후 LD 응답에 따라 대응한다. **Skill 4가 임의로 결과를 수정하지 않는다.** LD 의도를 확인한 후 반영한다.

- **"진행해" / "OK"** → Skill 5 (M4 메인 실습 설계)로 진행
- **"top1을 notable의 X로 바꿔줘"** → `top3` 배열에서 교체 + top3-tasks.json 재저장 (final_score 재계산 없이 rank만 조정)
- **"이 task는 빼줘"** → 해당 task 제거 + 차순위 task 승격 (notable에서 가져오거나 다음 후보)
- **"다양성 경고 반영해서 재실행"** → Skill 4 재실행 (이번에는 LD가 일부 task 제외 요청 가능)
- **"다시 평가해줘"** → 전체 Skill 4 재실행

---

## 금지 사항

- **references/ 미독 상태로 판정하지 않는다.** SKILL.md 요약만으로 점수 부여 금지. 반드시 rubric.md·prompts_*.md 전체 Read 후 실행.
- **rubric 라벨을 LD 출력에 그대로 쓰지 않는다.** "새 형태 전환", "직접 매칭" 등은 references·JSON 내부 전용. LD에게는 의미 문장으로 변환 (rubric.md §LD 변환 규칙).
- **"task 전반을 지원", "task 일부 커버" 같은 커버리지 판단**은 Skill 5(M4 설계) 영역. Skill 4 LD 설명에 단정 금지.
- **재질의 결과(missed_feature_estimates)를 v4.primary_score에 합산하지 않는다.** Hallucination 방지를 위해 격리.
- **Killer 탈락 task를 LD 출력에 노출하지 않는다.** `killer_filtered_out` 필드는 JSON 전용. 남은 task가 3개 미만일 때만 경고.
- **K4 판정에 데이터 민감성을 포함하지 않는다.** 데이터 민감성은 합성 데이터로 대체 가능 → Skill 5에서 처리. K4는 task 자체의 본질적 비윤리·불법·안전 직결 실시간 결정만.
- **V2를 가중 평균 하지 않는다.** 5개 proxy 단순 평균 고정 (Phase 1). 파일럿 후 조정 여지.
- **가중치를 임의 변경하지 않는다.** V4=0.45 / V3=0.35 / V2=0.2 고정. 설계도 v7 · 스코어링 설계 §1에 확정됨.
- **타이브레이커 순서 V4 → V3 → 원본 순서**를 임의로 바꾸지 않는다.
- **임의로 top3 후보를 편집하지 않는다.** LD 요청 시에만 수정.
- **점수의 2점·4점을 사용하지 않는다.** V3·V4 모두 4단 앵커 (V3: 1/3/5, V4: 0/1/3/5). 애매하면 하위로 판정 (보수 판정).
- **tool-features.json 외 기능을 주 점수에 사용하지 않는다.** 재질의로 상상한 기능은 별도 필드(missed_feature_estimates)에만 기록.
