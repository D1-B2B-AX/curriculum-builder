---
name: curriculum-builder
description: 기업 AI 교육 커리큘럼 자동 생성 오케스트레이터. 회사·직무·툴·주제를 입력받아 M1(툴 소개) → M2(When/Why) → M3(기초 실습) → M4(메인 실습) 구조의 커리큘럼을 생성. /curriculum-builder 로 실행.
---

# Curriculum Builder — 교육 커리큘럼 자동 생성

회사·직무·툴·주제를 입력받아 **M4(메인 실습)부터 역산**하는 방식으로 M1~M4 구조의 교육 커리큘럼을 자동 생성한다. Phase 1(목적함수 — 시수·수준·보안 제약 없는 이상적 커리큘럼)까지를 본 오케스트레이터가 담당하며, Phase 2(제약 반영 재단)는 Skill 9 본격 설계 후 별도 단계.

---

## 실행 방법

```
/curriculum-builder    (경로·인자 없이 실행)
```

Skill 1이 LD와 대화로 필수 정보(회사명·직무·툴·주제)와 선택 정보(시수·보안·수준)를 수집한다. 별도 파일 입력 없음.

---

## 전체 실행 흐름

아래 순서대로 **자동 실행**. 각 Step 사이에 LD 확인 포인트가 있으면 LD 응답 받은 뒤 다음 Step으로 진행.

```
Step 1. 입력 수집 (Skill 1)
  └─ [LD 확인: 입력 확정]
Step 2. 직무 task 도출 (Skill 2 — 건호님 5개 스킬 wrapper)
  └─ [LD 확인: task 목록]
Step 3. 툴 기능 조사 (Skill 3)
Step 4. 실습 task top3 선정 (Skill 4)
  └─ [LD 확인: top3 + 주목할 task + 다양성 체크]
Step 5. M4 메인 실습 설계 (Skill 5) — 툴별
Step 6. M3 기초 실습 설계 (Skill 6) — 툴별
Step 7. M2 When/Why 설계 (Skill 7) — 툴별
Step 8. M1 툴 소개 설계 (Skill 8) — 툴별
Step 9. 최종 조합
  └─ [LD 확인: curriculum.md]
Phase 2 안내 (Skill 9 방향성 문서 참조)
```

**Phase 구분**:
- 본 오케스트레이터가 수행하는 Step 1~9 + 최종 조합 = **Phase 1 (목적함수)**
- Skill 9 Phase 2 본격 설계는 현재 **껍데기 미구현** 상태. 방향성 문서(`5. Skill9_Phase2_방향성.md`) 참조

---

## STEP 1: 입력 수집

`skills/skill-1-collect-input.md` 실행.

1. LD에게 회사명·직무·툴·주제(필수), 시수·보안·수준(선택) 수집
2. 3대 규칙 적용: 회사/직무 분리, 복수 툴 "등" 강제 질문, 일관성 검증
3. `input.json` 생성 + 실행 폴더(`{company}_{role}_{YYYYMMDDHHMM}/`) 생성 후 `run_folder` 필드에 기록
4. tools는 배열로 저장 (단일 툴도 배열). notes에 4종 플래그 기록

**산출물**: `curriculum-builder-output/{run_folder}/input.json`

**진행 표시**: `[완료] 입력 수집: {company}/{role}, 툴 {N}개, 주제 "{topic}"`

**LD 확인 포인트**:
- Skill 1이 내부적으로 입력 확정 문구로 확인 (서브 스킬 책임)
- LD "이대로 진행" → Step 2로 진행
- LD "수정" → Skill 1 재실행

---

## STEP 2: 직무 task 도출

`skills/skill-2-task-research.md` 실행. (건호님 5개 스킬 wrapper)

1. `input.json`의 company·role 읽기
2. **references/ 하위 파일 전체 Read 강제** — 건호님 5개 스킬(company-role-task-research / task-atomization / task-dna-classification / task-card-generation / workflow-reconstruction)의 references 모두 읽은 후 실행
3. 5단계 파이프라인 순차 실행 → tasks.json + task-research/ 하위 5개 파일
4. `task-cards.json`의 `one_liner`로 LD에게 업무 목록 요약 출력

**산출물**:
- `curriculum-builder-output/{run_folder}/tasks.json` (통합 포인터)
- `curriculum-builder-output/{run_folder}/task-research/raw-tasks.json`
- `curriculum-builder-output/{run_folder}/task-research/atomic-tasks.json`
- `curriculum-builder-output/{run_folder}/task-research/task-dna.json`
- `curriculum-builder-output/{run_folder}/task-research/task-cards.json`
- `curriculum-builder-output/{run_folder}/task-research/workflow.json`

**진행 표시**: `[완료] task 도출: {N}개 task, {M}개 stream`

**raw→atomic 커버리지 체크**:
- Skill 2 완료 후 메인 오케스트레이터가 카운트 비교:
  - `raw-tasks.json`의 raw task 수 vs `atomic-tasks.json`이 커버한 raw_task_id 수
- 커버되지 않은 raw task가 있으면 LD에게 경고:
  ```
  [경고] raw task {N}개 중 {M}개만 atomic task로 커버되었습니다.
  누락 task: {one_liner 목록}
  Skill 2 재실행을 권장합니다. 그대로 진행할까요?
  ```

**LD 확인 포인트**:
- Skill 2가 자체 요약 출력 (one_liner 기반 업무 목록)
- 커버리지 경고 발생 시 LD 응답에 따라 Skill 2 재실행 or 진행

---

## STEP 3: 툴 기능 조사

`skills/skill-3-tool-features.md` 실행.

1. `input.json`의 tools 배열 읽기
2. 툴별 독립 웹 검색 (notes.multi_tool = true면 각 툴 따로)
3. `tool-features.json` 생성 — 툴명을 키로 하는 dict 구조

**산출물**: `curriculum-builder-output/{run_folder}/tool-features.json`

**진행 표시**: `[완료] 툴 기능 조사: {툴명 목록}`

**LD 확인 포인트**: 없음 (Skill 3은 LD 대면 확인 없이 자동 진행. 극단 부족 시에만 LD 선택지 3개로 분기 — 서브 스킬 내부 처리)

---

## STEP 4: 실습 task top3 선정

`skills/skill-4-scoring/SKILL.md` 실행.

1. **references/ 하위 파일 전체 Read 강제** — rubric.md·prompts_eval.md·prompts_v2.md·prompts_killer.md·prompts_meta.md 5개 파일
2. Input 6개 파일 로드 (input.json + tool-features.json + tasks.json + task-research/3개)
3. 툴별 순회 → Killer 필터 → V3→V4→V2 평가 → 가중합 → top3 확정
4. 복수 주제 감지 시 matched_topic 태깅 + 다양성 체크
5. 고잠재력 저매칭 task가 4~6위이면 notable_outside_top3에 기록

**산출물**: `curriculum-builder-output/{run_folder}/top3-tasks.json`

**진행 표시**: `[완료] top3 선정: 툴별 top3 + notable {N}개 + 다양성 체크 {balanced/skewed}`

**LD 확인 포인트**:
- Skill 4가 자체 LD 출력 (top3 + notable + diversity 경고)
- LD "OK" → Step 5로 진행
- LD "top1을 notable X로 바꿔줘" / "이 task는 빼줘" → Skill 4 내부에서 처리 후 top3-tasks.json 갱신 → Step 5로 진행
- LD "다시 평가해줘" → Skill 4 재실행

---

## STEP 5: M4 메인 실습 설계 (툴별)

`skills/skill-5-m4-design.md` 실행.

1. `top3-tasks.json`의 `per_tool[tool].top3[0]` 기반 M4 설계
2. 툴별 순회 — `m4-{tool_name_safe}.md` 툴당 1개씩 생성
3. Phase 1 원칙 준수 — input.json의 security/hours/level 미사용

**산출물**: `curriculum-builder-output/{run_folder}/m4-{tool_name_safe}.md` (툴별)

**진행 표시**: `[완료] M4 설계: {tool} 당 실습 시나리오 생성`

**LD 확인 포인트**:
- Skill 5가 자체 LD 출력 (선정 task + 학습 목표 + 시나리오 + 사용 feature + 예상 산출물)
- LD "OK" → Step 6으로 진행
- LD "top2로 바꿔줘" / "시나리오 다르게" → Skill 5 재실행 → 본 Step 후속(Step 6·7·최종 조합)도 영향 (아래 "수정 요청 처리" 참조)

---

## STEP 6: M3 기초 실습 설계 (툴별)

`skills/skill-6-m3-design.md` 실행.

1. `m4-{tool}.md`의 "사용 feature 목록" 섹션 파싱
2. 툴별 M3 설계 — M4 feature 역산
3. 툴별 순회

**산출물**: `curriculum-builder-output/{run_folder}/m3-{tool_name_safe}.md` (툴별)

**진행 표시**: `[완료] M3 설계: {tool} 당 기초 실습 생성`

**LD 확인 포인트**:
- Skill 6이 자체 LD 출력
- LD "OK" → Step 7로 진행
- 수정 요청 시 Skill 6 재실행 → 최종 조합 영향

---

## STEP 7: M2 When/Why 설계 (툴별)

`skills/skill-7-m2-design.md` 실행.

1. `top3-tasks.json` + `m4-{tool}.md` + `m3-{tool}.md` + `tool-features.json` 참조
2. 툴별 M2 모듈 구성 기획 작성 (배경 근거 + 강의 구성 제안 3~5꼭지)

**산출물**: `curriculum-builder-output/{run_folder}/m2-{tool_name_safe}.md` (툴별)

**진행 표시**: `[완료] M2 설계: {tool} 당 When/Why 꼭지 생성`

**LD 확인 포인트**:
- Skill 7이 자체 LD 출력 (꼭지별 내용 포함)
- LD "OK" → Step 8로 진행
- 수정 요청 시 Skill 7 재실행 → 최종 조합 영향

---

## STEP 8: M1 툴 소개 설계 (툴별)

`skills/skill-8-m1-design.md` 실행.

1. `tool-features.json` + `input.json.topic` 참조 (task-agnostic)
2. 툴별 M1 모듈 구성 기획 작성 (도구 유형 + 기본 사용 방식 + 기능 개괄, 3꼭지)

**산출물**: `curriculum-builder-output/{run_folder}/m1-{tool_name_safe}.md` (툴별)

**진행 표시**: `[완료] M1 설계: {tool} 당 툴 소개 꼭지 생성`

**LD 확인 포인트**:
- Skill 8이 자체 LD 출력
- LD "OK" → Step 9(최종 조합)로 진행
- 수정 요청 시 Skill 8 재실행 → 최종 조합 영향

---

## STEP 9: 최종 조합

`skills/skill-final-curriculum-assembly.md` 실행.

1. 툴별 m1·m2·m3·m4.md 로드
2. 툴별 "커리큘럼 표 + 모듈 구성 설명" 생성
3. 단일 `curriculum.md` 파일로 통합 저장 (복수 툴이면 툴별 섹션 나란히)

**산출물**: `curriculum-builder-output/{run_folder}/curriculum.md`

**진행 표시**: `[완료] 최종 조합: curriculum.md 생성 ({툴 수}개 툴별 섹션)`

**LD 확인 포인트**:
- 최종 조합이 자체 LD 출력 (툴별 표 + 모듈 구성 설명 미리보기)
- LD "OK" → Phase 2 안내 → 종료
- LD "M{N} 내용을 다르게" → 해당 Skill(5/6/7/8) 재실행 → 최종 조합 재실행

---

## Phase 2 안내

Step 9 완료 후 LD에게 안내:

```
Phase 1 커리큘럼 생성이 완료되었습니다.
- 산출물: curriculum-builder-output/{run_folder}/curriculum.md

다음 단계: Phase 2 (시수·수준·보안 제약 반영 재단)
- 현재 Skill 9은 본격 설계 전 단계입니다. 별도로 재단 작업이 필요하시면 
  5. Skill9_Phase2_방향성.md 문서를 참고하시거나,
  Claude에게 "이 curriculum.md를 시수 N시간·보안 제약에 맞춰 재단해줘"로 수동 요청이 가능합니다.
```

---

## 수정 요청 처리 (의존성 체인)

LD가 중간에 수정을 요청할 때 **영향받는 후속 Step을 연쇄 재실행**한다. 각 Step의 재실행 영향 범위:

| 수정된 Step | 후속 재실행 필요 |
|---|---|
| Skill 1 (입력) | Skill 2 ~ 최종 조합 전부 (input.json 변경 → 하류 전체) |
| Skill 2 (task 도출) | Skill 4 → Skill 5·6·7 → 최종 조합 |
| Skill 3 (툴 기능) | Skill 4 → Skill 5·6·7·8 → 최종 조합 |
| Skill 4 (top3) | Skill 5·6·7 → 최종 조합 (Skill 8은 task-agnostic이라 영향 없음) |
| Skill 5 (M4) | Skill 6 (M4 역산) → Skill 7 (task 인용) → 최종 조합 |
| Skill 6 (M3) | 최종 조합 |
| Skill 7 (M2) | 최종 조합 |
| Skill 8 (M1) | 최종 조합 |
| 최종 조합 | 없음 (끝) |

**재실행 원칙**:
- 영향받는 후속 Step은 **자동으로 재실행** (LD에게 "Skill X 수정 시 Skill Y·Z 재실행 필요합니다. 진행할까요?" 확인 후)
- 재실행 시 이전 산출물은 **덮어쓰기** (동일 run_folder 내 수정)
- 완전히 처음부터 재실행하려면 `/curriculum-builder` 재호출 → 새 run_folder 생성

---

## 공통 정책

### references/ 전체 Read 강제

`references/` 하위 파일을 가진 스킬은 실행 전 **전체 Read 필수**. SKILL.md 요약만으로 판단 금지.

- **Skill 2**: 건호님 5개 서브 스킬 각자의 references
- **Skill 4**: `skill-4-scoring/references/` 5개 파일 (rubric·prompts_eval·prompts_v2·prompts_killer·prompts_meta)

Skill 1·3·5·6·7·8·최종 조합은 references/ 없음. 이 규정 적용 대상 아님.

### 파일 저장 구조 (run_folder)

모든 산출물은 `curriculum-builder-output/{company}_{role}_{YYYYMMDDHHMM}/` 하위에 저장.

- 폴더 생성 책임: **Skill 1**이 전담. `input.json.run_folder` 필드에 경로 기록
- 후속 스킬은 `input.json.run_folder` 참조해 같은 폴더에 저장
- 폴더명 규칙: 공백·특수문자는 언더스코어 치환, 타임스탬프는 분 단위 12자리
- 같은 회사·직무 재실행 시 타임스탬프로 자동 구분 (새 폴더 생성)

### Phase 1 순수 원칙

Step 5·6·7·최종 조합은 **보안·시수·수준 미반영**. `input.json.security/hours/level`은 읽지 않음 (각 스킬의 "Skill 9 인계" 섹션에 `input.json` 값 그대로 인용 표시만 함). 제약 반영 재단은 Phase 2(Skill 9) 영역.

### LD 확인 타이밍

- **Skill 1 끝 / Skill 2 끝 / Skill 4 끝 / 최종 조합 끝**: 4곳의 주요 LD 확인 포인트
- Skill 3·5·6·7·8은 각자 자체 LD 출력하지만 다음 Step으로 자동 진행 가능 (LD가 개입 안 하면 통과)
- LD가 어느 Step에서든 수정 요청 시 "수정 요청 처리" 섹션의 의존성 체인 적용

---

## LD 대면 출력 공통 규칙 (ASCII 대체)

LD가 보는 터미널에서 유니코드 특수문자와 한글이 인접할 때 렌더링 깨짐이 발생할 수 있다. 메인 오케스트레이터 출력에는 아래 ASCII 대체 원칙을 적용한다.

| 특수문자 | 대체 |
|---|---|
| `→` | `->` |
| `✅` | `[완료]` |
| `✓` | `[완료]` |
| `•` | `-` |
| `⚠` / `⚠️` | `[경고]` 또는 `[주의]` |

**한글+특수문자 사이 공백 확보**: "Skill4완료" 대신 "Skill 4 [완료]"처럼 공백으로 가독성 확보.

**후속 과제**: 서브 스킬(Skill 1~8·최종 조합)의 LD 대면 출력 템플릿은 현재 이모지·특수문자를 일부 사용. 일괄 반영은 후속 과제로 남김. 본 메인 오케스트레이터 자체 출력은 ASCII 대체를 먼저 준수.

---

## 실패 처리 통합 정책

### 자동 재시도
서브 스킬의 LLM 호출 실패 시 각 스킬이 자체적으로 최대 2회 재시도.

### Case A (LD 조치 가능)
서브 스킬이 Case A로 실패 → 서브 스킬의 LD 안내 템플릿 그대로 전달 → LD 응답 받아 해당 Step 재실행 또는 파이프라인 중단

### Case B (시스템 오류)
서브 스킬이 Case B로 실패 → 원인 명시된 오류 메시지 전달 → 파이프라인 중단. 사용자가 원인 해결 후 `/curriculum-builder` 재호출

### 파이프라인 중단 조건
- 필수 입력 누락 (Skill 1에서 누락 템플릿 안내)
- Killer Criteria 탈락으로 Skill 4에서 남은 task 3개 미만
- 서브 스킬 Case B 시스템 오류

### 선행 파일 누락 감지
각 Step 시작 시 선행 Step의 산출물 존재 여부 확인:
- `input.json` 누락 → Skill 1 선행 요구
- `tasks.json` / `task-research/` 누락 → Skill 2 선행 요구
- `tool-features.json` 누락 → Skill 3 선행 요구
- `top3-tasks.json` 누락 → Skill 4 선행 요구
- `m1·m2·m3·m4-{tool}.md` 누락 → 해당 Skill 선행 요구

---

## 파일 레이아웃 요약

```
curriculum-builder-output/
└── {company}_{role}_{YYYYMMDDHHMM}/      ← run_folder (Skill 1이 생성)
    ├── input.json                         ← Skill 1
    ├── tasks.json                         ← Skill 2 (통합 포인터)
    ├── tool-features.json                 ← Skill 3
    ├── top3-tasks.json                    ← Skill 4
    ├── m4-{tool}.md                       ← Skill 5 (툴별)
    ├── m3-{tool}.md                       ← Skill 6 (툴별)
    ├── m2-{tool}.md                       ← Skill 7 (툴별)
    ├── m1-{tool}.md                       ← Skill 8 (툴별)
    ├── curriculum.md                      ← 최종 조합
    └── task-research/                     ← Skill 2 세부
        ├── raw-tasks.json
        ├── atomic-tasks.json
        ├── task-dna.json
        ├── task-cards.json
        └── workflow.json
```

---

## 금지 사항

- **Step 순서 임의 변경 금지** — Step 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 최종 조합 순서 고정. 역산 빌드 순서(M4→M3→M2→M1)가 이미 Step 5~8에 반영됨
- **서브 스킬 내부 규정 오버라이드 금지** — 각 서브 스킬의 LD 출력·실패 처리·재시도 정책은 서브 스킬 책임. 메인은 오케스트레이션(전환·연쇄)만 관리
- **references 누락 상태 실행 금지** — Skill 2·4는 references Read 강제. 선행 Read 없이 실행 시 품질 저하
- **Phase 2 영역 침범 금지** — Step 5·6·7·최종 조합은 보안·시수·수준 미반영. 이 규정은 각 서브 스킬에 이미 명시됨. 메인에서 임의로 Phase 2 로직 삽입 금지
- **run_folder 임의 변경 금지** — Skill 1이 생성한 폴더를 후속 스킬이 참조. 메인이나 다른 스킬이 임의로 경로 변경하면 파일 산개
- **Skill 9 본격 설계 지연 상태에서 가짜 Phase 2 결과 생성 금지** — Skill 9은 현재 미구현. 최종 조합 이후 LD에게 방향성 문서 안내만 하고 종료
- **수정 요청의 연쇄 재실행 생략 금지** — Skill 5 수정 시 Skill 6·7·최종 조합 자동 재실행 필요 확인. LD 모르게 넘기면 결과물 불일치
