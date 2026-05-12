---
name: curriculum-rebuild
description: curriculum-builder Phase 2 공정 1(factcheck) 후속 단계. factcheck-result.json의 변경 반영 건수를 점검해 LLM 재합성(2-A) 또는 단순 복사(2-B)로 curriculum-post-factcheck.md를 산출한다. Phase 1 조합 산출 curriculum.md를 1차 source로 두고 공정 1이 만든 m{N}-{tool}.v2.md 변경분만 반영. 영향 X 모듈은 그대로 보존. 공정 2 input source.
---

# Phase 2 공정 1 후속: Curriculum Rebuild (post-factcheck 재합성)

공정 1(factcheck)이 만든 m{N}-{tool}.v2.md 변경분과 factcheck-result.json의 동작 변경 메모를 Phase 1 조합 산출 curriculum.md에 반영해 단일 curriculum-post-factcheck.md를 산출한다. 공정 2(시수 블록)가 본 산출물을 자동 input으로 받는다.

## 역할

Phase 1 조합 산출 curriculum.md = 1차 합성본. 공정 1이 일부 모듈을 .v2.md로 재구성한 뒤, curriculum.md에는 그 변경이 자동 반영되지 않으므로 본 skill이 후처리 합성 책임. 단 공정 1 결과가 변경 0건이면 LLM 호출 없이 단순 복사로 헤더만 갱신.

## 분기 정신 (옵션 C)

본 skill은 무조건 호출되지만 factcheck-result.json의 summary를 점검해 두 흐름 중 하나만 실행:

- **2-A 흐름** (LLM 호출 = `llm_generated`): `summary.behavior_update_reflected + summary.fail_resolved` 합 ≥ 1
- **2-B 흐름** (LLM 호출 X·단순 복사 = `copy_only`): 합 = 0

---

## Input

| 파일 | 읽는 필드 | 필수 여부 |
|---|---|---|
| `curriculum.md` | 본문 전체 (Phase 1 조합 산출) | ★ 필수 |
| `factcheck-result.json` | `summary` · `results[].appearing_modules` · `results[].change_delta` · `results[].flag_reason` · `results[].reconstruction` | ★ 필수 |
| `input.json` | `company` · `role` · `topic` · `tools[]` · `run_folder` | ★ 필수 |
| `m{N}-{tool}.v2.md` | 본문 전체 (영향 모듈 한정) | **변경 0건 시 부재 가능** (2-B 흐름에서는 .v2.md 자체가 생성되지 않으므로 읽지 않는다) |
| `top-tasks.json` | `per_tool[tool].top3` (모듈별 task 인지) | optional (LLM context 보강용) |

**`.v2.md` 읽기 범위**: 2-A 흐름에서도 전체 `.v2.md` 검색은 하지 않는다. `factcheck-result.json`의 `results[].reconstruction.file_after`가 가리키는 파일만 읽는다. 변경 발생 모듈만 인지하면 충분하므로 호출 비용·읽기 범위 모두 최소화.

**저장 위치 (Input 파일별 폴더 명시)**:
- `input.json`·`top-tasks.json` = `{run_folder}/` 직속
- `curriculum.md` = `{run_folder}/phase1/curriculum.md` (Phase 1 조합 산출 — phase1/ 하위)
- `factcheck-result.json`·`m{N}-{tool}.v2.md` = `{run_folder}/phase2/factcheck/` 하위 (공정 1이 만들어 둔 파일·본 스킬은 read 전용)
- `run_folder`는 `input.json.run_folder` 값(절대 경로)을 그대로 따른다.

---

## Output

| 파일 | 내용 | 비고 |
|---|---|---|
| `{run_folder}/phase2/factcheck/curriculum-post-factcheck.md` | 후처리 합성본 | 항상 생성 (2-A·2-B 무관) |

**원본 `curriculum.md` 보존** (불침해). 본 skill은 새 파일만 만든다.

---

## 실행 절차 (4 Step)

### Step 1. 입력 로드 + 분기 판정

1. `curriculum.md` · `factcheck-result.json` · `input.json` 로드
2. `factcheck-result.json.summary.behavior_update_reflected + summary.fail_resolved` 합 계산 → `change_total`
3. 분기 결정:
   - `change_total >= 1` → **2-A 흐름**
   - `change_total == 0` → **2-B 흐름**

### Step 2. 영향 모듈 식별 (2-A 흐름 한정)

2-B 흐름이면 본 Step은 스킵.

1. `factcheck-result.json.results[]` 순회
2. `reconstruction != null` 항목만 추출 (변경 발생 모듈)
3. 각 항목의 `reconstruction.module_id` · `tool` · `reconstruction.file_after`로 영향 모듈 목록 구성
4. `file_after`가 가리키는 `m{N}-{tool}.v2.md` 본문 로드
5. 결과 = 영향 모듈 리스트 `[(tool, module_id, .v2.md 본문, change_delta·flag_reason)]` / 영향 X 모듈 = `curriculum.md`의 도구별 표·모듈 구성 설명을 그대로 복사 대상

### Step 3. 본문 합성

#### 2-A 흐름 (LLM 호출 1회)

LLM에 다음 프롬프트로 도구별 섹션 재합성을 요청:

```
당신은 Phase 1 조합 산출 curriculum.md를 factcheck 후 갱신해 curriculum-post-factcheck.md를 만듭니다.

[Input]
- 기존 curriculum.md 본문
- 영향 모듈 목록: (tool · module_id · m{N}-{tool}.v2.md 본문 · change_delta · flag_reason)
- input.json (company · role · topic · tools)

[작업]
1. 도구별 섹션 순회
2. 영향 모듈은 m{N}-{tool}.v2.md 본문 기반으로 해당 모듈의 표 bullet · 모듈 구성 설명 갱신
   - factcheck change_delta가 학습 내용·실습 흐름에 영향을 주면 모듈 구성 설명 산문에 자연 흡수
   - 표 bullet에는 학습 주제·실습 단위만. change_delta 메모 자체를 표 bullet에 박지 말 것
3. 영향 X 모듈은 기존 curriculum.md 본문 그대로 복사 (표·설명 모두)
4. 헤더 blockquote 갱신 — 흐름 종류(llm_generated) · 갱신 사유 · 영향 모듈 N건 명시

[Bullet · 모듈 구성 설명 작성 원칙]
- curriculum-post-factcheck.md는 외부 고객사·강사 공유 자료 — 회사 내부 워딩·수강 흐름 안내를 표 bullet에 박지 말 것
- "(LD 리뷰용)·(LD 검토용)" 같은 회사 내부 호칭 노출 금지
- "M3 → M4 학습 흐름 안내" 같은 메타 표현 표 bullet 금지 (학습 흐름 안내는 별도 안내 영역)
- 표 bullet = 학습 주제·실습 단위 한 줄 / 모듈 구성 설명 = 자연 산문체 3~4줄
- 영향 X 모듈 표 bullet = 기존 curriculum.md 그대로 복사
- 영향 모듈 표 bullet = m{N}-{tool}.v2.md 본문이 source 1순위. .v2.md 본문 구조 따라 자연 bullet 수·구조 결정 (factcheck 후 실습이 풍부해지면 bullet 늘어남 허용)
- 기존 curriculum.md 해당 모듈 표 bullet = LLM context 참고용 (이전 형태 인지). 강제 X
- 표 bullet 수 상한 박지 X (1차 spec 영역. 테스트 사례 보고 추후 결정)

[금지]
- input.json.security · hours · level 값 본문에 박지 X (Phase 3 영역)
- Skill 9 인계 섹션 박지 X (별도 섹션 자체를 만들지 말 것)
- 영향 X 모듈 본문 임의 변경 X (기존 curriculum.md 본문 그대로)
- m{N}-{tool}.v2.md · curriculum.md 원본에 없는 내용 창작 X

[출력 형식]
SKILL.md §"산출 본문 구조"의 템플릿 그대로 (헤더 + 커리큘럼 개요 + 도구별 섹션 반복).
```

LLM 산출 = 헤더 + 커리큘럼 개요 + 도구별 (커리큘럼 표 + 모듈 구성 설명) 통합본.

#### 2-B 흐름 (LLM 호출 X · 단순 복사)

1. `curriculum.md` 본문 그대로 읽기
2. 헤더 blockquote 부분만 교체 (생성 정보 박스를 본 skill 산출 형식으로)
3. 본문(커리큘럼 개요 + 도구별 섹션)은 그대로 복사
4. ★ 만일 원본 curriculum.md에 "Skill 9 인계" 섹션이 박혀 있으면 본 산출에서는 제거 (5/6 base-rollback 결정 정합)

### Step 4. 저장 + LD 고지

1. `{run_folder}/phase2/factcheck/curriculum-post-factcheck.md` 저장 (UTF-8 강제)
2. LD 고지 (1회):
   ```
   [공정 1 후속 합성 완료]
   - 흐름: {llm_generated 또는 copy_only}
   - 갱신 사유: {2-A: factcheck change_total N건 반영 / 2-B: 변경 0건 · 기존 curriculum.md 그대로}
   - 영향 모듈: {2-A: 모듈 N건 (tool/module_id 나열) / 2-B: 없음}
   - 산출물: {run_folder}/phase2/factcheck/curriculum-post-factcheck.md
   - 다음 공정 (공정 2 시수 블록)이 본 산출물을 자동 input으로 사용합니다.
   ```

---

## 산출 본문 구조

```markdown
# {company} {role} — AI 교육 커리큘럼

> 생성 정보
> - Phase 2 공정 1 후 — curriculum-post-factcheck ({llm_generated 또는 copy_only})
> - 생성일: {YYYY-MM-DD}
> - 회사·직무: {company} / {role}
> - 주제: {input.topic}
> - 대상 툴: {input.tools 나열}
> - 갱신 사유: {2-A: factcheck change_delta N건 반영 / 2-B: 변경 0건 · 기존 curriculum.md 그대로}
> - 영향 모듈: {2-A: 모듈 N건 / 2-B: 없음}
> - 본 산출 = 공정 2 input source

## 커리큘럼 개요

{curriculum.md 개요 그대로 (회사·직무·주제·대상 툴 안내)}

---

## [{tool_name_1}]

### 커리큘럼 표

| 구분 | 내용 |
|------|------|
| M1 ({tool_name} 소개) | • {bullet 1} |
|                       | • {bullet 2} |
|                       | • ... |
| M2 (활용 맥락) | • ... |
| M3 (기초 실습) | • ... |
| M4 (메인 실습) | • ... |

### 모듈 구성 설명 (LD 검토용)

- **M1 ({tool_name} 소개)**: 자연 산문체 3~4줄
- **M2 (활용 맥락)**: 자연 산문체 3~4줄
- **M3 (기초 실습)**: 자연 산문체 3~4줄
- **M4 (메인 실습)**: 자연 산문체 3~4줄

---

{복수 툴이면 다음 도구 섹션 반복}
```

★ **Skill 9 인계 섹션은 박지 않는다** — 5/6 base-rollback에서 skill-5·6·7·8·assembly 5건 모두 폐기됨. curriculum-post-factcheck.md는 그 정합을 따른다 (Phase 3 시수·수준·보안 제약은 별도 단계에서 input.json 자체 영역에서 LD가 검토).

---

## 금지 사항

- **`input.json.security` · `hours` · `level` 값 본문에 박지 X** — Phase 3 영역. 헤더 · 표 bullet · 모듈 구성 설명 어디에도 박지 말 것
- **Skill 9 인계 섹션 박지 X** — 5/6 base-rollback 결정. curriculum-post-factcheck.md도 동일 정합
- **원본 `curriculum.md` 변경 X** — 본 skill은 새 파일(`curriculum-post-factcheck.md`)만 만든다. 불침해
- **`factcheck-result.json` · `tool-features.json` · `m{N}-{tool}.md` · `m{N}-{tool}.v2.md` 변경 X** — 읽기만
- **영향 X 모듈 본문 임의 변경 X** — 2-A 흐름에서도 영향 X 모듈은 기존 curriculum.md 본문 그대로 복사
- **회사 내부 워딩 표 bullet 박지 X** — "(LD 리뷰용)·(LD 검토용)" 등 외부 노출 금지 (skill-phase1-curriculum-assembly 정신 일관)
- **수강 흐름 안내 표 bullet 박지 X** — "M3 → M4 학습 흐름 안내" 같은 메타 표현 표 bullet 금지
- **시수·수강생 수준·보안 제약 산출물에 박지 X** — Phase 3 영역
- **`m{N}-{tool}.v2.md` · `curriculum.md` 원본에 없는 내용 창작 X** — 2-A 흐름 LLM 호출에서도 source 본문 기반만
- **2-B 흐름에서 LLM 호출 X** — 변경 0건이면 단순 복사 + 헤더만 갱신. LLM 호출은 비용 낭비 + 본문 변형 위험
- **전체 `.v2.md` 검색 X** — `factcheck-result.json.results[].reconstruction.file_after`가 가리키는 파일만 읽음

---

## 실패 처리

### 자동 재시도
2-A 흐름 LLM 호출 실패 시 최대 2회 재시도.

### Case A (LD 조치 가능)
- `curriculum.md` 부재 → Phase 1 조합(skill-phase1-curriculum-assembly) 선행 요구 안내
- `factcheck-result.json` 부재 → 공정 1(skill-factcheck) 선행 요구 안내
- 2-A 흐름에서 `file_after` 경로의 `.v2.md` 부재 → factcheck-result.json과 실제 파일 정합 깨짐 안내 · 공정 1 재실행 권장

### Case B (시스템 오류)
- `input.json` · `factcheck-result.json` 파싱 실패 → 원인 명시 후 중단
- LLM 재시도 2회 모두 실패 → 시스템 오류 템플릿

---

## Phase 구분 (메인 SKILL.md 흐름 정합)

- 본 skill = **Phase 2 공정 1 후속** (공정 1 → 본 skill → 공정 2)
- Phase 1 영역 X (Phase 1 조합은 `skill-phase1-curriculum-assembly`가 담당)
- Phase 3 영역 X (시수·수준·보안 제약 반영은 별도 단계에서 LD가 input.json 자체 영역에서 검토)
