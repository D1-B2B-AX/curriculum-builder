---
name: m2-when-why-designer
description: curriculum-builder M2(When/Why) 모듈 구성 기획. Skill 4 스코어링 근거와 Skill 5·6 산출물을 받아, "언제(When) 이 툴을 쓰고, 왜(Why) 적합한가"를 다루는 M2 모듈의 **강의 구성 제안**을 꼭지별로 작성. 교안이 아니라 LD가 "이 모듈에 이런 꼭지가 들어간다"를 판단하는 기획 수준. Phase 1 순수 설계 (보안·시수·수준 미반영).
---

# Skill 7: M2 When/Why 모듈 구성 (Phase 1 순수)

## 역할

Skill 4가 평가한 "이 task에 이 툴이 왜 top인가"의 근거(V3/V4/V2 rationale)를 바탕으로 **M2 모듈의 강의 구성 기획**을 작성한다. 수강생이 M3·M4로 넘어갈 때 **"왜 이걸 배우는지"**를 납득하게 하는 도입부 모듈.

**실행 순서**: Skill 5(M4)·Skill 6(M3) 이후 실행. M2→M3→M4 학습 흐름을 전제로 구성.

### M2의 공식 정의 (설계도 §1)
- **When = task 자체**: 이 툴을 어떤 task·상황에 쓰는가
- **Why = 스코어링 근거**: 왜 이 툴이 이 task에 적합한가

### M2의 콘텐츠 성격 — 매우 중요
- **교안(수강생 발화·슬라이드 대본·강의 스크립트) X**
- **모듈 구성 기획 수준**: LD가 "이 M2 모듈이 이런 꼭지들로 구성된다"를 한눈에 파악
- 최종 커리큘럼 표로 옮길 때 꼭지 제목·요약이 **M2 bullet 소재**로 활용

## Phase 1 순수 원칙

- **보안·시수·수준 미반영** (Phase 3 영역)
- **rubric 라벨 사용 금지** — rubric.md §5 LD 변환 규칙의 의미 문장 그대로
- **커버리지 표현 금지** — "task 전반/일부" 판단은 Skill 5 영역
- **feature_caveats는 LD 인지용 "※ 참고" 표시만** (대응 설계 X, Phase 3 영역)
- **missed_feature_estimates 참조 금지** — hallucination 격리

---

## Input

| 파일 | 읽는 필드 | 용도 |
|---|---|---|
| `top-tasks.json` (`{run_folder}/` 직속) | `per_tool[tool].top[0]` 전체 | Why 핵심 근거 |
| `phase1/task-research/task-cards.json` | 선정된 task의 trigger_text, cadence, action_text | When 업무 맥락 |
| `tool-features.json` (`{run_folder}/` 직속) | 매칭 feature의 description·useful_for·caveats | 꼭지 2 근거 |
| `phase1/m4-{tool}.md` (Skill 5 산출) | "실습 시나리오" + "사용 feature 목록" | M4 연결 |
| `phase1/m3-{tool}.md` (Skill 6 산출) | "기초 실습 시나리오" feature 목록 | M3 연결 |
| `input.json` (`{run_folder}/` 직속) | tools, topic, company, role, matched_topic 참조 | 실행 맥락 |

### 사용하지 않는 필드
- `input.json.security/hours/level` — Phase 3 영역
- `missed_feature_estimates` — hallucination 격리

---

## Output: m2-{tool}.md

**저장 경로**: `{run_folder}/phase1/m2-{tool_name_safe}.md`

파일명 규칙은 Skill 5·6과 동일.

### 파일 구조 (주 본문 = 강의 구성 제안)

```markdown
# M2 (When/Why) — {task_one_liner} ({tool_name})

> 생성 정보
> - Skill 7 (M2 설계) — curriculum-builder
> - 생성일: {YYYY-MM-DD}
> - 대상 툴: {tool_name}
> - Phase 1 순수 설계 (보안·시수·수준 미반영 — Phase 3 자유 대화에서 반영)
> - **수강 흐름**: M1(툴 소개) → **M2(When/Why)** → M3(기초) → M4(메인 실습)

## 학습 목표

이 M2 모듈을 마치면 수강생은:
- 이 직무에서 **언제(When)** 이 툴을 떠올리고 써야 유용한지 안다
- **왜(Why)** 이 툴이 이 task에 적합한지 납득한다
- M3·M4로 이어지는 학습의 동기와 맥락을 확보한다

## 배경 근거 (LD 검토용)

### When — 업무 맥락 요약
{1~2문장}: task-cards의 trigger_text와 cadence, V2 breakdown의 duration/centrality를 자연어로 합친 맥락.

### Why — 스코어링 근거 요약

- **AI 전환 가치 (V3 {score}점)**: {rubric.md §5 V3 의미 문장}
  근거: {v3.rationale을 1~2문장 요약}
- **툴 적합성 (V4 {primary_score}점)**: {rubric.md §5 V4 의미 문장}
  근거: 매칭 기능 — {feature_name 목록, 각각 rationale 핵심 1줄}
  {feature_caveats 있으면 각 feature 뒤에 "※ 참고: {caveats}"}
- **직무 중요도 (V2 {score}점)**: 빈도 {frequency.interpretation} / 소요시간 {duration.interpretation} / 출처 {source_trust.interpretation} / 중심성 {centrality.interpretation} / 주제 정합 {topic_fit.interpretation}
  ※ proxy 지표라 실제 중요도와 다를 수 있음

## 강의 구성 제안 (M2 모듈의 주 본문)

M2 강의는 아래 3~5개 꼭지로 구성:

### 꼭지 1. {제목}
{2~4줄 설명}: 이 꼭지에서 다룰 내용·핵심 메시지·예시 상황을 서술. 교안 수준 아님, 모듈 구성 기획 수준.

### 꼭지 2. {제목}
{2~4줄 설명}

...

### 꼭지 N. {제목}
{2~4줄 설명}

## M3 · M4 학습 흐름 연결

본 M2는 **왜 배우는지** 납득시키는 단계. 이후 수강생은:

- **M3 기초 실습**: {m3-{tool}.md의 기초 실습 feature 목록} 각각의 기본 사용법 체득
- **M4 메인 실습**: 위 기초를 통합하여 `{task_one_liner}` 수행

즉 **M2(왜) → M3(기본기) → M4(실전)** 흐름.
```

### 꼭지 설계 가이드 (매우 중요)

**꼭지 수**: 3~4개. task·툴·근거의 풍부함에 따라 조정. 수강 흐름 안내 꼭지(M2 → M3 → M4 학습 흐름 안내)는 포함하지 않는다 — 메타 영역, 실제 학습 내용 X.

**전형적 꼭지 구성**:
1. 이 task가 왜 AI를 필요로 하는가 (V3 근거 풀이)
2. 이 툴의 어떤 기능이 이 task에 맞는가 (V4 matches 풀이)
3. 이 task를 실무에서 만나는 전형적 상황 (When 풀이)
4. 업무 흐름 내 위치 (V2 proxy 풀이)

위는 **전형적 예시**이고, task·V3·V4·V2 특성에 따라 꼭지 수·제목이 달라질 수 있음. LLM이 쓰기 나름. 단 수강 흐름 안내 꼭지는 어떤 형태로도 포함하지 않는다.

**각 꼭지 작성 원칙**:
- **제목**: 교육·기획 표현 (예: "이 task가 왜 AI를 필요로 하는가")
- **설명 (2~4줄)**: 이 꼭지에서 다룰 **내용·핵심 메시지·예시 상황** 서술
- **교안 수준 X**: 수강생 발화, 슬라이드 대본, "안녕하세요 여러분..." 같은 강의 스크립트 쓰지 않음
- **LD 관점**: "이 모듈에 이런 내용이 들어간다"를 기획 수준으로
- **Skill 4 근거 내 창작 금지** — rationale에 없는 새 근거를 상상해서 쓰면 안 됨

---

## 실행 절차 (5 Step)

### Step 1. 파일 로드
`{run_folder}/` 직속에서 top-tasks.json·tool-features.json·input.json, `{run_folder}/phase1/task-research/`에서 task-cards.json, `{run_folder}/phase1/`에서 m4-{tool}.md·m3-{tool}.md 로드.

**툴별 순회** — 각 툴에 대해 Step 2~4 반복.

### Step 2. 선정 task 확인
`m4-{tool}.md`의 "실습 task 선정 근거" 섹션에서 task_id 파싱 → `per_tool[tool].top3`에서 해당 task의 v3/v4/v2 전체 데이터 확보.

### Step 3. M2 모듈 구성 기획 생성 (LLM)

**생성 프롬프트**:

```
당신은 {tool_name}의 **M2(When/Why) 모듈 구성 기획**을 작성합니다.
목적: 수강생이 "왜 이 task에 이 툴을 쓰는지" 납득하게 하는 M2 도입부 모듈.

**중요**: 교안(수강생 발화·슬라이드 대본)이 아님. **LD가 "이 모듈에 이런 꼭지가 들어간다"를 판단할 수 있는 모듈 구성 기획 수준**으로.

[선정 task — top-tasks.json 기반]
task_id: {task_id}
one_liner: {task_one_liner}
v3 score/label/rationale: ...
v4 primary_score/matches (feature_name + rationale + feature_caveats): ...
v2 score/breakdown (5개 proxy의 score + interpretation): ...
matched_topic: {matched_topic or null}

[업무 맥락 — task-cards.json]
trigger_text, cadence, action_text

[tool-features 상세]
해당 툴 블록 전문

[M4·M3 연결 참조]
- M4 task: {task_one_liner}
- M4 시나리오 요약
- M3 기초 학습 feature 목록

[설계 원칙 — Phase 1 순수]
1. 배경 근거(When/Why) 섹션은 **요약만** (LD 검토용, 길게 쓰지 않음)
2. **강의 구성 제안 섹션이 주 본문** — 3~5개 꼭지로 구성
3. 각 꼭지: 제목 + 다룰 내용·핵심 메시지·예시 상황 2~4줄
4. **교안 수준 금지** — 수강생 발화, 슬라이드 대본 X. 모듈 구성 기획 수준
5. rubric 라벨 사용 금지 — rubric.md §5 의미 문장 사용
6. 커버리지 표현 금지 — "task 전반/일부" X
7. feature_caveats → "※ 참고: ..." 표시만 (대응 설계 X)
8. missed_feature_estimates 참조 금지
9. Skill 4 rationale에 없는 근거 창작 금지 — 풀이는 OK, 창작은 X
10. matched_topic이 null이 아니면 꼭지에 주제 맥락 반영

[출력 형식]
SKILL.md §"파일 구조" 템플릿 그대로. 학습 목표 / 배경 근거 / **강의 구성 제안 (꼭지별)** / M3·M4 흐름 순서.
```

### Step 4. 파일 저장
`m2-{tool_name_safe}.md`로 저장.

### Step 5. LD 자연어 요약 출력

**LD 출력 템플릿** (툴별 반복):

```
✅ {tool_name} M2 (When/Why) 모듈 구성 완료

[대상 task]
{task_one_liner}

[배경 근거]
- When: {업무 맥락 1~2문장 요약}
- Why:
  · AI 전환 가치 (V3 {score}점): {V3 의미 문장}
  · 툴 적합성 (V4 {primary_score}점): {V4 의미 문장}
    관련 기능: {feature_name 목록}
    {feature_caveats 있는 매칭만 ⚠ 참고 한 줄씩}
  · 직무 중요도 (V2 {score}점): {5 proxy interpretation 요약 2~3줄}
    ※ proxy 지표라 실제 중요도와 다를 수 있음

[강의 구성 제안]  ← M2 모듈의 실제 내용

1. {꼭지 1 제목}
   {꼭지 1 설명 2~4줄 그대로}

2. {꼭지 2 제목}
   {꼭지 2 설명 그대로}

3. {꼭지 3 제목}
   {꼭지 3 설명 그대로}

(꼭지 수만큼 반복)

[학습 흐름]
M2(왜) → M3(기초 feature 익히기) → M4(실전). M3에서 익힐 기능: {m3 feature 목록}

---
산출물 파일: {run_folder}/phase1/m2-{tool_name_safe}.md

※ Phase 1 순수 설계입니다. 강의 시수·예시 깊이·발화 수준은 Phase 3 자유 대화에서 시수·수준에 맞춰 재단됩니다.

다음 단계: M1(툴 소개) 설계 — 다른 세션에서 Skill 8이 담당
```

**출력 원칙**:
- **강의 구성 제안은 꼭지별 내용 전체 노출** (md 파일과 동일 분량) — LD가 CC 대화창만 보고도 판단 가능해야 함
- **배경 근거는 요약만** (상세는 md)
- 학습 흐름 연결은 간결 1~2줄

---

## 실패 처리

### 자동 재시도
LLM 호출 실패 시 최대 2회 재시도.

### Case A (LD 조치 가능)
- `m4-{tool}.md` or `m3-{tool}.md` 파싱 실패 → Skill 5·6 재실행 유도

### Case B (시스템 오류)
- top-tasks.json / task-cards.json / m4·m3 파일 누락 → 해당 선행 스킬 실행 요구

---

## LD 피드백 처리

**기본 = 자동 진행** — Skill 7은 LD 출력 후 응답을 끊지 않고 Skill 8(또는 Phase 1 조합)로 바로 이어간다 (STEP 5~8은 한 턴 안에서 흐르는 구간이라 LD 응답을 받는 지점이 아님 — LD가 끼어들 수 있는 건 다음 주요 확인 포인트인 Phase 1 조합 끝). 만일 LD가 능동적으로 개입하면 아래대로 반영:

- **"OK" / "진행해" / "계속"** → Skill 8 (M1 툴 소개) 진행 / 또는 Phase 1 조합
- **"꼭지 N을 다르게"** → 해당 꼭지만 재생성
- **"꼭지를 추가/삭제"** → 재실행 (LD 요청 반영)
- **"강의 구성 더 풍부하게"** → 재실행 (각 꼭지 설명 확장)

Skill 7은 임의 변경 금지. LD 요청 시만 수정.

---

## 금지 사항

- **교안 수준 서술 금지** — 수강생 발화, 슬라이드 대본, "여러분은 이런 경험..." 같은 강의 스크립트 형태 X. **모듈 구성 기획 수준**에 머물 것
- **rubric 라벨 사용 금지** — "질적 전환"·"직접 매칭" 등은 내부 용어. rubric.md §5 의미 문장 그대로
- **커버리지 표현 금지** — "task 전반/일부 지원"은 Skill 5 영역
- **V2 proxy caveats 제거 금지** — "간접 측정" 주의 문구 유지
- **feature_caveats 대응 설계 금지** — "※ 참고" 형식 표시만 (대응은 Phase 3 영역)
- **missed_feature_estimates 참조 금지** — hallucination 위험 추정치는 M2에 포함 X
- **구체 시간·분량 수치 금지** — "2시간 강의", "15분 설명" 등
- **구체 입력 수치 금지** — 배경 근거·꼭지 설명에도 "N건", "N턴" 같은 수치 금지. Phase 2 영역
- **Skill 4 rationale 내 창작 금지** — 근거에 없는 새 근거를 상상해서 쓰면 안 됨. 풀어서 설명은 OK, 창작은 X
- **보안·시수·수준 고려 금지** (Phase 1 원칙)
- **★ 시수·수강생 수준·보안 제약 영역 산출물 박지 X 금지** — Phase 3 영역 (input.json.security/hours/level 영역 산출물 본문에 박지 말 것). LD가 input.json 자체 영역에서 별도 검토
- **★ 수강 흐름 안내 꼭지 금지** — M1~M4 연결 설명·M2 → M3 → M4 학습 흐름 안내는 메타 영역, 실제 학습 내용 X. 어떤 형태(꼭지 4·꼭지 5·꼭지 N)로도 포함하지 않는다. 학습 흐름 자체는 SKILL.md 파일 구조의 §"M3 · M4 학습 흐름 연결" 섹션에 이미 박힘. skill-8(M1) spec 동일 정신
