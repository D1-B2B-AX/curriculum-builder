---
name: tool-feature-factcheck
description: curriculum-builder Phase 2 공정 1. Phase 1(Skill 5~8)이 산출한 m1~m4 모듈에서 등장하는 툴 feature가 현재 시점에 사용 가능한지 웹 검증하고, 문제 발견 시 대체 feature를 선정해 모듈을 재구성(.v2.md)한다. Skill 3의 tool-features.json은 불침해(사이드카 전략). 산출물은 {run_folder}/phase2/factcheck/{factcheck-result.json·m{N}-{tool}.v2.md·validation-check-result.json}. 100% green 완결 원칙. LD 고지 1회.
---

# Phase 2 공정 1: Tool Feature Factcheck

Phase 1(Skill 5~8)이 산출한 m1~m4 모듈의 feature 정확성을 **현재 시점 기준**으로 검증하고, 문제가 발견되면 대체 feature를 선정해 모듈을 재구성한다. 공정 1은 이 검증+대체+재구성을 **하나의 자동 완주 공정**으로 처리하며, 중간 LD 확인은 예외 경로(자동 게이트 1 에스컬레이션·대체 2회 실패)에서만 발생한다.

## 왜 이 스킬이 필요한가

Phase 1은 Skill 3의 `tool-features.json`을 원천으로 모듈을 구성한다. 그러나 AI 툴의 feature는 빠르게 변경(이름 변경·deprecated·지역 제한·Plan 이동·동작 변경)되므로, 교안 배포 시점에 **오늘 사용 가능한지** 재검증하지 않으면 잘못된 커리큘럼이 배포될 위험이 있다. 공정 1은 이를 차단하는 **게이트 레이어**이며, 단순 flagging이 아니라 **재구성까지 완결**하여 다음 공정(시수 블록)에 100% green 상태로 넘긴다.

---

## 전제: references/ 전체 Read 강제 (핵심 규정)

본 스킬 실행 시 반드시 아래 5개 파일을 **전체 Read 후** 작업을 시작한다. SKILL.md 요약만으로 판단하지 말고 references의 canonical 정의·프롬프트 전문·rubric을 그대로 적용한다.

| 파일 | 담는 것 |
|---|---|
| `references/rubric.md` | [F1]~[F4] 프레임워크 조건 분기 전체 (9 STEP 시그널 판정 / 한국어 도메인 공식 소스 판정 5항 / 자동 게이트 1·2 / criticality 스키마 / Level 1~4 / tiebreaker 4단) |
| `references/prompts_criticality.md` | [F2] criticality 판정 프롬프트 전문 (level_decision 필드 포함, temperature=0 + response_format=json_schema 강제) |
| `references/prompts_replacement.md` | [F4] 대체 feature 선정 프롬프트 + tiebreaker 4단 규정 |
| `references/prompts_reconstruction.md` | Level 1~3 + behavior_update_reflection 재구성 프롬프트. "원본 m{N}-{tool}.md의 헤딩 스키마를 유지" 지시 포함 |
| `references/phase1-module-schema.md` | M1/M2/M3/M4 필수·선택 헤딩 리스트 + 순서 규칙. Validation v2 기준 3 (C) Pre-check의 기준 문서 |

**이 규정의 근거**: Skill 4의 "references 미독 시 ontology 위반 다수 발생, 읽고 실행 시 0 위반" 패턴과 동일. 본 스킬의 rubric은 품질 형용사가 아니라 **조건 분기 규칙**으로 작성되어 있어 전문 인용이 필수다.

---

## Input

아래 파일들을 읽는다. `input.json`·`tool-features.json`·`top-tasks.json`은 `{run_folder}/` 직속·Phase 1이 생성한 `m1~m4-{tool}.md`는 `{run_folder}/phase1/` 하위에 있다.

| 파일 | 읽는 필드 | 용도 |
|---|---|---|
| `input.json` | `company`, `role`, `tools[]`, `topic`, `run_folder` | 실행 맥락, 복수 툴 처리 |
| `tool-features.json` | 툴명 키 dict의 `features[]` + `completeness_note` | S1 feature 매칭, S4 candidate_replacements 평가 |
| `top-tasks.json` | task_id + task_one_liner + task_card | S4 [F2] criticality 판정 입력 |
| `phase1/m1-{tool}.md` ~ `phase1/m4-{tool}.md` | 헤딩 구조 + 본문 | S1 feature 추출 + S6 재구성 원본 |

**tool-features.json 불침해 원칙**: 본 스킬은 tool-features.json을 **읽기만** 한다. 변경이 필요한 경우에도 사이드카 파일(`factcheck-result.json`)과 .v2.md에만 기록하며, 원본 tool-features.json은 SHA-256 pre/post 일치가 수락 기준이다 (S7 참조).

---

## Output

| 파일 | 내용 | 생성 조건 |
|---|---|---|
| `{run_folder}/phase2/factcheck/factcheck-result.json` | 공정 1 사이드카. 모든 feature의 판정·대체·재구성 결과 | 항상 생성 |
| `{run_folder}/phase2/factcheck/m{N}-{tool}.v2.md` | 재구성된 모듈 신버전 (원본 .md는 보존) | 대체 또는 변경 반영 발생 모듈만 |
| `{run_folder}/phase2/factcheck/validation-check-result.json` | S9 자체 체크 15개 테스트셋 결과 | 항상 생성 |
| `{run_folder}/phase2/factcheck/logs/summary_mismatch.log` | S7 summary 합계 불일치 발생 시 로그 | 불일치 시에만 |

---

## 공정 실행 흐름

```
Phase 1 완료 → 메인 SKILL.md가 Phase 2 공정 1 자동 호출
  ↓
Step S1 [Shell]: 입력 수집 + 검증 대상 feature 목록 추출
  ↓
Step S2 [Core]: 각 feature 웹 검색 + [F1] 시그널 판정 (+ 자동 게이트 1·2)
  ↓
Step S3 [Check]: green/fail 분류, 4개 큐 구성 (+ 자동 게이트 1 재판정 반영)
  ↓ (fail 있으면)
Step S4 [Core]: [F2] criticality 판정 → [F3] 재구성 깊이 (Level 2/3 단일 값 결정) → [F4] 대체 선정
  ↓
Step S5 [Core]: 대체 후보 재factcheck ([F1] 재호출, 최대 2회 루프)
  ↓
Step S6 [Core]: 확정된 대체 feature로 모듈 재구성 (Level 1~3) — 원본 헤딩 스키마 유지
  ↓
Step S7 [Shell]: 사이드카 파일 + 재구성 모듈 저장 (+ 합계 일치 검증)
  ↓
Step S8 [Check]: 자체 품질 체크 (구조 체크만) + LD 결과 고지 + 100% green 완결 판정
  ↓
Step S9 [Check]: Validation v2 15개 테스트셋 자체 체크
```

**태그 분포**: Shell 2개 (S1·S7) · Core 4개 (S2·S4·S5·S6) · Check 3개 (S3·S8·S9).

---

## Step S1 [Shell]: 입력 수집 + 검증 대상 feature 추출

**입력**: `input.json`, `tool-features.json`, `top-tasks.json`, `m1-{tool}.md` ~ `m4-{tool}.md`

**작업 내용**:
1. `run_folder` 확인 (input.json의 `run_folder` 필드).
2. `tools` 배열 순회. 각 툴별로 m1~m4 파일 파싱하여 **등장 feature name 추출** (tool-features.json의 `features[].name`과 매칭되는 것만).
3. 동일 feature가 여러 모듈에 등장하면 **단일 feature + 등장 모듈 리스트**로 통합.
4. 검증 대상 목록 생성 (in-memory, 다음 Step에 전달).

**산출물 (in-memory)**:
```json
factcheck_queue = [
  {"tool": "ChatGPT", "feature_name": "Advanced Data Analysis", "feature_ref": {...}, "appearing_modules": ["m3", "m4"], "loop_count": 0},
  ...
]
```

**수락 기준 (구조)**:
- `factcheck_queue` 각 항목에 `tool`, `feature_name`, `appearing_modules`, `loop_count` 필드 존재.
- tool-features.json에 있으나 m1~m4에 미등장한 feature는 큐에 포함되지 않음.
- m1~m4에 등장한 feature는 모두 큐에 있음 (전수 검증).

---

## Step S2 [Core]: [F1] 시그널 판정 (feature별 웹 검색 + 분류)

**입력**: S1의 `factcheck_queue`, `tool-features.json` (version_info·caveats 참조).

**작업 내용**: 각 큐 항목에 대해:

### 1. 웹 검색 실행

- 검색어 A: `{tool_name} {feature_name} release notes` (공식 changelog)
- 검색어 B: `{tool_name} {feature_name} site:{공식도메인}`
- 검색어 C: `{tool_name} {feature_name} deprecated OR discontinued` (부정 확인)
- 검색어 D (필요시): `{tool_name} {feature_name} Korea OR available regions`
- 최근 6개월 필터 우선 적용.

### 2. 공식 소스 판별

`references/rubric.md`의 **한국어 도메인 공식 소스** 판정 규칙 5항 적용. 4종 타입(`official` / `semi-official` / `secondary` / `ambiguous`) 중 하나로 분류한다. `type="ambiguous"`인 경우 `ambiguity_note="공식 여부 판별 불가 — 수동 검증 권장"` 필드를 함께 기록한다.

### 3. 시점 2축 검증

- `content_date` (글 작성일) vs `feature_release_date` (feature 출시/최종 업데이트일) 별도 기록.
- 2026년 글이 2023년 feature를 현재처럼 소개하면 추가 검색으로 최신 상태 재확인.
- 업데이트 부재 자체는 결함 아님 (STEP 6-a 경로 참조).

### 4. [F1] 프레임워크 9단계 적용

`references/rubric.md`의 STEP 1~9 조건 분기 적용 → 시그널 A/B/B-변경감지/C-지역/C-플랜/D/pass 중 하나 판정.

### 5. 판정 결과 기록 (rubric.md [F1] JSON 스키마 참조)

### ★ 자동 게이트 1 (한국 비대상 모순) ★

grep 키워드: `자동 게이트 1 한국 비대상`

- **발동 조건**: `region_note`가 "한국 비대상" 패턴을 포함하면서 `verdict=fail`인 항목.
- **처리**:
  1. warning 플래그 기록 (`consistency_warning="region_note=한국 비대상 AND verdict=fail"`)
  2. [F1] 전체 재판정 트리거 **(1회 한정)** (같은 웹 검색 결과를 다시 프롬프트에 넣고 STEP 3-b 경로 엄수 지시)
  3. **1회 재판정 후에도** `verdict=fail`이면 **LD 선택지로 에스컬레이션** (loop_count 증가 없이 즉시):
     ```
     ⚠ 구조적 모순 감지: {tool_name}/{feature_name}은 한국 비대상 지역 제한임에도
       fail 판정되었습니다. LD 확인이 필요합니다.
     선택지: 1. 수동 검증 후 pass/yellow_flag로 승격 / 2. fail 확정 유지 (근거 기재)
     ```

### ★ 자동 게이트 2 (공식 소스 누락 — v2.1 완화) ★

grep 키워드: `자동 게이트 2 공식 소스 누락`

- **발동 조건 (v2.1 완화)**: `type="official"` 태깅 sources **0건** **AND** `type="ambiguous"` 태깅 sources **0건** (둘 다 없을 때만). `verdict=pass` 또는 `yellow_flag`로 판정된 항목이 대상.
- **발동 시 처리**:
  1. verdict를 `fail`로 강제 전환.
  2. `fail_reason="공식 소스 누락 (자동 게이트 2)"`로 기록.
  3. replacement_queue로 이관.
- **ambiguous 1건 이상인 경우 (v2.1 신설)**:
  - 자동 게이트 2 **미발동**.
  - verdict를 `yellow_flag`로 전환 (기존 pass였던 경우).
  - `flag_reason="공식 소스 판별 불가 — 수동 검증 권장"` 기록.
  - S8 LD 고지에서 **"수동 검증 권장 feature" 리스트로 분리 표시** (탈락 아님).

**산출물 (in-memory)**: `verdict_results` 리스트.

**수락 기준**:
- **구조**: 각 feature에 `signal`·`verdict`·`sources`(최소 1건)·`today_usable` 필드 존재. `sources`의 `type`·`content_date`·`feature_release_date` 필드 누락 없음.
- **의미 (Core)**: verdict 결정이 [F1]의 조건 분기 9단계와 일치. `signal=A` → `verdict=fail`, `signal=C-region (STEP 3-b)` → verdict 변경 없음·region_note 기록, `signal=B-변경감지 (STEP 8)` → `verdict=yellow_flag`·change_delta 명시, 등등.
- 공식 소스 최소 1건 또는 ambiguous 1건 포함. 자동 게이트 2가 이 조건을 강제.
- 시점 2축(content_date vs feature_release_date) 모두 기록.

---

## Step S3 [Check]: green/fail 분류 + 4개 큐 구성

**입력**: S2의 `verdict_results` (자동 게이트 1·2 재판정 결과 반영 완료).

**작업 내용**: `verdict_results`를 **4개 큐**로 분리:

1. **`green_set`**: `verdict=pass` 또는 (`yellow_flag`이면서 `change_delta` 없음). 모듈 내용 변경 없음.
2. **`change_reflection_queue`**: `signal=B-변경감지` (STEP 8) 항목. yellow_flag이나 `change_delta`를 실습에 반영해야 함 → S6에서 **Level 1 경량 반영**.
3. **`replacement_queue`**: `verdict=fail` 항목 (자동 게이트 1·2 포함). 대체 루프 진입. 각 항목에 `loop_count=0` 초기화.
4. **`ld_escalation_queue`** (v2 신설): 자동 게이트 1 재판정 후에도 모순 잔존 항목. S8에서 LD 고지에 포함.

**분기**:
- `replacement_queue` + `change_reflection_queue` 둘 다 비어 있으면 → Step S7로 점프 (S4·S5·S6 스킵).
- `replacement_queue`만 비어 있고 `change_reflection_queue` 있음 → S4·S5 스킵, S6에서 change 반영만 수행.
- `replacement_queue` 있음 → S4부터 정상 진행.

**수락 기준 (구조)**:
- **4개 큐 합계 = S1 `factcheck_queue` 길이** (누락·중복 없음). 즉 `len(green_set) + len(change_reflection_queue) + len(replacement_queue) + len(ld_escalation_queue) == len(factcheck_queue)`.
- `replacement_queue` 각 항목에 `loop_count` 필드 존재.
- `change_reflection_queue` 각 항목에 `change_delta` 필드 채워져 있음 (null·빈 문자열 금지).

---

## Step S4 [Core]: [F2] criticality + [F3] 재구성 깊이 + [F4] 대체 선정

**입력**: `replacement_queue` (S3), `tool-features.json`, `top-tasks.json`, m1~m4 파일들.

**작업 내용**: 각 `replacement_queue` 항목에 대해 (직렬 처리):

### 1. [F2] criticality 프롬프트 호출

`references/prompts_criticality.md` 전문 사용. **LLM 호출 파라미터 강제**:
- `temperature=0`
- `response_format=json_schema`

출력: `criticality`·`rationale`·`level_decision`·`level_decision_rationale`·`candidate_replacements`·`_meta.changed_steps_ratio`.

### 2. [F3] 재구성 깊이 판정 (references/rubric.md 조건 분기)

- `module_id` + `criticality` + `loop_count` 조합으로 Level 1~4 결정.
- **semi-critical의 경우 [F2] 응답의 `level_decision` 값을 단독 채택** (v2.1 정정):
  - `level_decision == "level2"` → `reconstruction_level = 2`
  - `level_decision == "level3"` → `reconstruction_level = 3`
  - `level_decision == null` → [F2] 재호출 1회 후에도 null이면 보수적 Level 3.
- 보조 메타데이터 기록 (결정에 영향 없음):
  - `rationale_keyword_present`: rationale의 허용 동의 표현 grep 결과 (true/false) — 3개 표현(`"부분 교체로 충분"` / `"경량 수정 가능"` / `"feature 교체만으로 실습 성립"`) 중 1개 이상 포함 여부.
  - `_meta_changed_steps_ratio`: [F2] 응답의 보조 비율.
- Level 4이면 즉시 LD 선택지 제공 대상으로 마킹 후 다음 feature로.

### 3. [F4] 대체 feature 선정

`references/prompts_replacement.md` 전문 사용. candidate_replacements 우선 평가 (tool-features.json 내) → 없거나 0점이면 신규 웹 검색 트리거. 동점 발생 시 **tiebreaker 4단 (`caveats 없음 > Plus` 포함)** 순서로 해소.

선정된 후보를 `replacement_candidate` 필드에 기록 (`selection_rationale`에 **점수 분해 명시**).

### 4. 결과 병합 (rubric.md [F4] JSON 스키마 참조)

**산출물**: `replacement_plan` 리스트.

**수락 기준**:
- **구조**: 각 항목에 `criticality`·`reconstruction_level`·`replacement_candidate`·`level_selection_basis` 필드 필수.
- **의미 (Core)**:
  - criticality 판정이 [F2] 프롬프트 출력과 일치하고 rationale이 학습 목표·task 구조를 근거로 함 (빈 문자열·추상 표현만 있으면 fail).
  - reconstruction_level이 [F3] 조건 분기표와 일치. **semi-critical은 [F2]의 `level_decision` 값으로 단독 결정** (v2.1).
  - **[F2] LLM 호출 시 `temperature=0` + `response_format=json_schema` 적용 확인** (결정성 확보).
  - `replacement_candidate.source == "tool-features.json"`이면 해당 툴의 features 배열에 실제로 존재하는 name이어야 함.
  - 동점 발생 시 `selection_rationale`에 tiebreaker 적용 단계 + 근거 명시.

---

## Step S5 [Core]: 대체 후보 재factcheck (루프 최대 2회)

**입력**: S4의 `replacement_plan`.

**작업 내용**: 각 항목에 대해:

1. `replacement_candidate`에 [F1] 시그널 판정 재실행 (S2와 동일 로직 + 자동 게이트 1·2 포함).
2. 판정 결과 분기:
   ```
   IF 재factcheck 결과 verdict == "pass" or "yellow_flag":
     → 확정 대체 (green_set에 병합)
   ELIF verdict == "fail" AND loop_count < 2:
     → loop_count += 1
     → S4로 복귀 (다른 candidate 선정 시도)
   ELIF verdict == "fail" AND loop_count >= 2:
     → LD 선택지 제공 대상으로 마킹
     → "이 feature 포기 / task 교체 / 실습 수동 재설계" 3지선다 출력 준비
   ```

3. **LD 선택지 발동 시** (references/prompts_replacement.md STEP 3 참조).

**산출물**: 최종 `resolved_plan` (green_set + 확정 대체 통합).

**수락 기준**:
- **구조**: `resolved_plan` 각 항목에 최종 `verdict=pass or yellow_flag` 보장 (fail 잔존 금지).
- **의미 (Core)**:
  - 루프 횟수 2회 제한 엄수 (`loop_count >= 3` 존재 = fail).
  - 재factcheck가 S2와 동일 로직([F1] 9단계 + 자동 게이트 1·2) 실행 (일관성).

---

## Step S6 [Core]: 모듈 재구성 (Level 1~3 + behavior_update_reflection)

**입력**: S5의 `resolved_plan`, S3의 `change_reflection_queue`, 기존 m1~m4.md 파일, `references/phase1-module-schema.md`, `references/prompts_reconstruction.md`.

### [A] resolved_plan의 대체 feature 재구성

`reconstruction_level`에 따라:
- **Level 1 (M1/M2 경량)**: 기존 feature 언급 블록을 new_feature로 문자열 교체.
- **Level 2 (M3/M4 non-critical 또는 semi-critical level_decision="level2")**: feature만 교체, 실습 단계·흐름 유지.
- **Level 3 (M3/M4 semi-critical level_decision="level3" 또는 critical 1차)**: 실습 단계를 새 feature 기준으로 재작성. 학습 목표·task는 동일하게 유지.

### ★ 재구성 프롬프트 제약 ★

재구성 LLM 호출 시 `references/prompts_reconstruction.md` 템플릿을 사용한다. 템플릿에는 다음 지시문이 반드시 포함되어 있다 (grep 키워드: `원본 m{N}-{tool}.md의 헤딩 스키마를 유지`):

```
[제약]
- 생성된 v2.md는 원본 m{N}-{tool}.md의 헤딩 스키마를 유지한다.
- 헤딩 레벨(# / ## / ###)과 헤딩 순서를 원본과 동일하게 유지한다.
- references/phase1-module-schema.md의 필수 헤딩 리스트(모듈 유형별 M1/M2/M3/M4)를 만족한다.
- 원본에 없던 헤딩을 임의로 추가하지 않으며, 원본 헤딩을 삭제하지 않는다.
- 본문(heading 사이 텍스트)만 재작성 대상이며, Level 2는 feature 명칭만 교체, Level 3는 실습 단계 텍스트만 재작성.
- task_name, 학습 목표 블록은 Level 3에서도 원본과 정확히 일치시킨다.
```

### [B] change_reflection_queue의 동작 일부 변경 반영

각 항목(signal=B-변경감지, yellow_flag, change_delta 있음)에 대해:

- M1/M2 등장 시: feature 설명 블록에 change_delta 내용 반영.
- M3/M4 등장 시: 실습 단계에서 변경된 동작이 영향을 주는 지점에 보완 문구 추가.
- feature name·tool-features.json은 변경하지 않음 (Skill 3 불침해). change_delta는 사이드카와 .v2.md에만 반영.

### [C] 모듈 파일 저장 전략 — 사이드카 신버전 생성

- 원본 `m{N}-{tool}.md`는 **보존** (불침해).
- 신버전을 `m{N}-{tool}.v2.md`로 저장.

### [D] before/after 대비 데이터 생성

```json
{
  "module_id": "m4",
  "tool": "ChatGPT",
  "change_type": "feature_replacement" | "behavior_update_reflection",
  "reconstruction_level": 1 | 2 | 3,
  "before": {"feature": "...", "reason": "...", "signal": "..."},
  "after": {"feature": "...", "selection_rationale": "..." | "change_delta 반영: {내용}", "signal": "pass" | "yellow_flag"},
  "file_before": "m4-ChatGPT.md",
  "file_after": "m4-ChatGPT.v2.md",
  "heading_schema_preserved": true
}
```

**산출물**:
- `m{N}-{tool}.v2.md` 파일 (대체 + 변경 반영 발생 모듈).
- `reconstruction_log` 리스트.

**수락 기준**:
- **구조**: v2.md 파일이 "대체 발생 + 변경 반영 대상" 모듈 수만큼 생성됨. 원본 .md 변경 없음.
- **의미 (Core)**:
  - Level 1 재구성: 실습 본문 변경 없음 (diff가 feature 언급 블록에 한정).
  - Level 2: 실습 단계 수·구조 불변. M4는 `## 실습 시나리오` 내부 numbered list (`^\s*\d+\.\s+\*\*`) 개수 원본 유지. M3는 `### 실습 N` 서브헤딩 수 원본 유지.
  - Level 3: 실습 단계 재작성이지만 task·학습 목표는 원본과 일치 (task_name·goal 불변).
  - behavior_update_reflection: feature name 불변 + 실습 골자 불변 + change_delta 내용 실제 본문 반영 (핵심 명사구 3단어 이상 연속 일치 grep 검증).
  - **원본 헤딩 스키마 유지**: 각 `reconstruction` 블록 `heading_schema_preserved=true`. `references/phase1-module-schema.md`의 필수 헤딩 리스트 만족.
  - 재구성 후 모듈에 fail feature가 남아 있지 않음.

---

## Step S7 [Shell]: 사이드카 파일 + 최종 산출물 저장

**입력**: S5 `resolved_plan` + S6 `reconstruction_log` + S2 `verdict_results` + S3 `ld_escalation_queue`.

### 1. 사이드카 파일 생성 — `factcheck-result.json`

```json
{
  "factcheck_date": "YYYY-MM-DD",
  "run_folder": "{company}_{role}_{timestamp}",
  "tools": ["ChatGPT", "..."],
  "total_features_checked": 10,
  "summary": {
    "pass": 5,
    "yellow_flag": 2,
    "fail_resolved": 2,
    "behavior_update_reflected": 1,
    "ld_choice_pending": 0
  },
  "results": [
    {
      "tool": "ChatGPT",
      "feature_name": "Advanced Data Analysis",
      "appearing_modules": ["m3", "m4"],
      "signal": "pass",
      "verdict": "pass",
      "today_usable": true,
      "sources": [{"url": "...", "type": "official", "content_date": "2026-03-15", "feature_release_date": "2024-05-13", "excerpt": "...", "stability_note": null, "ambiguity_note": null}],
      "flag_reason": null,
      "change_delta": null,
      "region_note": null,
      "fail_reason": null,
      "criticality": null,
      "criticality_rationale": null,
      "level_decision": null,
      "level_decision_rationale": null,
      "reconstruction_level": null,
      "level_selection_basis": null,
      "rationale_keyword_present": null,
      "_meta_changed_steps_ratio": null,
      "replacement": null,
      "reconstruction": null
    },
    {
      "tool": "Midjourney",
      "feature_name": "Variation 모드",
      "appearing_modules": ["m4"],
      "signal": "B-변경감지",
      "verdict": "yellow_flag",
      "today_usable": true,
      "sources": [{"url": "...", "type": "official", "content_date": "2026-02-10", "feature_release_date": "2026-01-15", "excerpt": "...", "stability_note": null, "ambiguity_note": null}],
      "flag_reason": "동작 일부 변경됨 — 2026 Q1 이후 Vary (Subtle) / Vary (Strong) 옵션 분리",
      "change_delta": "Variation 실행 시 Subtle/Strong 선택 UI 추가 (이전: 단일 Variation 버튼)",
      "region_note": null,
      "fail_reason": null,
      "criticality": null,
      "criticality_rationale": null,
      "level_decision": null,
      "level_decision_rationale": null,
      "reconstruction_level": null,
      "level_selection_basis": null,
      "rationale_keyword_present": null,
      "_meta_changed_steps_ratio": null,
      "replacement": null,
      "reconstruction": {
        "change_type": "behavior_update_reflection",
        "module_id": "m4",
        "file_before": "m4-Midjourney.md",
        "file_after": "m4-Midjourney.v2.md",
        "heading_schema_preserved": true
      }
    },
    {
      "tool": "ChatGPT",
      "feature_name": "구버전 Code Interpreter (명칭 변경)",
      "appearing_modules": ["m4"],
      "signal": "B",
      "verdict": "fail",
      "today_usable": false,
      "sources": [{"url": "...", "type": "official", "content_date": "2026-03-01", "feature_release_date": "2023-07-05", "excerpt": "...", "stability_note": null, "ambiguity_note": null}],
      "flag_reason": null,
      "change_delta": null,
      "region_note": null,
      "fail_reason": "명칭 변경됨 — 현재는 Advanced Data Analysis. 이름·동작 모두 일치하지 않음",
      "criticality": "non-critical",
      "criticality_rationale": "M4 학습 목표 '데이터 시각화'는 Advanced Data Analysis로 동일하게 달성 가능. 기능 변화 없음, 명칭만 변경.",
      "level_decision": "level2",
      "level_decision_rationale": "non-critical 판정이므로 level2 자동 할당 (실습 골자 유지 가능).",
      "reconstruction_level": 2,
      "level_selection_basis": "non-critical 강제 Level 2",
      "rationale_keyword_present": false,
      "_meta_changed_steps_ratio": 0.0,
      "replacement": {
        "feature_name": "Advanced Data Analysis",
        "source": "tool-features.json",
        "selection_rationale": "총점 5.5 vs 4.5 = ADA 우위 (학습 목표 적합도 4점 + caveats 없음 +1 + description 구체성 +0.5)",
        "refactcheck_signal": "pass",
        "refactcheck_sources": [{"url": "...", "type": "official"}]
      },
      "reconstruction": {
        "change_type": "feature_replacement",
        "module_id": "m4",
        "file_before": "m4-ChatGPT.md",
        "file_after": "m4-ChatGPT.v2.md",
        "heading_schema_preserved": true
      }
    }
  ],
  "ld_choices_pending": [
    {"tool": "...", "feature": "...", "criticality": "critical", "reason": "대체 2회 실패", "options_shown": ["1. 이 feature 포기", "2. task 교체", "3. 실습 수동 재설계"]}
  ],
  "before_after_summary": "대체 N개 + 변경 반영 M개, 총 K개 모듈 재구성 (m3-X.v2.md, m4-Y.v2.md)"
}
```

**results 각 항목 필드 세트** (21종, 모든 항목에 존재, 해당 없음은 null):
`tool` · `feature_name` · `appearing_modules` · `signal` · `verdict` · `today_usable` · `sources[]` · `flag_reason` · `change_delta` · `region_note` · `fail_reason` · `criticality` · `criticality_rationale` · `level_decision` · `level_decision_rationale` · `reconstruction_level` · `level_selection_basis` · `rationale_keyword_present` · `_meta_changed_steps_ratio` · `replacement` · `reconstruction`.

### 2. 재구성 모듈 파일 저장

S6에서 이미 `.v2.md` 생성 완료. 본 Step에서는 저장 확인만.

### 3. ★ summary 합계 일치 검증 ★

```
assert summary.pass
     + summary.yellow_flag
     + summary.fail_resolved
     + summary.behavior_update_reflected
     + summary.ld_choice_pending
     == total_features_checked
```

- 합계 불일치 시 **산출물 저장 거부** + `{run_folder}/phase2/factcheck/logs/summary_mismatch.log`에 상세 기록 + 재계산 요청.
- 합계 일치 시 산출물 저장 진행.

### 4. tool-features.json SHA-256 pre/post 해시 일치 (Skill 3 불침해)

- S1 시작 시점에 tool-features.json의 SHA-256을 기록.
- S7 저장 전에 재계산하여 일치 검증.
- 불일치 시 치명 에러 (본 스킬은 절대 tool-features.json을 수정하지 않음).

**산출물**:
- `{run_folder}/phase2/factcheck/factcheck-result.json`
- `{run_folder}/phase2/factcheck/m{N}-{tool}.v2.md` (변경 있는 모듈, S6에서 생성)
- (합계 불일치 시) `{run_folder}/phase2/factcheck/logs/summary_mismatch.log`

**수락 기준 (구조)**:
- factcheck-result.json 스키마 검증: `factcheck_date`, `run_folder`, `tools`, `total_features_checked`, `summary`, `results`, `ld_choices_pending`, `before_after_summary` 필드 필수.
- `summary` 필드에 `pass` / `yellow_flag` / `fail_resolved` / `behavior_update_reflected` / `ld_choice_pending` 5개 카운트 모두 존재.
- **summary 5개 카운트의 합 == `total_features_checked`** (불일치 시 즉시 fail).
- `results` 각 항목에 위 21개 필드 세트 존재 (해당 없음은 null 허용).
- `verdict=fail` 처리된 항목은 반드시 `replacement` 필드 존재 (또는 `ld_choices_pending`에 포함).
- `verdict=yellow_flag && signal="B-변경감지"` 항목은 반드시 `change_delta` 비어있지 않음 + `reconstruction.change_type="behavior_update_reflection"` 존재.
- `tool-features.json` SHA-256 pre/post 일치.

---

## Step S8 [Check]: 자체 품질 체크 + LD 고지

**입력**: S7의 factcheck-result.json + .v2.md 파일들.

### 1. 자체 품질 체크 (구조만, clarify §3.7)

- factcheck-result.json 필수 필드 누락 없음.
- 각 results 항목에 sources URL 형식 유효 (http:// 또는 https://로 시작).
- **verdict=fail 잔존 0건** (100% green 완결 원칙, clarify §3.1). 재구성 루프·LD 선택지 완료 후 최종 `verdict=fail` 항목이 남아있으면 산출물 저장 거부.
- `ld_choices_pending` 항목에 criticality + options 필수.
- v2.md 파일 존재 확인 (reconstruction_log와 실제 파일 일치).
- summary 합계 일치 재확인.

### 2. LD 결과 고지 (1회)

**내부 라벨 노출 0건 원칙**: `signal` · `verdict` · `reconstruction_level` · `loop_count` 등 내부 rubric 라벨을 LD 고지 텍스트에 **절대 포함하지 않는다**. 의미 문장으로 변환.

```
[Tool Feature Factcheck 완료]

검증 대상: {tools 목록}의 feature {N}개 (M1~M4 등장분)

결과:
- 문제 없음: {M1}개
  · 장기 안정 기능 (업데이트 기록 부재지만 공식 문서 현재형 기술): {부분 카운트}개
- 사용 가능 + 확인 권장: {M2}개
  · {feature_name_1} — {flag_reason}
- 동작 일부 변경 반영: {M4}개 (실습에 변경사항 반영 완료, feature 교체 없음)
  · {tool}/{모듈}: {feature_name} — {change_delta 요약}
- 대체 완료: {M3}개
  · {tool}/{모듈}: {기존 feature} → {신규 feature} ({선정 근거 한 줄})
- 참고 사항:
  · 지역 제한 있으나 한국 사용 가능: {해당 개수}개 (feature_name 목록)
  · 수동 검증 권장 (공식 소스 판별 불가): {ambiguous 개수}개 (feature_name 목록)
- LD 선택 필요: {M5}개 (있을 경우)
  · {tool}의 {feature} — {사유: 대체 2회 실패 / 자동 게이트 1 모순}. 선택지: 1/2/3

산출물:
- factcheck-result.json
- {변경 있는 모듈 수}개 .v2.md 파일 (대체 + 변경 반영 합산)

다음 공정 (시수 블록)이 이 결과를 자동 참조합니다.
```

### 3. 완결 판정

- 100% green 도달 + LD 선택지 없음 → 다음 공정으로 자동 진행.
- LD 선택지 있음 → LD 응답 대기 (예외 경로).

**산출물**: LD 대면 고지 텍스트 (1회 표시) + 완결 플래그.

**수락 기준**:
- **구조**:
  - 자체 품질 체크 6개 항목 전부 pass.
  - **`verdict=fail` 잔존 0건** (100% green 원칙 엄수). 잔존 시 산출물 저장 거부.
  - LD 고지에 M1~M4 카운트·주요 변경 내역 포함.
  - **내부 rubric 라벨(`signal` · `verdict` · `reconstruction_level` · `loop_count`) LD 고지에 노출 0건**.
- **의미**:
  - LD 고지가 의미 문장으로 작성됨.
  - 대체 발생 건은 before → after 쌍 명확히 표시.
  - 장기 안정 기능(STEP 6-a) 카운트가 pass 아래 분리 표시.

---

## Step S9 [Check]: Validation v2 15개 테스트셋 자체 체크

**목적**: Plan v2 실행 완료 직후, Validation v2의 15개 테스트셋(기준 1 × 5 + 기준 2 × 5 + 기준 3 × 5)이 모두 충족되는지 자체 점검. 15/15 pass 또는 fail 시 구체 개선 포인트를 `validation-check-result.json`으로 기록.

**입력**: S7 `factcheck-result.json` + S6 `.v2.md` 파일들 + Plan v2 본문(grep 대상) + `references/phase1-module-schema.md` + tool-features.json (SHA-256 pre/post).

### [기준 1 자체 체크 — 5개]

1. **샘플 8건 수집** — verdict_results에서 카테고리 각 1건씩 샘플링.
2. **5개 카테고리 존재 확인**:
   - (1) 단순 pass (STEP 5)
   - (2) 장기 안정 pass (STEP 6-a, stability_note 존재)
   - (3) 동작 일부 변경 yellow_flag (STEP 8, change_delta 존재)
   - (4) 한국 비대상 지역 제한 통과 (STEP 3-b, region_note 존재)
   - (5) 명확한 fail (STEP 1/3-a/9)
3. **부재 카테고리 adversarial 투입** (Validation v2 §기준 1 Adversarial 투입 규칙 b).
4. **자체 체크 항목 5개**:
   - **1-1 (단순 pass)**: STEP 5 케이스가 LLM 판정과 수동 기대 판정 일치 (8/8 또는 7/8 이상). 수동 기대 판정은 critic agent가 샘플 8건에 대해 각 STEP 대응 카테고리를 `references/rubric.md`의 [F1] 조건 분기 기준으로 부여한 값으로 한다 (`adversarial_injections` 로그에 기대 판정·실제 판정·일치 여부 함께 기록).
   - **1-2 (장기 안정 pass)**: STEP 6-a 케이스 stability_note 기록 존재 + verdict=pass.
   - **1-3 (경계 Plus 한정)**: C-plan 케이스 verdict=yellow_flag 통과.
   - **1-4 (fail 자동 게이트 1)**: `region_note="한국 비대상" AND verdict=fail` 조합 **0건** (자동 게이트 1 차단 확인).
   - **1-5 (fail 공식 소스 누락)**: `type="official"` 태깅 0건 AND `type="ambiguous"` 태깅 0건인 sources로 pass/yellow_flag 판정 항목 **0건** (자동 게이트 2 차단 확인).

### [기준 2 자체 체크 — 5개]

5. **replacement_plan 전수 검증**:
   - **2-1 (매핑 일관성 A)**: `module_id × criticality × reconstruction_level` 매핑 위반 **0건**.
   - **2-2 (source 검증 B)**: `source="tool-features.json"` 항목이 실제 features 배열에 name 실재, `source="new_web_search"` 항목이 refactcheck_sources에 공식 소스 1건 이상.
   - **2-3 (rationale 구체성 C)**: `criticality_rationale`이 4개 체크리스트(학습 목표/task action/description/다른 feature 차이) 중 2개 이상 포함. 위반율 ≤ 10%. **전제**: 검증 대상 feature 수 N≥10인 경우에만 본 테스트를 pass/fail 판정 대상으로 삼는다. N<10이면 "표본 부족 — 참고 기록만" 상태로 pass 처리하며 `total_checks` 계산에서 제외하지 않는다 (adversarial 투입으로 N 보강 시도는 권장).
6. **Plan v2 grep 검증**:
   - **2-4 (활성화 스위치 ①)**: `"부분 교체로 충분"` 문자열이 Plan v2 §1.3에 존재 → 기준 2 (A) 활성화.
   - **2-5 (활성화 스위치 ②)**: `"caveats 없음 > Plus"` 문자열이 Plan v2 §1.4에 존재 → [F4] tiebreaker 활성화.

### [기준 3 자체 체크 — 5개]

7. **스키마 + 해시 + 구조 검증**:
   - **3-1 (스키마 완결성 A)**: factcheck-result.json 필수 7종 필드 + summary 5종 카운트 + results 21종 필드 전부 존재.
   - **3-2 (SHA-256 B)**: tool-features.json pre/post 해시 일치.
   - **3-3 (.v2.md 구조 C)**:
     - Plan v2에 `phase1-module-schema.md` 존재 확인.
     - **`references/phase1-module-schema.md`의 필수 헤딩 리스트와 생성된 `m{N}-{tool}.v2.md`의 헤딩을 정규식 `^(#{1,6})\s+(.+)$` 기반으로 추출해 diff 수행.** "섹션 누락·추가 0건" 조건 검증.
     - **생성 정보 blockquote (`> 생성 정보`)는 diff 대상에서 제외.**
     - Level 2 재구성 모듈: M4는 `## 실습 시나리오` 내부 numbered list step count (정규식 `^\s*\d+\.\s+\*\*`)가 원본과 동일. M3는 `### 실습 N` 서브헤딩 수가 원본과 동일.
     - Level 3 재구성 모듈의 step 수 변경은 `level_selection_basis` 근거 필수.
     - 각 reconstruction 블록 `heading_schema_preserved=true`.
   - **3-4 (100% green D)**: `verdict=fail AND replacement=null AND ld_choices_pending 미등록` **0건**.
   - **3-5 (LD 고지 E)**: LD 고지 텍스트에 `"signal"`/`"verdict"`/`"reconstruction_level"`/`"loop_count"` 등 내부 라벨 **노출 0건** + summary 합계 일치 + SHA-256 일치 동시 충족.

**산출물**: `{run_folder}/phase2/factcheck/validation-check-result.json`

```json
{
  "check_date": "YYYY-MM-DD",
  "total_checks": 15,
  "passed": 15,
  "failed": 0,
  "results": [
    {"category": "기준 1", "test_id": "1-1", "description": "단순 pass (STEP 5) 샘플 일치율", "pass": true, "detail": "8/8 일치"},
    {"category": "기준 1", "test_id": "1-4", "description": "자동 게이트 1: region_note=한국 비대상 AND verdict=fail 0건", "pass": true, "detail": "전수 검색 결과 해당 조합 0건"}
  ],
  "adversarial_injections": [
    {"adversarial_id": "adv-001", "category": 3, "base_feature": "...", "mutation_detail": "...", "match": true, "injected_by": "critic"}
  ],
  "adversarial_consistency": 0.9,
  "improvement_points": []
}
```

**수락 기준**:
- **구조**:
  - validation-check-result.json 필수 필드 존재(check_date, total_checks=15, passed, failed, results[15], adversarial_injections, improvement_points).
  - results 각 항목에 category·test_id·description·pass·detail 필드 존재.
- **의미 (Check)**:
  - 15/15 pass 시 완결 플래그 `true` → 다음 공정 자동 호출.
  - 1건 이상 fail 시 improvement_points에 각 fail 항목의 구체 개선 포인트 기재(최소 gap + suggested_fix).
  - adversarial 투입이 발생한 경우 adversarial_consistency ≥ 0.8 권장.

---

## 실행 시간·병렬화 전략

- **S2의 feature별 검색은 병렬** (feature 간 독립).
- **S4의 criticality 판정도 병렬 가능** (fail feature 간 독립).
- **S5/S6는 S4 결과 의존이라 직렬**.
- 병렬 상한: 동시 LLM 호출 5~10개 (rate limit 고려).
- 전형 시나리오 (feature 10개, fail 2개): S2 ~40 호출 + S4 2 + S5 8 + S6 2 = ~52 호출 (S9 무호출).
- 목표 실행 시간: 5~10분 내 완결.

---

## 완결 원칙 요약

1. **100% green 완결**: verdict=fail 잔존 0건. LD 선택지 발동 시에도 공정 완료 후 LD 응답 대기.
2. **Skill 3 불침해**: tool-features.json SHA-256 pre/post 일치 (사이드카 전략).
3. **원본 헤딩 스키마 유지**: 재구성 v2.md는 원본과 헤딩 diff 0건.
4. **자동 게이트 1·2**: 한국 비대상 모순 + 공식 소스 누락 자동 차단 (ambiguous 카테고리 과잉 탈락 방지).
5. **LD 고지 내부 라벨 0건**: signal/verdict/reconstruction_level/loop_count 노출 금지.
6. **S9 자체 체크 15/15**: critic 실행 검증 선행 게이트.
