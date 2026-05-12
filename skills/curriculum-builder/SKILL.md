---
name: curriculum-builder
description: 기업 AI 교육 커리큘럼 자동 생성 오케스트레이터. 회사·직무·툴·주제를 입력받아 M1(툴 소개) → M2(When/Why) → M3(기초 실습) → M4(메인 실습) 구조의 커리큘럼을 생성한다. Phase 1(목적함수 — 시수·수준·보안 제약 없는 이상적 커리큘럼)과 Phase 2(표준화 — 표준 시수 short 6h·long 12h 두 세트, feature 검증·시수 구성·톤앤매너·LD 친화 설명)를 자동 chain으로 처리한다. Phase 3(LD input 시수·수준·보안 반영) 진입은 LD 의사결정 영역. /curriculum-builder 로 실행.
---

# Curriculum Builder — 교육 커리큘럼 자동 생성

회사·직무·툴·주제를 입력받아 **M4(메인 실습)부터 역산**하는 방식으로 M1~M4 구조의 교육 커리큘럼을 자동 생성한다. Phase 1(목적함수 — 시수·수준·보안 제약 없는 이상적 커리큘럼)과 Phase 2(표준화 — 표준 시수 두 세트 + feature 검증·시수 구성·톤앤매너·LD 친화 설명) 두 단계를 본 오케스트레이터가 자동 chain으로 담당하며, Phase 3(LD input 시수·수준·보안 반영 자유 대화)는 공정 4 종료 시점의 LD 의사결정 영역.

---

## 실행 방법

```
/curriculum-builder    (경로·인자 없이 실행)
```

Skill 1이 LD와 대화로 필수 정보(회사명·직무·툴·주제)와 선택 정보(시수·보안·수준)를 수집한다. 별도 파일 입력 없음.

---

## STEP 0: 업데이트 체크 (자동, 최우선 실행)

파이프라인 시작 전 가장 먼저 GitHub 원격 레포의 최신 커밋을 확인해 LD가 최신 스킬을 쓰고 있는지 본다. 네트워크 실패·API rate limit 등 조회 불가 시 **조용히 넘어가 STEP 1로 진행**한다. 파이프라인을 막지 않는다.

### 동작 원리

GitHub은 매 push마다 커밋에 고유 SHA를 자동 부여한다. 이 SHA를 **버전 식별자**로 사용하므로 별도 버전 파일을 수동 관리할 필요가 없다. install.ps1이 설치 시점 SHA를 `INSTALLED_COMMIT` 파일에 기록하고, 본 STEP 0이 GitHub 최신 SHA와 비교한다.

### 실행 절차

1. **로컬 설치 SHA 읽기**
   - 경로: `~/.claude/skills/curriculum-builder/INSTALLED_COMMIT`
   - 내용 예시: `f2b83791a2b3c4d5e6f7...` (Git commit SHA 40자)
   - 파일이 없으면 "미설치"로 간주하고 다음 단계에서 업데이트 안내

2. **GitHub 최신 SHA 조회**
   - URL: `https://api.github.com/repos/D1-B2B-AX/curriculum-builder/commits/main`
   - WebFetch 도구 사용. 응답 JSON의 `sha` 필드 추출
   - 조회 실패(네트워크 오류·rate limit 등) 시 **조용히 스킵** 후 STEP 1 진행

3. **비교 및 분기**
   - **동일** → 아무 안내 없이 STEP 1 진행
   - **다름** (또는 로컬 미설치) → 아래 안내 후 LD 답변 대기. 표기 시 SHA는 **앞 7자**로 축약:

     ```
     [알림] curriculum-builder 업데이트가 있습니다
     - 로컬 커밋: {local_short or "미설치"}
     - 최신 커밋: {remote_short}

     업데이트하려면 curriculum-builder 레포를 clone한 폴더에서 PowerShell로:
       git pull
       .\install.ps1

     업데이트 후에는 새 Claude Code 세션에서 /curriculum-builder 를 다시 실행해주세요.
     업데이트 없이 그대로 진행하려면 "진행"이라고 답해주세요.
     ```

4. **LD 응답 처리**
   - "진행" / "skip" / "이대로" → STEP 1로 진행
   - "업데이트" / "할게" → 파이프라인 종료 (LD가 수동으로 업데이트 후 재실행)
   - 무응답 / 모호 → "진행" 여부 한 번 더 확인 후 결정

### 금지 사항
- 업데이트 체크 실패가 파이프라인을 막지 않아야 한다. 오프라인·방화벽·API rate limit 환경에서도 스킬이 기본 동작해야 함
- LD가 "진행"을 선택하면 버전 차이를 이유로 기능을 제한하지 않는다 — 기존 로컬 스킬로 정상 실행
- SHA 전체(40자)를 LD 출력에 그대로 노출하지 않는다. 가독성을 위해 앞 7자만 표시

---

## 전체 실행 흐름

아래 순서대로 **자동 실행**. 각 Step 사이에 LD 확인 포인트가 있으면 LD 응답 받은 뒤 다음 Step으로 진행.

```
Step 0.  업데이트 체크 (자동, 최우선)

[Phase 1 — 목적함수: 시수·수준·보안 제약 없는 이상적 커리큘럼]
Step 1.  입력 수집 (Skill 1)
  └─ [LD 확인: 입력 확정]
Step 2.  직무 task 도출 (Skill 2 — 건호님 5개 스킬 wrapper)
Step 3.  툴 기능 조사 (Skill 3)
Step 4.  실습 task 후보 선정 (Skill 4)
  └─ [LD 확인: 후보 5건 (top 3 + potential 2 / 또는 top 5) — LD가 M4 task 직접 선택, 무응답 시 top 1 fallback]
Step 5.  M4 메인 실습 설계 (Skill 5) — 툴별
Step 6.  M3 기초 실습 설계 (Skill 6) — 툴별
Step 7.  M2 When/Why 설계 (Skill 7) — 툴별
Step 8.  M1 툴 소개 설계 (Skill 8) — 툴별
Step 9.  Phase 1 조합 (skill-phase1-curriculum-assembly)
  └─ [LD 확인: curriculum.md]

[Phase 2 — 표준화: 표준 시수 short 6h·long 12h 두 세트 + feature 검증·시수 구성·톤앤매너·LD 친화 설명]
Step 10. 공정 1 — Tool Feature Factcheck (skill-factcheck)
Step 11. 공정 1 후속 — Curriculum Rebuild (skill-curriculum-rebuild)
Step 12. 공정 2 — Hours-Blocks (skill-hours-blocks)
Step 13. 공정 3 — Block-Refinement (skill-block-refinement)
Step 14. 공정 4 — Curriculum-Final (skill-curriculum-final)
  └─ [LD 확인: Phase 3 진입 의도 질문 — 공정 4 영역에서 처리]

[Phase 3 — 운영 제약 반영: LD input 시수·수준·보안 자유 대화]
본 오케스트레이터 종료 후 LD 의사결정 영역. 공정 4의 Phase 3 진입 의도 질문에 LD가 "예"로 답하면 Phase 3 자유 대화 진입.
```

**Phase 구분**:
- 본 오케스트레이터가 수행하는 Step 1~9 + Phase 1 조합 = **Phase 1 (목적함수)**
- Step 10~14 (공정 1·rebuild·2·3·4) = **Phase 2 (표준화)** — 표준 시수 두 세트 + 본 도구 사명 4영역(feature 검증·시수 구성·톤앤매너·LD 친화)
- Phase 3 (LD input 반영)은 본 오케스트레이터 종료 후 LD-Claude 자유 대화 영역 — 공정 4 LD 고지가 Phase 3 진입 의도 질문 처리

---

## STEP 1: 입력 수집

`skills/skill-1-collect-input.md` 실행.

1. LD에게 회사명·직무·툴·주제(필수), 시수·보안·수준(선택) 수집
2. 3대 규칙 적용: 회사/직무 분리, 복수 툴 "등" 강제 질문, 일관성 검증
3. `input.json` 생성 + 실행 폴더(`{company}_{role}_{YYYYMMDDHHMM}/`) 생성 후 `run_folder` 필드에 기록
4. tools는 배열로 저장 (단일 툴도 배열). notes에 4종 플래그 기록

**산출물**: `{run_folder}/input.json`

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
3. 5단계 파이프라인 순차 실행 → `{run_folder}/tasks.json` + `{run_folder}/phase1/task-research/` 하위 5개 파일
4. `task-cards.json`의 `one_liner`로 LD에게 업무 목록 요약 출력

**산출물**:
- `{run_folder}/tasks.json` (통합 포인터)
- `{run_folder}/phase1/task-research/raw-tasks.json`
- `{run_folder}/phase1/task-research/atomic-tasks.json`
- `{run_folder}/phase1/task-research/task-dna.json`
- `{run_folder}/phase1/task-research/task-cards.json`
- `{run_folder}/phase1/task-research/workflow.json`

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

**LD 확인 포인트**: 자동 진행 (Skill 2가 자체 요약 출력 — one_liner 기반 업무 목록 — 후 다음 Step으로 자동 진행. 커버리지 경고 발생 시에만 LD 선택지 분기)

---

## STEP 3: 툴 기능 조사

`skills/skill-3-tool-features.md` 실행.

1. `input.json`의 tools 배열 읽기
2. 툴별 독립 웹 검색 (notes.multi_tool = true면 각 툴 따로)
3. `tool-features.json` 생성 — 툴명을 키로 하는 dict 구조

**산출물**: `{run_folder}/tool-features.json`

**진행 표시**: `[완료] 툴 기능 조사: {툴명 목록}`

**LD 확인 포인트**: 없음 (Skill 3은 LD 대면 확인 없이 자동 진행. 극단 부족 시에만 LD 선택지 3개로 분기 — 서브 스킬 내부 처리)

---

## STEP 4: 실습 task 후보 선정

`skills/skill-4-scoring/SKILL.md` 실행.

1. **references/ 하위 파일 전체 Read 강제** — rubric.md·prompts_eval.md·prompts_v2.md·prompts_killer.md·prompts_meta.md 5개 파일
2. Input 6개 파일 로드 (`{run_folder}/` 직속: input.json + tool-features.json + tasks.json / `{run_folder}/phase1/task-research/`: task-cards.json·task-dna.json·workflow.json 3개)
3. 툴별 순회 → Killer 필터 → V3→V4→V2 평가 → 가중합 → 후보 확정
4. 복수 주제 감지 시 matched_topic 태깅 + 다양성 체크
5. **후보 영역 = 항상 총 5건** (분기): 4~6위를 스캔해 `v3.score ≥ 5 && v4.primary_score ≤ 1`인 task를 추출 →
   - 추출 결과 **2개 이상** → top 3 + potential 2 (potential에 `high_potential_low_match=true`)
   - 추출 결과 **0~1개** → 잠재 후보 영역 폐기·top 5 (4~5위 점수 기준 task로 채움·potential 빈 배열)

**산출물**: `{run_folder}/top-tasks.json`

**진행 표시**: `[완료] 후보 선정: 툴별 후보 5건 (top 3 + potential 2 / 또는 top 5) + 다양성 체크 {balanced/skewed}`

**LD 확인 포인트** (★ 4/21 회의 결정 — LD 직접 선택 모델):
- Skill 4가 자체 LD 출력 (후보 5건 + diversity 경고)
- **LD가 5개 후보 중 M4 설계할 task를 직접 선택** → 선택 task로 Skill 5 진입 (potential 영역 task 선택 시 skill-5가 그대로 받음)
- LD가 task를 직접 선택하지 않고 "기본"·"진행해"·"알아서" 등 모호하게 답하면 → **top 1 fallback** (자동 선정) → Skill 5 진입
- LD가 후보 관련 질문·논의를 하면 → 먼저 답한 뒤 다시 선택을 받는다 (질문 무시하고 top 1로 넘어가지 않음)
- LD "top1을 potential의 X로 바꿔줘" / "이 task는 빼줘" → Skill 4 내부에서 처리 후 top-tasks.json 갱신
- LD "다시 평가해줘" → Skill 4 재실행

---

## STEP 5: M4 메인 실습 설계 (툴별)

`skills/skill-5-m4-design.md` 실행.

1. **LD 선택 task 수령** — Skill 4가 LD에게 직접 선택 받은 task로 M4 설계 (LD 무응답 시 Skill 4 영역에서 top 1 fallback이 이미 박힘·skill-5는 받기만). rank 순회 영역 폐기
2. 선택 task에 LLM 실습 가능성 판정 적용 ("가능" → 진행 / "불가" → LD에게 다른 후보 선택 요청)
3. 툴별 순회 — `m4-{tool_name_safe}.md` 툴당 1개씩 생성
4. Phase 1 원칙 준수 — input.json의 security/hours/level 미사용

**산출물**: `{run_folder}/phase1/m4-{tool_name_safe}.md` (툴별)

**진행 표시**: `[완료] M4 설계: {tool} 당 실습 시나리오 생성`

**LD 출력 (자동 진행 — 주요 확인 포인트 아님)**:
- Skill 5가 자체 LD 출력 (선정 task + 학습 목표 + 시나리오 + 사용 feature + 예상 산출물) 후 **Step 6으로 자동 진행**. "확인해주세요"로 멈추지 않는다 — m4 검토·수정은 Phase 1 조합 끝(주요 확인 포인트)에서 "M4 다르게" 요청 → 의존성 체인으로 Skill 5 재실행으로 처리
- 단, LD가 이 시점에 직접 수정을 요청하면("다른 후보로" / "시나리오 다르게") 즉시 반영 — Skill 5 재실행 (LD가 5개 후보 영역에서 다른 task 직접 선택) → 본 Step 후속(Step 6·7·Phase 1 조합)도 영향 (아래 "수정 요청 처리" 참조)

---

## STEP 6: M3 기초 실습 설계 (툴별)

`skills/skill-6-m3-design.md` 실행.

1. `m4-{tool}.md`의 "사용 feature 목록" 섹션 파싱
2. 툴별 M3 설계 — M4 feature 역산
3. 툴별 순회

**산출물**: `{run_folder}/phase1/m3-{tool_name_safe}.md` (툴별)

**진행 표시**: `[완료] M3 설계: {tool} 당 기초 실습 생성`

**LD 출력 (자동 진행 — 주요 확인 포인트 아님)**:
- Skill 6이 자체 LD 출력 후 **Step 7로 자동 진행** ("확인해주세요"로 멈추지 않음 — m3 검토·수정은 Phase 1 조합 끝에서 처리)
- 단, LD가 이 시점에 직접 수정 요청 시 즉시 반영 — Skill 6 재실행 → Phase 1 조합 영향

---

## STEP 7: M2 When/Why 설계 (툴별)

`skills/skill-7-m2-design.md` 실행.

1. `top-tasks.json` + `m4-{tool}.md` + `m3-{tool}.md` + `tool-features.json` 참조
2. 툴별 M2 모듈 구성 기획 작성 (배경 근거 + 강의 구성 제안 3~5꼭지)

**산출물**: `{run_folder}/phase1/m2-{tool_name_safe}.md` (툴별)

**진행 표시**: `[완료] M2 설계: {tool} 당 When/Why 꼭지 생성`

**LD 출력 (자동 진행 — 주요 확인 포인트 아님)**:
- Skill 7이 자체 LD 출력 (꼭지별 내용 포함) 후 **Step 8로 자동 진행** ("확인해주세요"로 멈추지 않음 — m2 검토·수정은 Phase 1 조합 끝에서 처리)
- 단, LD가 이 시점에 직접 수정 요청 시 즉시 반영 — Skill 7 재실행 → Phase 1 조합 영향

---

## STEP 8: M1 툴 소개 설계 (툴별)

`skills/skill-8-m1-design.md` 실행.

1. `tool-features.json` + `input.json.topic` 참조 (task-agnostic)
2. 툴별 M1 모듈 구성 기획 작성 (도구 유형 + 기본 사용 방식 + 기능 개괄, 3꼭지)

**산출물**: `{run_folder}/phase1/m1-{tool_name_safe}.md` (툴별)

**진행 표시**: `[완료] M1 설계: {tool} 당 툴 소개 꼭지 생성`

**LD 출력 (자동 진행 — 주요 확인 포인트 아님)**:
- Skill 8이 자체 LD 출력 후 **Step 9(Phase 1 조합)로 자동 진행** ("확인해주세요"로 멈추지 않음 — m1 검토·수정은 Phase 1 조합 끝에서 처리)
- 단, LD가 이 시점에 직접 수정 요청 시 즉시 반영 — Skill 8 재실행 → Phase 1 조합 영향

---

## STEP 9: Phase 1 조합

`skills/skill-phase1-curriculum-assembly.md` 실행.

1. 툴별 m1·m2·m3·m4.md 로드
2. 툴별 "커리큘럼 표 + 모듈 구성 설명" 생성
3. 단일 `curriculum.md` 파일로 통합 저장 (복수 툴이면 툴별 섹션 나란히)

**산출물**: `{run_folder}/phase1/curriculum.md`

**진행 표시**: `[완료] Phase 1 조합: curriculum.md 생성 ({툴 수}개 툴별 섹션)`

**LD 확인 포인트**:
- Phase 1 조합이 자체 LD 출력 (툴별 표 + 모듈 구성 설명 미리보기)
- LD "OK" → **Step 10 (Phase 2 진입)으로 자동 진행**
- LD "M{N} 내용을 다르게" → 해당 Skill(5/6/7/8) 재실행 → Phase 1 조합 재실행

---

## STEP 10: 공정 1 — Tool Feature Factcheck

`skills/skill-factcheck/SKILL.md` 실행.

1. **references/ 하위 파일 전체 Read 강제** — rubric.md·prompts_criticality.md·prompts_replacement.md·prompts_reconstruction.md·phase1-module-schema.md 5개 파일
2. Phase 1이 산출한 m1~m4 모듈에서 등장하는 툴 feature를 현재 시점 기준으로 웹 검증
3. 문제 발견 시 대체 feature 선정 → 모듈 재구성 (`.v2.md` 별도 파일·원본 보존)
4. tool-features.json SHA-256 pre/post 일치 의무 (Skill 3 불침해)

**산출물**:
- `{run_folder}/phase2/factcheck/factcheck-result.json`
- `{run_folder}/phase2/factcheck/m{N}-{tool}.v2.md` (영향 모듈만)
- `{run_folder}/phase2/factcheck/validation-check-result.json`

**진행 표시**: `[완료] 공정 1 factcheck: {N}개 feature 검증, 영향 모듈 {M}건`

**LD 확인 포인트**:
- 자동 진행. 예외 경로(자동 게이트 1 한국 비대상 모순·대체 2회 실패)에서만 LD 선택지 분기
- 정상 흐름은 자동으로 Step 11 진입

---

## STEP 11: 공정 1 후속 — Curriculum Rebuild

`skills/skill-curriculum-rebuild/SKILL.md` 실행.

1. `factcheck-result.json`의 변경 반영 건수 점검 (`summary.behavior_update_reflected + summary.fail_resolved`)
2. 분기:
   - 합 ≥ 1 → 2-A 흐름 (LLM 재합성. `.v2.md` 본문을 1순위 source로 영향 모듈만 갱신)
   - 합 = 0 → 2-B 흐름 (LLM 호출 X·curriculum.md 단순 복사·헤더만 갱신)
3. ★ 어떤 흐름이든 `curriculum-post-factcheck.md` **항상 생성** (공정 2의 1차 input source)
4. 원본 `curriculum.md` 보존 (불침해)

**산출물**: `{run_folder}/phase2/factcheck/curriculum-post-factcheck.md`

**진행 표시**: `[완료] 공정 1 후속 rebuild: {llm_generated/copy_only}, 영향 모듈 {M}건 반영`

**LD 확인 포인트**: 없음 (자동 진행). 자동으로 Step 12 진입

---

## STEP 12: 공정 2 — Hours-Blocks

`skills/skill-hours-blocks/SKILL.md` 실행.

1. `curriculum-post-factcheck.md`를 1차 source로 받아 모듈별로 두 시수 세트 생성
2. **short** (합 6h, 모듈별 1·1·2·2h): 재단 — post-factcheck 본문 그대로 복사 + 시수 라벨
3. **long** (합 12h, 모듈별 2·2·4·4h): 옵션 c 모듈별 차등 합성 — M3·M4 적극 재생성·M2·M1 추가 거리 있으면 합성·없으면 정직 표기 (`module_labels.{m1|m2|...}: "short_equivalent"`)
4. 합성 순서: M4 → M3 → M2 → M1 (역산)

**산출물**:
- `{run_folder}/phase2/blocks/short.md`
- `{run_folder}/phase2/blocks/long.md`
- `{run_folder}/phase2/blocks/short-meta.json`
- `{run_folder}/phase2/blocks/long-meta.json`

**진행 표시**: `[완료] 공정 2 hours-blocks: short/long 두 세트 생성, long 정직성 라벨 {short_equivalent N건 / expanded M건}`

**LD 확인 포인트**: 없음 (자동 진행). 자동으로 Step 13 진입

---

## STEP 13: 공정 3 — Block-Refinement

`skills/skill-block-refinement/SKILL.md` 실행.

1. 공정 2 산출 4건을 1차 input으로 받아 **표 영역 bullet 워딩만** LD 친화 spec 정합으로 정밀 보강
2. 모듈 구성 설명(산문체 3~5줄) + 메타 영역은 손대지 X — 공정 4 책임
3. 톤앤매너 source 2건 정합: (a) Phase 1 조합 spec + curriculum.md 모델 (한 묶음. §"Bullet 작성 원칙") / (b) BGF리테일 제안서 톤앤매너 (bullet 짧은 명사구 패턴 한정 차용)
4. LLM 호출 3회 (short-refined 1 + long-refined 1 + 자체 점검 1)

**산출물**:
- `{run_folder}/phase2/block-refinement/short-refined.md`
- `{run_folder}/phase2/block-refinement/long-refined.md`
- `{run_folder}/phase2/block-refinement/short-meta-refined.json`
- `{run_folder}/phase2/block-refinement/long-meta-refined.json`

**진행 표시**: `[완료] 공정 3 block-refinement: 표 bullet 워딩 정정, 게이트 5건 PASS`

**LD 확인 포인트**: 없음 (자동 진행). 자동으로 Step 14 진입

---

## STEP 14: 공정 4 — Curriculum-Final

`skills/skill-curriculum-final/SKILL.md` 실행.

1. 공정 3 산출 4건을 1차 input으로 받고 `curriculum-post-factcheck.md`를 보조 input으로 받아 **모듈별 LD 설명 4건**(M1·M2·M3·M4 각 5-7줄 산문체) 작성
2. 표 본체는 공정 3 산출 그대로 보존(글자 단위), LD 설명만 추가
3. 단일 chunk — 4 모듈 동시 합성. short·long 차이를 한 산문 안에서 자연 서술
4. 정직성 라벨 차등 처리 — `short_equivalent` 모듈은 3 요소 자연 포함 (정직성 표시·확장 어려움 사유·절감 시간 활용 제안)
5. 본 도구 메타 13 정규식 필터링 (`P-\d+`·patch_log·★ 표시 등 LD 영역 침투 0건)
6. LLM 호출 2회 (합성 1 + 평가 1, Sonnet 시작·퀄리티 불안 시 Opus)
7. **GAS 2회 POST**:
   - POST 1: Phase 2 결과물 직후 자동 (`reached_phase: "phase_2"`. 무조건)
   - POST 2: LD가 Phase 3 진입 의도 질문에 "예" 답변 시 (`reached_phase: "phase_3"`. 조건부)

**산출물**:
- `{run_folder}/curriculum-final_{company}_{role}_{timestamp}.md` ★ LD가 받는 유일한 메인 문서 — **run_folder 직속** (폴더 열면 바로 보임)
- `{run_folder}/phase2/curriculum-final-meta/final-result.json` (부속 메타·검증 자료)
- `{run_folder}/phase2/curriculum-final-meta/self-check-result.json` (부속 메타·검증 자료)

**진행 표시**: `[완료] 공정 4 curriculum-final: LD 검토용 단일 문서 생성, 모듈별 LD 설명 4건`

**LD 확인 포인트**:
- 공정 4 자체 LD 고지에 **Phase 3 진입 의도 질문** 박혀있음:
  ```
  기업의 맥락, 시수, 보안/환경 제약, 수강생 수준 등을 반영하여 고도화할 수 있게 계속 대화를 진행하시겠습니까?
  ```
- LD "예" → POST 2 호출(`reached_phase: "phase_3"`) → Phase 3 자유 대화 진입 (본 오케스트레이터 종료 후 LD-Claude 자유 대화 영역)
- LD "아니오" / 무응답 → 본 오케스트레이터 종료. `curriculum-final_{company}_{role}_{timestamp}.md`가 LD 표준 산출물

---

## 수정 요청 처리 (의존성 체인)

LD가 중간에 수정을 요청할 때 **영향받는 후속 Step을 연쇄 재실행**한다. 각 Step의 재실행 영향 범위:

| 수정된 Step | 후속 재실행 필요 |
|---|---|
| Skill 1 (입력) | Skill 2 ~ 공정 4 전부 (input.json 변경 → 하류 전체) |
| Skill 2 (task 도출) | Skill 4 → Skill 5·6·7 → Phase 1 조합 → 공정 1·rebuild·2·3·4 |
| Skill 3 (툴 기능) | Skill 4 → Skill 5·6·7·8 → Phase 1 조합 → 공정 1·rebuild·2·3·4 |
| Skill 4 (후보) | Skill 5·6·7 → Phase 1 조합 → 공정 1·rebuild·2·3·4 (Skill 8은 task-agnostic이라 영향 없음) |
| Skill 5 (M4) | Skill 6 (M4 역산) → Skill 7 (task 인용) → Phase 1 조합 → 공정 1·rebuild·2·3·4 |
| Skill 6 (M3) | Skill 7 (M2가 m3 feature 목록 인용) → Phase 1 조합 → 공정 1·rebuild·2·3·4 |
| Skill 7 (M2) | Phase 1 조합 → 공정 1·rebuild·2·3·4 |
| Skill 8 (M1) | Phase 1 조합 → 공정 1·rebuild·2·3·4 |
| Phase 1 조합 | 공정 1·rebuild·2·3·4 |
| 공정 1 (factcheck) | rebuild → 공정 2·3·4 |
| 공정 1 후속 (rebuild) | 공정 2·3·4 |
| 공정 2 (hours-blocks) | 공정 3·4 |
| 공정 3 (block-refinement) | 공정 4 |
| 공정 4 (curriculum-final) | 없음 (끝) |

**재실행 원칙**:
- 영향받는 후속 Step은 **자동으로 재실행** (LD에게 "Skill X 수정 시 후속 Step 재실행 필요합니다. 진행할까요?" 확인 후)
- 재실행 시 이전 산출물은 **덮어쓰기** (동일 run_folder 내 수정)
- 완전히 처음부터 재실행하려면 `/curriculum-builder` 재호출 → 새 run_folder 생성

---

## 공통 정책

### references/ 전체 Read 강제

`references/` 하위 파일을 가진 스킬은 실행 전 **전체 Read 필수**. SKILL.md 요약만으로 판단 금지.

- **Skill 2**: 건호님 5개 서브 스킬 각자의 references
- **Skill 4**: `skill-4-scoring/references/` 5개 파일 (rubric·prompts_eval·prompts_v2·prompts_killer·prompts_meta)
- **공정 1 (skill-factcheck)**: `skill-factcheck/references/` 5개 파일 (rubric·prompts_criticality·prompts_replacement·prompts_reconstruction·phase1-module-schema)

Skill 1·3·5·6·7·8·Phase 1 조합·공정 1 후속(rebuild)·공정 2·공정 3·공정 4는 references/ 폴더 없음 — 본 SKILL.md 본문 통합 spec. 이 규정 적용 대상 아님.

### 파일 저장 구조 (run_folder)

**루트 디렉토리 = 사용자 바탕화면 하위 `curriculum-builder-output/`**. LD가 산출물을 쉽게 찾도록 바탕화면에 둔다.
- 바탕화면 경로는 환경마다 다를 수 있다 — 보통 `~/Desktop`, OneDrive 동기화 시 `~/OneDrive/Desktop`. Skill 1이 실행 시점에 실제 바탕화면 경로를 찾아 `curriculum-builder-output/{company}_{role}_{YYYYMMDDHHMM}/` 폴더를 생성한다.
- `input.json.run_folder` 필드에는 **절대 경로**를 기록한다 (예: `C:\Users\GA\Desktop\curriculum-builder-output\LG생활건강_디자이너_202605081624`). 후속 스킬은 이 절대 경로를 그대로 참조.
- 폴더 생성 책임: **Skill 1**이 전담.
- 폴더명 규칙: 공백·특수문자는 언더스코어 치환, 타임스탬프는 분 단위 12자리.
- 같은 회사·직무 재실행 시 타임스탬프로 자동 구분 (새 폴더 생성).

**run_folder 하위 구조**:

```
{run_folder}/   (= ~/Desktop/curriculum-builder-output/{company}_{role}_{YYYYMMDDHHMM}/)
├── curriculum-final_{company}_{role}_{timestamp}.md   ★ LD가 받는 최종본 — run_folder 직속, 폴더 열면 바로 보임
├── input.json·tasks.json·tool-features.json·top-tasks.json   (직속·Step 1~4 메타 산출)
├── phase1/   (Phase 1 작업 산출)
│   ├── m1~m4-{tool}.md·curriculum.md  (Step 5~9 산출)
│   └── task-research/  (Step 2 Skill 2 산출 5건 — raw·atomic·dna·cards·workflow)
└── phase2/   (Phase 2 작업 산출)
    ├── factcheck/
    │   ├── factcheck-result.json·m{N}-{tool}.v2.md·validation-check-result.json  (Step 10 공정 1 산출)
    │   └── curriculum-post-factcheck.md  (Step 11 rebuild 산출)
    ├── blocks/
    │   └── short.md·long.md·short-meta.json·long-meta.json  (Step 12 공정 2 산출)
    ├── block-refinement/
    │   └── short-refined.md·long-refined.md·short-meta-refined.json·long-meta-refined.json  (Step 13 공정 3 산출)
    └── curriculum-final-meta/
        └── final-result.json·self-check-result.json  (Step 14 공정 4 부속 메타·검증 자료. LD가 받는 최종본 md는 run_folder 직속에 있음)
```

★ **핵심 원칙**: LD가 받는 최종 산출물(`curriculum-final_*.md`)만 run_folder 직속에 둔다. 나머지(메타 json·m1~m4·중간 조합본·각 공정 작업물)는 작업 폴더(`phase1/`·`phase2/`) 안에. `phase2/curriculum-final-meta/`는 공정 4가 낸 부속 메타·검증 자료만 (최종본 md 아님 — 이름에 `-meta` 붙여 혼동 방지).

★ **경로 표기 해석 규칙**: 본 SKILL.md·sub skill 본문에서 `{run_folder}/...` 또는 (일부 sub skill에 남아 있는) `curriculum-builder-output/{run_folder}/...`로 표기된 경로는 **모두 `input.json.run_folder`의 절대 경로 기준**이다. `run_folder`는 이미 `{바탕화면}/curriculum-builder-output/{company}_{role}_{YYYYMMDDHHMM}` 절대 경로를 담고 있으므로, 앞에 `curriculum-builder-output/`이 또 붙은 표기는 잉여 — run_folder 절대 경로만 쓰면 된다.

### Phase 1·2·3 분리 원칙

| Phase | 영역 | LD input(시수·보안·수준) 반영 |
|---|---|---|
| **Phase 1** (Step 1~9) | 목적함수 — 시수·수준·보안 제약 없는 이상적 커리큘럼 | ❌ 미반영 (input.json security/hours/level은 산출물 본문에 박지 X — Phase 3 영역. 5/6 base-rollback 결정으로 skill-5·6·7·8·Phase 1 조합의 "Skill 9 인계" 섹션 폐기됨) |
| **Phase 2** (Step 10~14) | 표준화 — 표준 시수 short 6h·long 12h 두 세트 | ❌ 미반영 (LD input 시수·보안·수준은 Phase 3 영역) |
| **Phase 3** | 운영 제약 반영 — LD-Claude 자유 대화 | ✅ 반영 (시수·보안·수준 모두 LD input 그대로 활용) |

★ Phase 2 = "LD가 받는 표준 원형 커리큘럼" 생성. LD가 Phase 3 자유 대화로 운영 제약 반영하여 고도화하는 전제.

★ skill-curriculum-rebuild가 만드는 `curriculum-post-factcheck.md`에는 **"Skill 9 인계" 섹션 박지 X** (5/6 base-rollback 결정). Phase 2 진입 시점에 LD input 영역은 산출물에서 제거되며 Phase 3 자유 대화에서 다시 활용.

### LD 확인 타이밍

- **주요 LD 확인 포인트 4곳** (= 시스템이 자발적으로 멈춰 LD 응답을 받는 지점): Skill 1 끝 (입력 확정) / **Skill 4 끝 (LD가 5개 후보 중 M4 task 직접 선택 — ★ 4/21 회의 결정. LD가 task를 선택하지 않거나 "기본"·"진행해" 등 모호하게 답하면 top 1 fallback)** / Phase 1 조합 끝 / **공정 4 끝 (Phase 3 진입 의도 질문)**
- Skill 2·3·5·6·7·8은 각자 자체 LD 출력하지만 **응답을 끊지 않고 다음 Step으로 바로 이어감** (STEP 5~8은 한 턴 안에서 흐르는 구간 — LD 응답을 받는 지점이 아님. LD가 끼어들 수 있는 건 다음 주요 확인 포인트). Skill 2는 커버리지 경고 발생 시에만 LD 선택지 분기
- **공정 1·rebuild·공정 2·공정 3은 자동 진행** (예외 경로 — 공정 1 자동 게이트 1·대체 2회 실패 시만 LD 선택지 분기)
- **확인 포인트에서 LD가 질문·논의를 하면** (진행 의사도 수정 요청도 아닌 경우): 자동 진행하지 말고 — **먼저 그 질문에 답한 뒤, LD의 진행/수정 의사를 다시 확인하고 진행**한다. 질문을 무시하고 다음 단계로 넘어가지 않는다
- LD가 어느 Step에서든 수정 요청 시 "수정 요청 처리" 섹션의 의존성 체인 적용 (수정 대상 산출물의 출처 Step부터 하류 전부 재실행)

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
