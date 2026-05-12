---
name: task-researcher
description: curriculum-builder 직무 task 도출. 건호님 5개 스킬(company-role-task-research → task-atomization → task-dna-classification → task-card-generation → workflow-reconstruction)을 순서대로 실행하는 wrapper.
---

# Skill 2: 직무 task·워크플로우 도출

교육 대상 직무의 사람이 **실제로 뭘 하는지**를 구체적으로 도출한다.
건호님이 만든 5개 스킬을 순서대로 실행하는 wrapper 역할이다.

## 왜 이 스킬이 필요한가

Skill 4(실습 task 후보 선정)에서 스코어링 대상이 되는 task 풀을 만드는 단계다.
"이 직무의 실제 task → DNA 분류 → 카드화 → 워크플로우"까지 나와야 Skill 4가 근거 있는 선택을 할 수 있다.

## Input

- Skill 1이 생성한 실행 폴더(`{바탕화면}/curriculum-builder-output/{company}_{role}_{YYYYMMDDHHMM}/`) 안의 `input.json`에서 **`company`, `role`, `run_folder`를 읽는다.**
- `run_folder`는 Skill 1이 input.json에 기록한 **절대 경로**. Skill 2의 모든 산출물은 이 경로 하위 `phase1/task-research/`에 저장한다.
- `topic`, `tools`, `hours`, `security`, `level`은 **이 스킬에서 사용하지 않는다.** 이 스킬은 직무 전체 task를 모두 도출하는 단계이지 특정 주제로 좁히는 단계가 아니다.
- `input.notes`도 **참조하지 않는다.** Skill 1의 notes 규약에 따르면 `multi_tool` / `consistency_check`는 Skill 3~5가, `company_role_split` / `role_trim`은 참고용이다. Skill 2는 입력 원본(company, role, run_folder)만 필요.

## 실행 전 사전 확인 (중요)

### 1) 스킬 설치 여부 확인

아래 5개 스킬이 로컬에 모두 설치되어 있어야 한다. 실행 시작 전에 각 경로의 SKILL.md 존재 여부를 확인한다.

| 단계 | 스킬 이름 | 필수 경로 |
|------|----------|----------|
| 2-1 | `company-role-task-research` | `~/.claude/skills/company-role-task-research/SKILL.md` |
| 2-2 | `task-atomization` | `~/.claude/skills/task-atomization/SKILL.md` |
| 2-3 | `task-dna-classification` | `~/.claude/skills/task-dna-classification/SKILL.md` |
| 2-4 | `task-card-generation` | `~/.claude/skills/task-card-generation/SKILL.md` |
| 2-5 | `workflow-reconstruction` | `~/.claude/skills/workflow-reconstruction/SKILL.md` |

**누락 시**: 아래 템플릿으로 중단 안내 후 종료한다. 임의로 대체 로직을 만들거나 진행하지 않는다.

```
⚠ Skill 2 실행 전 점검에 실패했습니다

다음 스킬이 설치되어 있지 않아 파이프라인을 진행할 수 없습니다:
- {누락된 스킬명 1}: {예상 경로}
- {누락된 스킬명 2}: {예상 경로}

해당 스킬을 설치한 뒤 다시 시도해주세요.
```

### 2) 스킬 문서 전체 숙지 (필수)

각 하위 스킬을 실행하기 전에, 해당 스킬의 **SKILL.md 본문과 `references/` 하위 모든 파일**을 Read한다.

**SKILL.md는 요약본이며, 실제 운영 규칙(Tier fallback, 쿼리 순서, split 규칙, 분류 기준, stream 식별 규칙, `[inferred]` 태그 규정 등)은 references에 상세히 명시되어 있다.**

5개 스킬의 references 목록:

| 스킬 | references 파일 |
|------|----------------|
| `company-role-task-research` | scope.md, source-priority.md, task-extraction-rules.md, output-format.md, examples.md |
| `task-atomization` | scope.md, golden-rule-and-splitting.md, phase-primitive-rules.md, output-format.md, examples.md, review-flags.md |
| `task-dna-classification` | primitive-lv2-quick.md, domain-lv2-quick.md, mechanism-lv2-quick.md, stage4-rules.md, output-format.md, examples.md (boundary case 시 primitive-lv2.md / domain-lv2.md / mechanism-lv2.md 추가 Read) |
| `task-card-generation` | stage5-rules.md, task-card-fields.md, io-linking-rules.md, output-format.md, examples.md |
| `workflow-reconstruction` | stage6-rules.md, workflow-boundaries.md, io-chaining-rules.md, stream-and-stage-rules.md, output-format.md, examples.md |

**원칙**:
- SKILL.md 요약만으로 실행 판단을 내리지 않는다.
- 실행 중 판단이 필요한 순간(예: Tier fallback 시 어느 소스를 쓸지, stream 그룹화, trigger 추론 여부 등)에는 references의 해당 규정을 **반드시** 참조한다.
- references 파일을 읽지 않고 "SKILL.md에 안 적혀 있으니 내 판단으로 처리한다"는 금지. 실제 운영 규칙 대부분이 references에 있다.

## 실행 순서 (건호님 5개 스킬 파이프라인)

아래 5개 스킬을 **반드시 순서대로** 실행한다. 각 스킬은 해당 SKILL.md를 Read하여 **그 안에 적힌 워크플로우·실행 절차·output contract를 그대로 따른다.**

| 단계 | 스킬 이름 | 역할 |
|------|----------|------|
| 2-1 | `company-role-task-research` | 웹 검색으로 회사·직무의 raw task 15-20개 도출 |
| 2-2 | `task-atomization` | raw task를 atomic task로 원자화 + phase/primitive_lv1 할당 |
| 2-3 | `task-dna-classification` | atomic task에 DNA(primitive_lv2, domain, mechanism) 분류 + full_code 생성 |
| 2-4 | `task-card-generation` | task_dna를 운영용 task card로 변환 (trigger/inputs/action/output) |
| 2-5 | `workflow-reconstruction` | task cards를 DAG 워크플로우로 재구성 |

### 각 단계의 실행 프로토콜

1. 해당 스킬의 **SKILL.md와 `references/` 하위 모든 파일**을 Read한다. (위 "실행 전 사전 확인 2)"의 references 목록 참조)
2. SKILL.md 본문 + references 규정을 **그대로** 따른다. 판단이 필요한 순간에는 해당 references의 규정을 우선 참조.
3. 이전 단계의 output을 현재 단계의 input으로 사용한다.
4. 결과를 아래 "저장 파일 규약"대로 저장한다.
5. **중간 단계 요약은 LD에게 보고하지 않는다.** 조용히 다음 단계로 진행한다.

## 저장 파일 규약

모든 산출물은 **실행 폴더**(`{run_folder}/`) 내부의 `phase1/task-research/` 하위에 저장한다 (Skill 2는 Phase 1 단계 산출이므로 phase1/ 하위에 묶음). `{run_folder}`는 Skill 1이 input.json의 `run_folder` 필드에 기록한 절대 경로 (바탕화면 하위 `curriculum-builder-output/{company}_{role}_{YYYYMMDDHHMM}`).

| 단계 | 저장 경로 | 내용 |
|------|----------|------|
| 2-1 | `{run_folder}/phase1/task-research/raw-tasks.json` | company-role-task-research의 output (tasks + sources) |
| 2-2 | `{run_folder}/phase1/task-research/atomic-tasks.json` | task-atomization의 output (atomic tasks 배열) |
| 2-3 | `{run_folder}/phase1/task-research/task-dna.json` | task-dna-classification의 output (DNA가 붙은 tasks) |
| 2-4 | `{run_folder}/phase1/task-research/task-cards.json` | task-card-generation의 output (task cards 배열) |
| 2-5 | `{run_folder}/phase1/task-research/workflow.json` | workflow-reconstruction의 output (DAG) |

> 하위 폴더(`task-research/`) 사용은 이 스킬이 5개 파일을 일괄 생성하기 때문에 묶음용으로 채택.
> 다른 스킬들(Skill 1의 input.json, Skill 3의 tool-features.json 등)은 실행 폴더 루트에 직접 저장한다.
> 이 경로 규약이 전체적으로 적절한지는 **메인 SKILL.md 설계 시 재검토**한다.

### 최종 통합 파일

5단계 실행 완료 후, Skill 4 이후가 참조하기 쉽도록 통합 파일을 하나 더 만든다.

**저장 경로**: `{run_folder}/tasks.json`

```json
{
  "company": "현대카드",
  "role": "마케팅팀 퍼포먼스 마케터",
  "raw_tasks_ref": "phase1/task-research/raw-tasks.json",
  "atomic_tasks_ref": "phase1/task-research/atomic-tasks.json",
  "task_dna_ref": "phase1/task-research/task-dna.json",
  "task_cards_ref": "phase1/task-research/task-cards.json",
  "workflow_ref": "phase1/task-research/workflow.json",
  "summary": {
    "n_tasks": 26,
    "n_streams": 3
  }
}
```

> 통합 파일은 **포인터(ref)** 방식이다. `_ref` 값은 실행 폴더 기준 상대 경로.
> 실제 task 데이터는 각 단계 파일에 있다. Skill 4는 주로 `task-cards.json`(개별 task 정보)과 `workflow.json`(관계)을 참조하게 된다.
> summary에는 최종 요약 출력에 필요한 최소 지표(`n_tasks`, `n_streams`)만 담는다.

## 실행 절차

1. `input.json`을 읽어 `company`, `role`, `run_folder`를 확인한다. 이후 모든 저장 경로는 `{run_folder}/` 기준.
2. 사전 확인: 5개 스킬 설치 여부. 누락 시 중단.
3. LD에게 시작 안내를 간결하게 표시한다:
   > "Skill 2 (직무 task 도출)을 시작합니다. 5단계 파이프라인(웹 리서치 → 원자화 → DNA 분류 → 카드화 → 워크플로우)을 순차 실행합니다. 완료 후 결과를 요약해 드릴게요."
4. **2-1 실행**: `company-role-task-research` SKILL.md Read → 지시대로 실행 → `raw-tasks.json` 저장.
5. **2-2 실행**: `task-atomization` SKILL.md Read → 지시대로 실행 (input: 2-1 결과) → `atomic-tasks.json` 저장.
   - 이 시점에 `atomic_task` 개수를 확인. 아래 "실패 처리" 참조.
6. **2-3 실행**: `task-dna-classification` SKILL.md Read → 지시대로 실행 (input: 2-2 결과) → `task-dna.json` 저장.
7. **2-4 실행**: `task-card-generation` SKILL.md Read → 지시대로 실행 (input: 2-3 결과) → `task-cards.json` 저장.
8. **2-5 실행**: `workflow-reconstruction` SKILL.md Read → 지시대로 실행 (input: 2-4 결과) → `workflow.json` 저장.
9. **통합 파일 생성**: 각 단계 결과 참조를 묶어 `tasks.json` 저장. `summary.n_tasks`는 `task-cards.json`의 카드 개수, `summary.n_streams`는 `workflow.json`의 스트림 개수.
10. **Skill 3 (툴 기능 조사)으로 자동 진입한다.** Skill 2는 LD에게 task 목록을 보여주지 않고 조용히 다음 단계로 넘어간다. (★ 4/21 회의 결정 — LD 중간 확인 영역 폐기. task 목록은 Skill 4 후보 선정 시점에 LD에게 직접 선택지 형태로 제시.)

`atomic_task`가 3~4개인 경계 케이스에서는 내부 메모로 기록하되 LD에게는 별도 안내하지 않는다. (Skill 4 후보 선정 시점에 자연 인지 가능)

## 실패 처리

### 자동 재시도 (LD에게 알리지 않음)

LLM의 일시적 실수나 시스템 측 오류는 LD 개입 없이 자동 재시도로 해결한다:
- 각 스킬 output의 필수 필드 누락 / 형식 오류
- 일시적 네트워크 오류
- 웹 검색 결과 파싱 실패

재시도 정책: 같은 단계 최대 2회까지 자동 재시도.

### Case A: 업무 정보 부족 — LD가 조치 가능

**조건**:
- `raw_task` < 5개 (2-1 완료 시점) — 검색 증거 극단 부족
- `atomic_task` < 3개 (2-2 완료 시점) — 업무 파악 부실

**템플릿**:

```
⚠ 업무 파악에 조금 더 도움이 필요합니다

{회사} {직무}에 대한 공개 정보가 제한적이라 업무를 {N}개밖에 확보하지 못했습니다.
더 정확한 결과를 위해 혹시 아래 중 알려주실 수 있는 게 있을까요?

- 이 직무가 조직 내에서 **다른 명칭**으로도 불리나요?
  (예: "QA팀" ↔ "품질관리팀", "CS팀" ↔ "고객지원팀")
- **대체할 수 있는 유사 직무**가 있나요?

또는 이 상태로 진행하거나 중단하셔도 됩니다.
```

### Case B: 시스템 오류 — 자동 재시도 2회 실패 시

**조건**: 자동 재시도 2회 후에도 동일 오류 지속 (스키마 오류, 실행 에러 등)

**템플릿**:

```
⚠ 파이프라인 실행 중 문제가 발생했습니다

시스템 내부에서 반복해서 같은 오류가 발생했습니다.
일시적 문제일 가능성이 있으니, 잠시 후 새 세션에서 다시 시도해주세요.
```

## 금지 사항

- 건호님 5개 스킬은 이미 완성되어 있으므로, Skill 2는 각 스킬의 SKILL.md를 읽어 그 안의 지시를 **그대로** 따르기만 한다. 웹 검색 방식을 변형하거나, 분류 기준을 새로 만들거나, 내부 로직을 Skill 2 안에 다시 작성하는 등의 개입은 일절 하지 않는다.
- 5개 스킬의 실행 순서를 바꾸지 않는다. 각 스킬은 이전 단계 output을 input으로 요구하므로 순서가 고정이다.
- `topic`/`tools`/`hours`/`security`/`level`/`notes` 등 이 스킬과 무관한 input 필드를 참고하지 않는다. 직무 task는 주제·툴·시수에 종속되지 않는다.
- 임의로 task를 추가하거나 제거하지 않는다. 각 스킬이 생성한 결과를 그대로 저장한다.
- 스킬이 설치되어 있지 않을 때 대체 로직(예: 건호님 스킬 없이 직접 웹 검색)을 임의로 실행하지 않는다. 반드시 중단 안내.
- **중간 단계 요약을 LD에게 보고하지 않는다.** 내부 용어(atomic task, DNA, review_flags, edges 등)는 LD에게 의미 없는 정보. 파이프라인 실행 중엔 조용히 진행하고, 완료 시점에만 업무 목록(one_liner) 중심으로 요약한다.
- **웹 검색 결과를 대화창에 정리/출력하지 않는다.** 검색 결과를 받으면 바로 다음 행동(파일 저장, 추가 검색 등)으로 이어간다. 검색 raw 결과를 텍스트로 정리하면 출력 한계로 응답이 끊길 수 있다.
- 파이프라인 실행 중 LD가 문제를 지적하지 않는 한 중간에 멈추거나 개입 유도를 하지 않는다. 자동 처리가 원칙.
