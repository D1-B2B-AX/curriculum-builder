# references/rubric.md — 점수 매핑·규칙·LD 변환

Skill 4의 **LLM 호출 없이 기계적으로 참조**되는 규정 모음.
- V3/V4/V2 점수 매핑표
- V4 인용 규칙
- K1/K2/K3 필드 체크 규정
- LD 친화 변환 규칙

---

## 1. V3 점수 rubric (4단 앵커, 2·4점 미사용)

| 점수 | label (내부 JSON 전용) | 판정 기준 |
|---|---|---|
| 1 | 속도 절감 | 기존에 사람이 하던 일의 시간만 단축. 결과물 형태·품질·스케일 동일. |
| 3 | 품질 개선 | 사람이 놓칠 수 있는 것을 AI가 일관·정확하게 식별. 결과물 품질 향상. |
| 5 | 질적 전환 | 사람이 수작업으로는 사실상 불가능한 일이 가능해짐. 규모·속도·정밀도의 전환. |

**보수 판정**: 2점·4점 금지. 애매하면 하위 점수로 판정.

---

## 2. V4 점수 rubric (4단 앵커, V4만 0점 허용)

| 점수 | 판정 기준 |
|---|---|
| 0 | 매칭되는 feature 0개, 또는 모든 매칭이 인용 실패로 무효 |
| 1 | 우회 매칭 1~2개만 (직접 매칭 없음) |
| 3 | 직접 매칭 1개 또는 부분 매칭 2~3개 |
| 5 | 직접 매칭 2개 이상 + 핵심 행위 전반 커버, 각 매칭에 명확한 인용 |

### 매칭 강도 3단 정의

| 강도 | 정의 |
|---|---|
| 직접 | feature가 task의 핵심 행위를 그대로 수행 |
| 부분 | feature가 task의 일부(준비·보조 단계)만 수행 |
| 우회 | feature의 일반 능력(추론·종합·탐색·변환 등)을 활용해 task에 간접 적용 가능 |

### V4 인용 규칙 (매우 중요)

각 매칭마다 **아래 4요소를 반드시 반환**:

1. `feature_name` — tool-features.json의 name (정확히 일치)
2. `task_quote` — task 서술(action/inputs/immediate_output)에서 이 feature가 지원하는 구체 부분 (원문 인용)
3. `strength` — "직접" / "부분" / "우회" 중 택1
4. `rationale` — 어떻게 지원하는지 한 줄

**위반 시**:
- task_quote 없이 매칭 주장 → 해당 매칭 **무효**. matches 배열에서 제외
- 모든 매칭이 무효 → `primary_score = 0`

### V4 매칭 metadata — feature_caveats 동반 기록

각 매칭 객체에 **`feature_caveats` 필드를 추가**해 tool-features.json의 해당 feature `caveats` 값을 **그대로 복사**한다. null이면 null 유지.

- **목적**: LD가 top3 결과를 볼 때 실행 환경 제약(파일 업로드 불가·유료 플랜 한정 등)을 바로 인지
- **점수 영향**: `primary_score`에 **반영 X**. 순수 metadata
- **실제 충돌 판단**: Skill 4는 feature_caveats와 input.json.security 충돌 여부를 판단하지 않음. **Skill 5(M4 설계) 영역**으로 명시 분리

---

## 3. V2 proxy 점수 매핑 (5개 proxy, 단순 평균)

### ① frequency (task-cards.json의 cadence 직접 매핑)

| cadence | 점수 | interpretation 예시 |
|---|---|---|
| 매일 | 5 | "매일 반복" |
| 주 | 4 | "주 단위 반복" |
| 월 | 3 | "월 단위 반복" |
| 분기 | 2 | "분기 단위" |
| 연·비정기 | 1 | "연 1회 또는 드문 빈도" |

### ② duration (LLM 추정 → 점수 매핑, prompts_v2.md 참조)

| LLM 판정 duration_band | 점수 | interpretation 예시 |
|---|---|---|
| 하루 이상 (>4h) | 5 | "1회 하루 이상 몰두" |
| 반일 (2~4h) | 4 | "1회 반일 소요" |
| 1~2시간 | 3 | "1회 1~2시간" |
| 30분 이내 | 2 | "1회 30분 이내" |
| 몇 분 | 1 | "1회 몇 분" |

### ③ source_trust (company-role-task-research의 source_tier 직접 매핑)

| source_tier | 점수 | interpretation 예시 |
|---|---|---|
| A (공식 JD, 채용공고) | 5 | "공식 JD 명시" |
| B (실무 블로그, 업계 보고서) | 3 | "실무 자료 확인" |
| C (일반 웹, 추론) | 1 | "일반 웹 정보" |
| D·E (약한 증거) | 0 | "추정 수준" |

### ④ centrality (workflow.json의 DAG in+out 연결 수 매핑)

**계산 방법**: `workflow.json`의 `edges` 배열에서 해당 task_id가 `from_task_id` 또는 `to_task_id`로 등장하는 **총 횟수** (방향 무관 in+out 합계).

예: `edges`에 `{from: td_004, to: td_005}`, `{from: td_004, to: td_018}` 두 건이면 td_004의 centrality = 2.

| 연결 수 | 점수 | interpretation 예시 |
|---|---|---|
| 4+ | 5 | "허브 위치 (4개 이상 연결)" |
| 3 | 4 | "중심성 높음 (3개 연결)" |
| 2 | 3 | "평균 (2개 연결)" |
| 1 | 1 | "주변부 (1개 연결)" |
| 0 | 0 | "고립 (연결 없음)" |

**주의**: workflow.json의 `task_order`, `stream_label`, `is_entry_point`, `is_exit_point` 필드는 centrality 계산에 사용하지 않는다. **edges 배열만** 사용.

### ⑤ topic_fit (LLM 판정 → 점수 매핑, prompts_v2.md 참조)

| LLM 판정 fit | 점수 | interpretation 예시 |
|---|---|---|
| 직접 관련 | 5 | "입력 주제 직접 관련" |
| 인접 관련 | 3 | "입력 주제 인접 관련" |
| 무관 | 0 | "입력 주제 무관" |

### V2 결합

`v2.score = (① + ② + ③ + ④ + ⑤) / 5` — **단순 평균**.

### V2 caveats (고정 문구)

```json
[
  "소요시간은 LLM 추정. 정확한 시간 측정 아님.",
  "proxy 기반 추정. 빈도·중심성 등이 실제 중요도와 일치하지 않을 수 있음."
]
```

---

## 4. Killer Criteria K1/K2/K3 필드 체크 (LLM 호출 없음)

### K1 — DNA 분류 규칙 위반

task-dna.json의 해당 task 항목에서 **`review_flags` 배열**을 확인.

건호님 `task-dna-classification` 스킬의 공식 enum (`~/.claude/skills/task-dna-classification/references/stage4-rules.md §Review flags` 기준):

| 플래그 | 의미 | K1 처리 |
|---|---|---|
| `ontology_boundary` | domain 또는 primitive_lv2 경계에 위치 | **pass** (분류 애매하나 수행됨) |
| `mechanism_mismatch` | mechanism이 primitive와 자연스럽게 맞지 않음 | **pass** (품질 경고이나 분류 수행됨) |
| `anchor_violation` | 증거가 Stage 3 할당 phase/primitive_lv1과 다름 시사 | **K1 발동** (분류 근본적 불일치) |
| enum 외 플래그 (예: `phase_boundary`) | 다른 스테이지(task-atomization 등) 파생 플래그 | **pass** (분류 실패 아님) |
| `[]` (빈 배열) | 정상 | **pass** |

**K1 발동 조건**: `review_flags` 배열에 **`anchor_violation`이 포함되어 있을 때**. 나머지는 모두 pass.

K1 발동 시 `reason`에 `"review_flags: anchor_violation (phase/primitive 불일치 증거)"` 기록.

**건호님 enum 확장 시**: 새 플래그가 추가되면 본 표 업데이트 필요. 정체 불명 플래그는 보수적으로 pass 처리 (false positive 방지).

### K2 — DNA 핵심 분류값 공백

task-dna.json의 해당 task 항목에서 다음 필드 중 **하나라도 null/빈 문자열**:
- `primitive_lv1`, `primitive_lv2`
- `domain_lv1`, `domain_lv2`
- `mechanism_lv1`, `mechanism_lv2`

(Skill 2 v3+ 기준 모두 필수 필드)

**제외 — K2 대상 아님**: `secondary_mechanism_lv1`, `secondary_mechanism_lv2`는 **optional 필드**로 null 허용. `full_code`, `rationale`, `dna_confidence`도 보조 필드라 K2 대상 아님.

K2 발동 시 `reason`에 어떤 필드가 비어있는지 기록 (예: `"primitive_lv2 누락"`).

### K3 — trigger·immediate_output 공백

task-cards.json의 해당 task 항목에서:
- `trigger` 필드 null 또는 빈 문자열
- 또는 `immediate_output` 필드 null 또는 빈 문자열

위 중 하나라도 공백이면 K3 발동. `reason`에 어떤 필드가 공백인지 기록.

### K4, K5

K4/K5는 LLM 판단 필요. `prompts_killer.md` 참조.

### Killer 탈락 기록 형식

```json
{
  "task_id": "T003",
  "killer_rule": "K2",
  "reason": "primitive_lv2 누락"
}
```

---

## 5. LD 친화 변환 규칙

### 원칙

내부 rubric 라벨·필드명은 references·JSON 전용. **LD 출력은 의미 문장으로 변환 강제.**

### V3 변환 (rubric label → LD 의미 문장)

| 점수 | label (JSON 전용) | LD 출력 문장 |
|---|---|---|
| 1 | 속도 절감 | 기존에 사람이 하던 일의 시간을 줄여주는 task |
| 3 | 품질 개선 | 사람이 놓칠 수 있는 것을 AI가 일관되게 잡아주는 task |
| 5 | 질적 전환 | 사람이 수작업으로는 어려웠던 일을 AI가 가능하게 하는 task |

### V4 변환 (점수 → LD 의미 문장, 관련성 축 일관)

| 점수 | LD 출력 문장 |
|---|---|
| 0 | 현재 조사된 이 툴의 기능 중 이 task와 관련된 것이 없음 |
| 1 | 이 툴의 기능이 이 task와 약하게 관련 있음 (간접적 활용) |
| 3 | 이 툴의 기능이 이 task와 직접 관련 있음 (중간 수준) |
| 5 | 이 툴의 여러 기능이 이 task에 직접 적용 가능 (강한 관련) |

**금지 표현**: "task 전반을 지원", "task 일부 커버" — 커버리지 판단은 Skill 5(M4 설계) 영역이므로 Skill 4 LD 설명에 단정 금지.

### V4 matches의 strength 변환 (LD 노출 시)

strength 라벨("직접", "부분", "우회")은 내부 JSON 전용. LD 출력 시 "관련 기능: {feature_name}" 수준으로만 표시하고 강도는 V4 종합 점수의 의미 문장으로 흡수.

### V2 변환

V2는 각 proxy의 `score + interpretation` 쌍을 **그대로** LD 출력. caveats 포함.

### Killer 탈락 미노출

LD 출력에 **표시하지 않음** (정보 과부하 방지). 탈락 多로 남은 task 3개 미만일 때만 경고.

### 고잠재력 저매칭 (high_potential_low_match) 표시

- top3 **안**에 있는 경우: 해당 task 안내 섹션에 "⚠ AI 전환 가치는 크지만 툴 매칭 약함. 재설계 검토 권장" + missed_feature_estimates 일부 공개
- top3 **밖** (notable_outside_top3): 별도 "주목할 task" 섹션으로 표시

상세 출력 형식은 SKILL.md §"LD 출력 템플릿" 참조.
