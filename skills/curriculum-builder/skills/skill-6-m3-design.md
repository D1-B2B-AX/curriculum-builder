---
name: m3-fundamental-practice-designer
description: curriculum-builder 기초 실습(M3) 설계. Skill 5가 만든 m4-{tool}.md를 읽어 M4에서 쓰는 feature 각각에 대한 기초 사용법 mini 실습을 m3-{tool}.md로 생성. Phase 1 순수 설계 — 보안·시수·수준 제약 미반영 (Skill 9 Phase 2 영역).
---

# Skill 6: M3 기초 실습 설계 (Phase 1 순수)

Skill 5의 M4 메인 실습에서 **사용되는 feature 각각에 대해 기초 사용법 mini 실습**을 설계한다.
M4에서 역산하므로 **M4에 등장하지 않는 feature는 다루지 않는다**.

**콘텐츠 성격**: 교안(수강생 발화·슬라이드 대본)이 아니라 **모듈 구성 기획**. LD가 "이 M3 모듈에 이런 mini 실습이 들어간다"를 판단하는 수준. Skill 5(M4)·Skill 7(M2)과 동일한 성격이되, M3은 기초 실습이므로 M4보다 단순·독립적.

## 왜 이 스킬이 필요한가

M4는 여러 feature를 통합·응용하는 실습. 처음 이 툴을 접하는 수강생이 바로 M4를 수행하기에는 느리고 좌절 가능. M3에서 각 feature를 **짧은 mini 실습으로 먼저 체득**하면 M4 수행이 자연스러워진다.

**역산 원칙**: M4에서 안 쓰는 feature는 가르치지 않는다. 시간·에너지 절약.

## Phase 1 순수 원칙

Skill 5와 동일:
- **보안 제약 무시** (`input.json.security` 참조 금지)
- **시수·수준 무시** (`input.json.hours`, `level` 참조 금지)
- feature_caveats 무시 (Skill 4가 LD 인지용으로 표시. Skill 9 영역)
- missed_feature_estimates 무시

---

## Input

아래 3개를 읽는다. 모두 `curriculum-builder-output/{run_folder}/` 하위.

| 파일 | 읽는 필드 |
|---|---|
| `m4-{tool}.md` (Skill 5 산출) | **"사용 feature 목록"** 섹션 — 각 feature_name + 활용 방식. **"실습 시나리오"** 섹션 — M4 맥락 파악용 참조 |
| `tool-features.json` | 각 feature의 name / description / useful_for (기초 실습 시나리오 작성 시 활용) |
| `input.json` | `tools[]`, `topic`, `company`, `role` — **security·hours·level 미사용** |

### 사용하지 않는 필드

- `input.json.security/hours/level` — Phase 2 영역
- `tool-features.json`의 feature `caveats` — Phase 2 영역
- `top3-tasks.json`의 `missed_feature_estimates` — hallucination 격리 유지
- M4 파일의 "Skill 9 인계" 섹션 — Skill 9이 사용

---

## Output: m3-{tool}.md

**저장 경로**: `curriculum-builder-output/{run_folder}/m3-{tool_name_safe}.md`

- 파일명 규칙은 Skill 5와 동일 (`{tool_name}` 공백·특수문자는 언더스코어로 치환)
- 복수 툴이면 툴별 1개씩

### 파일 구조

```markdown
# M3 기초 실습 — {tool_name} feature 기초 학습

> 생성 정보
> - Skill 6 (M3 설계) — curriculum-builder
> - 생성일: {YYYY-MM-DD}
> - 대상 툴: {tool_name}
> - M4에서 역산 설계 (본 툴의 M4 task: `{task_one_liner}`)
> - Phase 1 순수 설계 (보안·시수·수준 미반영 — Skill 9 Phase 2에서 재단)

## 학습 목표

이 기초 실습을 마치면 수강생은:
- M4 메인 실습에 필요한 **{tool_name}의 {N}개 핵심 기능**을 독립적으로 다룰 수 있다
- 각 기능의 "입력 → 처리 → 출력" 흐름을 손에 익힌다

## 실습 환경 전제

- 각 mini 실습은 **{tool_name}의 짧은 단일 세션**에서 독립적으로 진행 가능
- 실습 간 컨텍스트 이어질 필요 없음 (M3는 feature별 독립 체득)
- 모든 mini 실습 완료 후 M4로 이동

## M4와의 연결

본 M3은 다음 M4 실습의 **선행 학습**:
- M4 task: `{task_one_liner}`
- M4에서 통합 활용할 feature: {feature_name 목록}

## 기초 실습 시나리오

### 실습 1: {feature_name_1} 기초

- **학습 포인트**: 이 기능이 무엇을 하는지, 기본 사용 흐름 이해
- **사용 feature**: {feature_name_1}
- **mini 입력**: {간단한 예시 입력 — M4보다 훨씬 작은 규모}
- **행동**: {구체 조작 1~2문장}
- **결과 확인**: {어떤 결과가 나와야 이 기능을 이해한 것으로 판단}
- **M4 연결**: M4 Step {N}에서 "{M4에서의 활용 방식}"로 사용됨

### 실습 2: {feature_name_2} 기초

(동일 구조 반복)

...

(M4에 등장하는 feature 수만큼 반복)

## 다음 단계 (Skill 간 인계)

- **Skill 5 (M4 메인 실습)**: 본 M3에서 체득한 feature들을 **통합·응용**하여 실제 직무 task 수행
- **Skill 9 (Phase 2)**: 본 M3을 아래 제약에 맞춰 재단 (**`input.json` 값 그대로 인용**):
  - 시수: {input.json.hours}시간
  - 수강생 수준: {input.json.level}
  - 보안 제약: {input.json.security}

  Skill 9이 위 실제 제약 기반으로 각 mini 실습의 분량·순서·데이터 접근 방식 조정.
```

### 템플릿 채움 규칙

- **Skill 9 인계 섹션의 hours/level/security**: `input.json`에서 **그대로 복사**. 임의 추정 금지. null/공백이면 "(미입력)".
- **feature 순서**: M4 실습 시나리오 Step 순서대로 배열 (M4에서 먼저 쓰이는 feature가 M3 실습 1)
- **mini 입력 규모**: M4보다 훨씬 작게 — 예: M4가 "VOC 데이터 500건 분석"이면 M3은 "샘플 VOC 5건 요약"

---

## 실행 절차 (5 Step)

### Step 1. 파일 로드

`curriculum-builder-output/{run_folder}/`에서 `m4-{tool}.md`, `tool-features.json`, `input.json` 로드.
**툴별 순회** — 각 툴의 `m4-{tool}.md`를 읽어 Step 2~5 반복.

### Step 2. M4에서 사용 feature 목록 추출

`m4-{tool}.md`의 "사용 feature 목록" 섹션에서 feature_name과 활용 방식 파싱.

### Step 3. M3 mini 실습 시나리오 생성 (LLM)

**생성 프롬프트**:

```
당신은 {tool_name}의 **기초 사용법 mini 실습**을 설계합니다.
목적: 수강생이 M4 메인 실습(아래 참조)에 필요한 feature들을 **각각 독립적으로** 먼저 익히는 것.

[M4 메인 실습 맥락]
- M4 task: {task_one_liner}
- M4 시나리오 요약: {m4-{tool}.md의 실습 시나리오 섹션 전문}
- M4에서 쓰는 feature 목록: {feature_name과 활용 방식 리스트}

[tool-features.json 참조 — feature 상세]
{tool-features.json의 해당 툴 features 전문 (description, useful_for)}

[M3 설계 원칙 — Phase 1 순수]
1. **M4에 등장한 feature만 다룬다**. 기타 feature는 다루지 않음 (역산 원칙).
2. 각 feature에 대해 **짧은 mini 실습** 설계. **구체 시간 수치 금지** — "짧은 mini 실습", "간단한 기초 실습" 등 추상 표현 사용.
3. mini 입력은 M4보다 **훨씬 작은 규모**임을 명시하되, **구체 수치(N행/N건/N턴 등) 기입 금지**. "작은 샘플", "짧은 예시", "몇 건", "몇 턴의 연속 대화" 등 추상 표현으로. 구체 규모는 Skill 9(Phase 2)에서 수강생 수준·시수에 맞춰 정함.
4. "학습 포인트 / 사용 feature / mini 입력 / 행동 / 결과 확인 / M4 연결" 구조 유지.
5. feature 순서는 M4 시나리오 Step 순서대로.

[금지]
- M4에 없는 feature 추가 금지
- 보안·시수·수준 제약 언급 금지 (Phase 1 순수)
- 구체 시간 수치 기입 금지 (Phase 2 영역)
- feature_caveats 대응 설계 금지
- missed_feature_estimates 참조 금지

[출력 형식]
SKILL.md §"파일 구조" 템플릿 그대로 따름. "기초 실습 시나리오" 섹션에 feature 수만큼 mini 실습 배열.
```

### Step 4. 파일 저장

`m3-{tool_name_safe}.md`로 저장.

### Step 5. LD 자연어 요약 출력

**LD 출력 템플릿** (툴별 반복):

```
✅ {tool_name} M3 기초 실습 설계 완료

[학습 목표]
M4 메인 실습에 필요한 {tool_name}의 {N}개 핵심 기능을 독립적으로 다룰 수 있도록 기초 학습.

[M4 연결]
- M4 task: {task_one_liner}
- 기초 학습 feature: {feature_name 목록}

[기초 실습 시나리오]
1. {feature_name_1} 기초
   {학습 포인트·행동·결과 확인을 자연어 2~3문장으로 풀어 설명}

2. {feature_name_2} 기초
   {동일 구조}

...

[각 실습의 M4 연결]
- {feature_name_1} → M4 Step {N}에서 활용
- {feature_name_2} → M4 Step {M}에서 활용
...

---
산출물 파일: curriculum-builder-output/{run_folder}/m3-{tool_name_safe}.md

※ Phase 1 순수 설계입니다. 분량·난이도는 Skill 9(Phase 2)에서 시수·수준에 맞춰 재단됩니다.

다음 단계: M2(When/Why) 설계
```

**출력 원칙**: 각 mini 실습의 행동·결과를 자연어로 충실히 설명. 제목만 나열 금지.

---

## 실패 처리

### 자동 재시도
LLM 호출 실패 시 최대 2회 재시도.

### Case A (LD 조치 가능)
- `m4-{tool}.md` 파싱 실패 (feature 목록 섹션 누락 등) → Skill 5 재실행 유도:
  ```
  ⚠ M4 파일에서 "사용 feature 목록" 섹션을 찾지 못했습니다.
  Skill 5를 다시 실행하거나 m4-{tool}.md 구조를 확인해주세요.
  ```

### Case B (시스템 오류)
- `m4-{tool}.md` 파일 부재 → Skill 5 선행 요구 메시지
- `tool-features.json` 부재 → Skill 3 선행 요구 메시지

---

## LD 피드백 처리

- **"OK" / "진행해"** → Skill 7 (M2 When/Why)으로 진행
- **"실습 N번을 다르게 설계해줘"** → 해당 feature mini 실습만 재생성 (다른 것 유지)
- **"feature X는 빼줘"** → 다만 M4에서 쓰는 feature라면 **경고**. 정말 뺄지 LD에게 재확인 (M4 수행에 영향)
- **"전체 다시 작성해줘"** → Step 3 재실행

Skill 6은 임의로 결과 변경 금지. LD 요청 시만 수정.

---

## 금지 사항

- **교안 수준 서술 금지** — 수강생 발화, 슬라이드 대본, "여러분은 이제..." 같은 강의 스크립트 형태 X. **모듈 구성 기획 수준**(mini 실습 학습 포인트·입력·행동·결과 서술)에 머물 것. Skill 5(M4)·Skill 7(M2)과 동일한 성격
- **M4에 없는 feature 다루기 금지** — 역산 원칙 위배
- **보안 제약 고려 금지** (Phase 1 원칙)
- **시수·수준 고려 금지** (Phase 1 원칙)
- **구체 시간 수치 기입 금지** — "5~10분" 같은 표현 대신 "짧은 mini 실습" 등 분량 추상 표현 사용. 시수는 Skill 9 영역
- **구체 입력 수치 기입 금지** — "10~20행", "5~7건", "4턴" 등 특정 수치 사용 금지. "작은 샘플", "짧은 예시", "몇 건", "몇 턴의 연속 대화" 등 추상 표현으로. 구체 규모는 Skill 9(Phase 2)에서 수강생 수준·시수에 맞춰 정함
- **feature_caveats 대응 설계 금지** — Skill 9 영역
- **missed_feature_estimates 참조 금지** — hallucination 격리
- **mini 입력 규모 = M4와 동일/초과 금지** — 의미 없음. M4보다 훨씬 작게
- **Skill 9 인계 섹션 임의값 기입 금지** — `input.json` 값 그대로 인용
- **임의로 실습 편집 금지** — LD 요청 시만
