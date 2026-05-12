---
name: m4-main-practice-designer
description: curriculum-builder 메인 실습(M4) 설계. Skill 4가 선정한 task(LD가 후보 중 직접 선택, task 미선택·모호 답변 시 top1 fallback)를 받아 해당 툴로 AX화하는 실습 시나리오를 m4-{tool}.md로 생성. Phase 1 순수 설계 — 보안·시수·수준 제약 미반영 (Phase 3 영역).
---

# Skill 5: M4 메인 실습 설계 (Phase 1 순수)

Skill 4가 선정한 task(LD가 5개 후보 중 직접 선택, task 미선택 시 top1)를 **해당 툴로 AX화하는 메인 실습**으로 설계한다.
복수 툴이면 툴별로 `m4-{tool}.md` 1개씩 생성.

**콘텐츠 성격**: 교안(수강생 발화·슬라이드 대본)이 아니라 **모듈 구성 기획**. LD가 "이 M4 모듈에 이런 step·행동·결과가 들어간다"를 판단하는 수준. Skill 6(M3)·Skill 7(M2)과 동일한 성격이되, M4는 실습이므로 가장 구체적 (step별 입력/사용 feature/행동/결과 확인).

## Phase 1 순수 원칙 — 매우 중요

설계도 §1 Phase 구분:
- **Phase 1 = 목적함수**: "시수·수준·**보안 제약 없이**, 이 직무를 이 툴·주제로 AX하기 위해 교육한다면 무엇을 배워야 하는가"의 골자
- **Phase 2 = 표준화**: feature 검증 + 표준 시수 두 세트(short 6h·long 12h) + 톤앤매너 정리 + 모듈별 LD 설명
- **Phase 3 = 운영 제약 반영**: 시수·수강생 수준·보안 등 실제 운영 제약을 LD-Claude 자유 대화로 반영

**Skill 5는 Phase 1**. 따라서:
- **보안 제약 무시** (`input.json.security` 참조 금지)
- **시수·수준 무시** (`input.json.hours`, `level` 참조 금지)
- 이상적 M4를 설계.

## 왜 이 스킬이 필요한가

Top3는 "무엇을 실습할까"의 후보 목록. Skill 5는 그중 하나를 골라 **실제 어떻게 실습할지** 시나리오로 구체화한다. 이후 Skill 6(M3 기초)·Skill 7(M2 When/Why)이 이 M4를 역산 기준으로 활용.

---

## Input

아래 3개 파일을 읽는다. 모두 `{run_folder}/` 하위.

| 파일 | 읽는 필드 |
|---|---|
| `top-tasks.json` | `per_tool` 전체 + 각 top task의 v3/v4/v2·matched_topic·missed_feature_estimates·feature_caveats |
| `tool-features.json` | 각 feature의 name/description/useful_for (시나리오 작성 시 참조) |
| `input.json` | `tools[]`, `topic`, `company`, `role` — **security·hours·level 미사용** |

### 사용하지 않는 필드 (Phase 1 원칙)

- `input.json.security` — Phase 3 영역
- `input.json.hours` — Phase 3 영역
- `input.json.level` — Phase 3 영역
- tool-features.json 각 feature의 `caveats` — Skill 4가 LD 인지용으로 표시함. Skill 5는 이상적 설계라 무시
- `missed_feature_estimates` — 점수에 반영되지 않은 추정치. M4 시나리오에 포함 금지 (hallucination 방지)

---

## Output: m4-{tool}.md

**저장 경로**: `{run_folder}/phase1/m4-{tool_name_safe}.md`

**파일명 규칙**:
- `{tool_name_safe}`: 공백·특수문자를 언더스코어로 치환 (예: "Claude Code" → "Claude_Code")
- 복수 툴이면 툴별 1개씩. 예: `m4-ChatGPT.md`, `m4-Claude_Code.md`
- 단일 툴이면 1개만.

### 파일 구조

```markdown
# M4 메인 실습 — {task_one_liner} ({tool_name})

> 생성 정보
> - Skill 5 (M4 설계) — curriculum-builder
> - 생성일: {YYYY-MM-DD}
> - 대상 툴: {tool_name}
> - 선정 task: {task_id} (top {rank})
> - Phase 1 순수 설계 (보안·시수·수준 미반영 — Phase 3 자유 대화에서 반영)

## 학습 목표

이 실습을 마치면 수강생은 다음을 할 수 있습니다:
- 이 직무의 `{task_one_liner}`를 **{tool_name}**으로 AX화할 수 있다
{matched_topic이 있으면}
- 특히 "{matched_topic}" 맥락에서 이 툴을 실제 업무에 연결할 수 있다

## 실습 환경 전제

- 모든 Step은 **동일한 {tool_name} 대화 세션** 내에서 연속 진행한다 (컨텍스트 유지 필수).
- 중간에 새 세션이 필요한 경우 해당 Step에 명시.
- 세션 길이 초과·맥락 손실 시의 복구 전략은 Phase 3 자유 대화에서 시수·수준에 맞춰 보완.

## 실습 task 선정 근거

**선정**: Top {rank} — `{task_one_liner}`

**스코어링 요약** (Skill 4 산출 기반):
- AI 전환 가치 (V3 {score}점): {V3 의미 문장 — references/rubric.md §5 변환}
- 툴 적합성 (V4 {primary_score}점): {V4 의미 문장}
- 직무 중요도 (V2 {score}점, 평균): {V2 interpretation 요약}

{fallback인 경우}
**Fallback 사유**: Top 1/2는 실습 구현 어려움 — {구체 사유}. Top {rank}으로 대체.

## 실습 시나리오

1. **{Step 1 제목}**
   - 입력: {수강생이 준비할 데이터·정보 — 이상적 환경 기준}
   - 사용 feature: {feature_name}
   - 행동: {구체적 조작 1~2문장}
   - 결과 확인: {어떤 것을 확인하고 다음 단계로}

2. **{Step 2 제목}**
   ...

(일반적으로 3~6 step 권장)

## 사용 feature 목록

| feature | 활용 방식 |
|---|---|
| {feature_name} | {이 실습에서 어떻게 쓰는지 한 줄} |
| ... | ... |

※ 이 feature들이 **M3(기초 실습)의 선행 학습 대상** — Skill 6이 본 문서를 참조하여 기초 사용법을 선행 실습으로 설계.

## 예상 산출물

실습 완료 시 수강생이 얻는 것:
- {구체적 산출물 1}
- {구체적 산출물 2}

## 다음 단계 (Skill 간 인계)

- **Skill 6 (M3 기초 실습)**: 위 "사용 feature 목록" 기반 기초 학습 설계
- **Skill 7 (M2 When/Why)**: 본 M4의 선정 근거를 교육 설명으로 변환
```

---

## 실행 절차 (5 Step)

### Step 1. 파일 로드

`{run_folder}/`에서 top-tasks.json + tool-features.json + input.json 로드.

### Step 2. 툴별 순회

`per_tool` 블록의 각 툴마다 아래 Step 3~5 반복:
- 단일 툴: 1회
- 복수 툴: 툴 수만큼 반복

### Step 3. LD 선택 task 수령 + 실습 가능성 판정 (★ 4/21 회의 결정)

Skill 4가 5개 후보 영역에서 LD에게 직접 선택 받음. **본 Step 3는 LD 선택 task 수령** (LD 선택 X 시 Skill 4 영역에서 top 1 fallback 자동 박음·skill-5는 받기만).

선택 task에 LLM 실습 가능성 판정 적용 — rank 순회 영역 폐기.

**판정 프롬프트**:

```
당신은 이 task를 {tool_name}으로 **실습으로 재현 가능한지** 판정합니다.

[Task 정보]
task_id: {task_id}
one_liner: {task_one_liner}
task_summary: {task_summary}
V4 matches: {v4.matches의 feature_name 목록과 rationale}

[Phase 1 원칙]
- **보안·시수·수준 제약은 무시**하고 이상적 실습 환경을 가정
- task가 실습으로 재현 가능한가?
  - 수강생이 환경 구축·데이터 확보 가능한가 (현실적 규모)
  - V4 matches에 실제 활용할 feature가 있는가
  - 단순 수행을 넘어 교육적 가치가 있는가

[판정]
- "가능" → 이 task로 M4 설계 진행
- "불가" → 사유 명시, 다음 rank로 fallback

**주의**: "보안 제약으로 이 feature 못 쓴다"는 판정 금지 (Phase 3 영역).
"task 자체가 이상적 환경에서도 실습 재현 어렵다"만 불가 사유.

[출력 JSON]
{
  "verdict": "<가능 | 불가>",
  "reason": "<판정 근거 한 문장>"
}
```

**판정 처리**:
- "가능" → 채택·M4 설계 진행
- "불가" → LD 알림 + 다른 후보 선택 요청 (rank 순회 영역 폐기·LD가 5개 후보 영역에서 다른 task 직접 선택)

**일반적으로 LD 선택 task가 채택됨.** Killer(K4/K5)로 이미 실습 불가능 task는 걸러졌으므로 5개 후보 영역 task는 기본 실습 가능 전제.

### Step 4. M4 시나리오 생성 (LLM)

선정된 task로 m4-{tool}.md 내용 생성.

**생성 프롬프트**:

```
당신은 다음 task를 {tool_name}으로 AX화하는 **메인 실습(M4) 시나리오**를 설계합니다.
Phase 1 순수 설계 — 보안·시수·수준 제약 무시, 이상적 환경 가정.

**실습 환경 전제**: 모든 Step은 동일한 {tool_name} 대화 세션 내에서 연속 진행 (컨텍스트 유지).
새 세션 전환이 필요한 경우만 해당 Step에 명시.

[선정 task]
task_id: {task_id}
one_liner: {task_one_liner}
action: {task_cards.action}
inputs: {task_cards.inputs}
immediate_output: {task_cards.immediate_output}

[사용 가능 feature (Skill 4 V4 매칭 기반)]
{v4.matches의 feature_name + rationale 목록}

[전체 tool features — 참조용]
{tool-features.json의 해당 툴 블록 전문}

{matched_topic이 있으면}
[주제 맥락]
matched_topic: {matched_topic}

[출력 형식 — SKILL.md §"Output" 파일 구조 그대로 따름]

**학습 목표**: 2~3개 bullet
**실습 시나리오**: 3~6 step으로 구성
- 각 step에 입력·사용 feature·행동·결과 확인 명시
**사용 feature 목록**: 실제 시나리오에 등장한 것만
**예상 산출물**: 수강생이 얻는 구체적 결과물

[금지]
- feature_caveats 대응 설계 (Phase 3 영역)
- missed_feature_estimates를 시나리오에 포함 (hallucination)
- "보안 제약 때문에 ~"로 시작하는 문장
- 시수 계산 ("N시간 실습")
- ★ 시수·수강생 수준·보안 제약 영역 산출물 박지 X (Phase 3 영역. input.json.security/hours/level 영역 본 산출물 본문에 박지 말 것)
```

### Step 5. 파일 저장 + LD 출력

`m4-{tool_name_safe}.md` 저장 + LD에 자연어 요약 출력.

**LD 출력 템플릿** (툴별로 반복):

```
✅ {tool_name} M4 메인 실습 설계 완료

[선정 task]
Top {rank}: {task_one_liner}
{fallback인 경우 → fallback 사유 명시}

[학습 목표]
이 실습을 마치면 수강생은:
- {학습 목표 1}
- {학습 목표 2}
{matched_topic이 있으면 → 주제 맥락 bullet}

[실습 시나리오]
1. {Step 1 제목}
   {Step 1의 행동·사용 feature·결과 확인을 자연어 2~3문장으로 풀어 설명}

2. {Step 2 제목}
   {Step 2 자연어 설명}

3. ...

(시나리오 step 수만큼 반복)

[사용 feature]
- {feature_name_1}: {이 실습에서의 활용 방식}
- {feature_name_2}: {활용 방식}
...

[예상 산출물]
실습 완료 시 수강생이 얻는 것:
- {산출물 1}
- {산출물 2}

---
산출물 파일: {run_folder}/phase1/m4-{tool_name_safe}.md

※ Phase 1 순수 설계입니다. 보안·시수·수준 제약은 Phase 3 자유 대화에서 재단됩니다.

다음 단계: M3(기초 실습) 설계 — "{feature_name 목록}"의 기초 사용법을 선행 학습으로 설계합니다.
```

**출력 원칙**:
- 각 step의 **행동 내용을 자연어로 충실히 설명** (제목만 나열 금지)
- 학습 목표·사용 feature·예상 산출물 모두 포함해야 LD가 "이 실습이 뭔지" 판단 가능
- 요약·축약 금지 — M4는 커리큘럼 핵심이라 LD가 충분히 내용을 파악해야 함

---

## 실패 처리

### 자동 재시도
LLM 호출 실패 시 최대 2회 재시도.

### Case A (LD 조치 가능)
- top 모두 "불가" 판정 (매우 드묾) → LD에게 알림:
  ```
  ⚠ 이 툴에 대한 M4 설계 불가
  top task 모두 이상적 환경에서도 실습 재현 어려움.
  원인: {LLM 판정 사유 요약}
  → Skill 2·4를 다시 실행하거나 task 리스트를 재검토해주세요.
  ```

### Case B (시스템 오류)
- top-tasks.json·tool-features.json·input.json 누락 → Skill 4 선행 요구 메시지
- LLM 재시도 2회 모두 실패 → 시스템 오류 템플릿

---

## LD 피드백 처리

**기본 = 자동 진행** — Skill 5는 LD 출력 후 응답을 끊지 않고 Skill 6으로 바로 이어간다 (STEP 5~8은 한 턴 안에서 흐르는 구간이라 LD 응답을 받는 지점이 아님 — LD가 끼어들 수 있는 건 다음 주요 확인 포인트인 Phase 1 조합 끝). 만일 LD가 능동적으로 개입하면 아래대로 반영:

- **"OK" / "진행해" / "계속"** → Skill 6 (M3 기초 실습)으로 진행
- **"다른 후보로 바꿔줘"** → LD가 5개 후보 영역에서 다른 task 직접 선택 → 해당 task로 M4 재생성 + m4-{tool}.md 덮어쓰기
- **"실습 시나리오 다르게 작성해줘"** → Step 4 재실행 (프롬프트에 LD 요청 반영)
- **"feature X 대신 Y를 써줘"** → 재실행

Skill 5는 **임의로 결과 변경 금지**. LD 요청 시만 수정.

---

## 금지 사항

- **교안 수준 서술 금지** — 수강생 발화, 슬라이드 대본, "여러분은 이제..." 같은 강의 스크립트 형태 X. **모듈 구성 기획 수준**(step별 입력·행동·결과 서술)에 머물 것. Skill 6(M3)·Skill 7(M2)과 동일한 성격
- **보안 제약 고려 금지** (Phase 1 원칙) — `input.json.security` 읽지 않음
- **시수·수준 고려 금지** (Phase 1 원칙) — `hours`·`level` 읽지 않음
- **feature_caveats 대응 설계 금지** — Skill 4가 LD 인지용으로 ⚠ 표시. Skill 5는 이상적 설계라 무시. 대응은 Phase 3 영역
- **missed_feature_estimates 시나리오 포함 금지** — hallucination 방지. Skill 4가 점수에서 격리한 것을 M4에서 되살리면 안 됨
- **Killer 탈락 task 사용 금지** — top에만 집중
- **임의 task 교체 금지** — LD 요청 시만
- **시간 표기 금지** — "2시간 실습" 등 시수 추정 시도 금지. Phase 2 영역
- **"파일 업로드 차단 시" 등 조건부 대응 서술 금지** — Phase 3 영역
- **★ 시수·수강생 수준·보안 제약 영역 산출물 박지 X 금지** — Phase 3 영역 (input.json.security/hours/level 영역 산출물 본문에 박지 말 것). LD가 input.json 자체 영역에서 별도 검토
