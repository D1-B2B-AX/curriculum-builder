---
name: m1-tool-intro-designer
description: curriculum-builder M1(툴 소개) 모듈 구성 기획. Skill 3의 tool-features.json과 input.json(topic)을 받아, 수강생에게 "이 툴이 뭐고 무엇을 할 수 있는 도구인지" 주제 맥락에 맞춰 소개하는 M1 모듈의 강의 구성 제안을 꼭지별로 작성. 교안 아님, LD가 모듈 구성을 판단하는 수준. Phase 1 순수 설계 (보안·시수·수준 미반영).
---

# Skill 8: M1 툴 소개 모듈 구성 (Phase 1 순수)

## 역할

Skill 3이 조사한 툴 기능 정보를 바탕으로, 수강생이 **"이 툴이 무엇이고 어떤 일을 할 수 있는지"**를 처음 이해하도록 돕는 M1 도입 모듈을 설계한다.

**수강 흐름상 위치**: **M1(툴 소개)** → M2(When/Why) → M3(기초) → M4(메인 실습). M1은 가장 먼저 만나는 도입부.

### M1의 공식 정의 (설계도 §1)
- **What = 사용하고자 하는 툴**
- 이 툴이 **무엇인지** 소개 — 단, 단순한 기능 나열이 아니라 **"이 AI가 어떤 도구이고 기본적으로 어떻게 사용하는지"** 이론·기본 감에 집중
- M2(왜/When·Why)·M3(기능별 기초 사용법)·M4(실전)와 명확히 분리: M1은 **task-agnostic**한 도구 소개·이론 도입부

### M1의 콘텐츠 성격 — 매우 중요
- **교안(수강생 발화·슬라이드 대본·강의 스크립트) X**
- **모듈 구성 기획 수준**: LD가 "이 M1 모듈이 이런 꼭지들로 구성된다"를 한눈에 파악
- Skill 5(M4)·Skill 6(M3)·Skill 7(M2)과 동일한 성격

## Phase 1 순수 원칙

- **보안·시수·수준 미반영** (`input.json.security/hours/level` 읽지 않음 — Skill 9 영역)
- **feature_caveats는 LD 인지용 "※ 참고" 표시만** (대응 설계 X, Skill 9 영역)
- **구체 시간·분량 수치 금지** ("N분 강의" 등)

---

## Input

| 파일 | 읽는 필드 | 용도 |
|---|---|---|
| `tool-features.json` (Skill 3 산출) | 해당 툴 블록의 version_info / features[] (name, description, useful_for, caveats) / sources / survey_date / completeness_note | M1의 핵심 소스 |
| `input.json` | `tools[]`, `topic`, `company`, `role` — **security·hours·level 미사용** | 주제 맥락 반영 |
| `top3-tasks.json` (Skill 4 산출, 있으면 참조) | `topic_input` (is_composite, topic_elements) / matched_topic | 복수 주제일 때 주제 맥락 일관성 |

### 사용하지 않는 필드
- `input.json.security/hours/level` — Phase 2 영역

### top3-tasks.json 참조 여부
- 있으면 `topic_input`·`matched_topic`으로 주제 맥락 반영
- 없으면 (M1이 M2·M3·M4보다 먼저 실행되는 경우) `input.json.topic`만 사용. 복수 주제 감지는 내부 LLM으로 간단히 수행 가능 (prompts_meta.md 같은 별도 프롬프트 없이)

---

## Output: m1-{tool}.md

**저장 경로**: `curriculum-builder-output/{run_folder}/m1-{tool_name_safe}.md`

파일명 규칙은 Skill 5·6·7과 동일 (공백·특수문자 언더스코어 치환, 툴별 1개).

### 파일 구조

```markdown
# M1 (What) — {tool_name} 소개 (주제: {topic})

> 생성 정보
> - Skill 8 (M1 설계) — curriculum-builder
> - 생성일: {YYYY-MM-DD}
> - 대상 툴: {tool_name}
> - 주제: {input.topic}
> - Phase 1 순수 설계 (보안·시수·수준 미반영 — Skill 9 Phase 2에서 재단)
> - **수강 흐름**: **M1(툴 소개)** → M2(When/Why) → M3(기초) → M4(메인 실습)

## 학습 목표

이 M1 모듈을 마치면 수강생은:
- **{tool_name}**이 어떤 도구인지 한 문장으로 설명할 수 있다
- 이 툴이 주로 잘 하는 일과 한계(베타·유료 플랜 등)를 구분해서 이해한다
- 주제 "{topic}" 맥락에서 이 툴이 왜 등장하는지 맥락을 잡는다

## 툴 기본 정보 (Skill 3 조사 기반)

- **버전**: {version_info}
- **조사일**: {survey_date}
- **핵심 기능 수**: {features 개수}개 (파악된 주요 기능 기준)

## 강의 구성 제안 (M1 모듈의 주 본문)

M1 강의는 아래 3개 꼭지로 구성:

### 꼭지 1. 이 AI는 무엇인가 — 한 문장 정의와 도구 유형
{2~4줄 설명}: tool-features.json의 version_info와 전반 features 성격을 조합하여 "이 툴이 어떤 유형의 AI 도구인지" 한 문장 정의 + 유사 도구 대비 위치(대화형 AI / 코딩 에이전트 / 이미지 생성 전문 등). 수강생이 "아, 이건 이런 종류의 도구구나"를 잡는 단계.

### 꼭지 2. 기본 사용 방식 — 어떻게 입력하고 어떻게 결과가 나오는가
{2~4줄 설명}: 이 도구의 **인터랙션 패턴**(프롬프트 대화·파일 업로드·CLI 명령·연속 대화 컨텍스트 유지 등)을 개괄. 타 AI 도구와 구분되는 **기본 사용 원리·특징**에 집중. 세부 기능 사용법(M3 영역) 아님 — "이 도구는 이런 방식으로 쓰는 것이다"라는 **이론·기본 감** 수준.

### 꼭지 3. 주요 기능 한눈에
{2~4줄 설명}: 이 툴의 주요 기능 중 핵심 3~5개를 카테고리로 묶어 개괄. 세부 사용법은 M3에서 익힐 예정이므로 여기서는 "무엇이 있는지" 수준만. feature_caveats 있는 기능은 ※ 참고 표시. 주제("{topic}") 맥락에서 특히 주목할 기능이 있으면 간단히 언급 가능.

## 사용된 feature 상세 (꼭지 3의 근거 자료)

M1 꼭지 3에서 소개할 기능들을 아래와 같이 파악:

| feature | 요약 설명 | caveats |
|---|---|---|
| {feature_name_1} | {useful_for 기반 한 줄 요약} | {caveats or "-"} |
| ... | ... | ... |

※ M1에서는 feature의 "무엇을 하는가" 수준만 다룸. 세부 사용법·실습은 M3·M4 영역.

## Skill 9 인계

본 M1을 아래 제약에 맞춰 재단 (**`input.json` 값 그대로 인용**):
- 시수: {input.json.hours}시간
- 수강생 수준: {input.json.level}
- 보안 제약: {input.json.security}

Skill 9이 위 실제 제약 기반으로 강의 분량·예시 깊이·시연 여부 조정.
```

### 템플릿 채움 규칙

- **버전·조사일**은 tool-features.json에서 그대로 복사
- **주제 맥락 꼭지 (꼭지 2)**: 복수 주제(`topic_input.is_composite = true`)면 topic_elements 각각과의 관련성을, 단일이면 그 주제 하나와의 관련성 서술
- **feature_caveats 표시**: caveats가 null이 아닌 feature만 "※ 참고" 형식으로 노출
- **Skill 9 인계 섹션의 input.json 값**: 그대로 복사. 임의 추정 금지

---

## 실행 절차 (5 Step)

### Step 1. 파일 로드
`curriculum-builder-output/{run_folder}/`에서 tool-features.json + input.json 로드. `top3-tasks.json`이 있으면 추가 로드 (`topic_input`, `matched_topic`).

**툴별 순회** — `input.tools` 배열의 각 툴에 대해 Step 2~4 반복.

### Step 2. 주제 맥락 파악

top3-tasks.json이 있으면:
- `topic_input.is_composite`, `topic_elements` 그대로 사용

없으면 (M1을 M4 체인보다 먼저 실행):
- `input.json.topic`을 자연어 그대로 사용
- 복수 주제 여부는 이 Skill 안에서 간단히 LLM으로 감지 (프롬프트 내부 step)

### Step 3. M1 모듈 구성 기획 생성 (LLM)

**생성 프롬프트**:

```
당신은 {tool_name}의 **M1(툴 소개) 모듈 구성 기획**을 작성합니다.
목적: 수강생이 이 툴을 처음 만나는 도입 단계에서 "이 툴이 뭐고 어떤 걸 할 수 있는지" 전체 그림을 잡도록.

**중요**: 교안(수강생 발화·슬라이드 대본)이 아님. **LD가 "이 모듈에 이런 꼭지가 들어간다"를 판단할 수 있는 모듈 구성 기획 수준**으로.

[툴 정보 — tool-features.json 기반]
- version_info
- features[] 전체 (name, description, useful_for, caveats)
- completeness_note

[주제 맥락]
- input.topic: {input.topic}
- is_composite: {true/false}
- topic_elements: {배열}

[회사·직무]
{company}, {role}

[M1 설계 원칙 — Phase 1 순수]
1. 배경 정보(버전·조사일·기능 수) 섹션은 간결하게
2. **강의 구성 제안 섹션이 주 본문** — 3개 꼭지로 구성
3. 각 꼭지: 제목 + 다룰 내용·핵심 메시지 2~4줄
4. **교안 수준 금지** — 수강생 발화, 슬라이드 대본 X. 모듈 구성 기획 수준
5. **M1 = 이론·기본 감**: "이 AI가 무엇이고, 기본 사용 방식이 어떤지"에 집중. 단순 기능 나열 금지 (기능은 꼭지 3에서 개괄만)
6. **세부 사용법 설명 금지** — "기능 X는 이렇게 쓴다"는 M3 영역. M1은 "무엇이 있는가·어떻게 쓰는 종류의 도구인가" 수준까지
7. **수강 흐름 안내 꼭지 금지** — M1~M4 연결 설명은 실제 커리큘럼 bullet에 들어가지 않음. 모듈 구성은 3꼭지까지
8. feature_caveats → "※ 참고: ..." 표시만 (대응 설계 X)
9. **구체 시간·분량 수치 금지** — "N분 강의" 등. Phase 2 영역
10. 복수 주제면 꼭지 3(주요 기능)에서 주제별 주목 기능 간단 언급 가능
11. 사용 feature 상세 표는 LD 참고용, 간결하게

[꼭지 전형 구성 (변경 가능)]
- 꼭지 1: 이 AI는 무엇인가 — 한 문장 정의와 도구 유형
- 꼭지 2: 기본 사용 방식 — 인터랙션 패턴·기본 사용 원리
- 꼭지 3: 주요 기능 한눈에

[출력 형식]
SKILL.md §"파일 구조" 템플릿 그대로. 학습 목표 / 툴 기본 정보 / 강의 구성 제안 / 사용된 feature 상세 / Skill 9 인계 순서.
```

### Step 4. 파일 저장
`m1-{tool_name_safe}.md`로 저장.

### Step 5. LD 자연어 요약 출력

**LD 출력 템플릿** (툴별 반복):

```
✅ {tool_name} M1 (툴 소개) 모듈 구성 완료

[툴 기본 정보]
- 버전: {version_info}
- 주요 기능 수: {N}개
- 조사일: {survey_date}

[주제 맥락]
- 입력 주제: "{topic}"
- 복수 주제 여부: {is_composite}{, topic_elements 나열}

[강의 구성 제안]  ← M1 모듈의 실제 내용

1. {꼭지 1 제목}
   {꼭지 1 설명 2~4줄 그대로}

2. {꼭지 2 제목}
   {꼭지 2 설명 그대로}

3. {꼭지 3 제목}
   {꼭지 3 설명 그대로}

---
산출물 파일: curriculum-builder-output/{run_folder}/m1-{tool_name_safe}.md

※ Phase 1 순수 설계입니다. 강의 시수·시연 깊이·발화 수준은 Skill 9(Phase 2)에서 시수·수준에 맞춰 재단됩니다.

다음 단계: Phase 1 조합 — M1·M2·M3·M4를 curriculum_detail.md 및 curriculum_table.md로 통합
```

**출력 원칙**:
- 강의 구성 제안은 꼭지별 내용 전체 노출 (md 파일과 동일 분량)
- 툴 기본 정보는 버전·기능 수·조사일만 간결하게

---

## 실패 처리

### 자동 재시도
LLM 호출 실패 시 최대 2회 재시도.

### Case A (LD 조치 가능)
- `tool-features.json`의 해당 툴 블록이 features 배열이 비어있음 → Skill 3 재실행 유도:
  ```
  ⚠ {tool_name}의 기능 정보가 부족합니다.
  M1 모듈 설계를 위해 Skill 3 (툴 기능 조사)을 먼저 재실행해주세요.
  ```

### Case B (시스템 오류)
- `tool-features.json` 파일 부재 → Skill 3 선행 요구 메시지
- `input.json` 부재 → Skill 1 선행 요구 메시지

---

## LD 피드백 처리

- **"OK"** → Phase 1 조합 단계로 진행
- **"꼭지 N을 다르게"** → 해당 꼭지만 재생성
- **"꼭지 추가/삭제"** → 재실행 (LD 요청 반영)
- **"feature 소개를 더 풍부하게 / 더 간결하게"** → 꼭지 3 재생성

Skill 8은 임의 변경 금지. LD 요청 시만 수정.

---

## 금지 사항

- **교안 수준 서술 금지** — 수강생 발화, 슬라이드 대본, "여러분은 이제..." 같은 강의 스크립트 형태 X. **모듈 구성 기획 수준**에 머물 것. Skill 5·6·7과 동일 원칙
- **세부 사용법·실습 방법 설명 금지** — "이 기능은 이렇게 쓴다"는 M3 영역. M1은 "무엇이 있는가·어떻게 쓰는 종류의 도구인가" 수준까지만
- **수강 흐름 안내 꼭지 금지** — M1~M4 연결 설명은 실제 커리큘럼 bullet로 옮기지 않는 메타 정보. 3꼭지까지가 M1 본문
- **단순 기능 나열 금지** — M1은 이론·기본 감 모듈. 기능 전체를 나열·설명하는 건 M3 영역
- **task 중심 설명 금지** — M1은 task-agnostic. 특정 task 연결은 M2 영역
- **구체 시간·분량 수치 금지** — "15분 소개", "2분 시연" 등. Phase 2 영역
- **feature_caveats 대응 설계 금지** — "※ 참고" 표시만 (대응은 Skill 9)
- **missed_feature_estimates 참조 금지** — Skill 3·4가 이미 격리. M1에도 포함 X
- **Skill 9 인계 섹션 임의값 금지** — input.json 값 그대로
- **tool-features.json에 없는 기능 창작 금지** — Skill 3 조사 결과만 사용
- **보안·시수·수준 고려 금지** (Phase 1 원칙)
- **top1 task 중심 설명 금지** — M1은 task-agnostic. 특정 task 강조는 M2 영역
