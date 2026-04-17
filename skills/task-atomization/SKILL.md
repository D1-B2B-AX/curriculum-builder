---
name: task-atomization
description: "Split raw role-task descriptions into atomic tasks using the immediate-deliverable rule. Assign phase (P1-P4) and primitive_lv1 (SENSE/DECIDE/TRANSFORM/TRANSFER/COMMIT/ASSURE). Use when: (1) user asks to atomize tasks, split raw tasks, or decompose role tasks, (2) user says 'Stage 3', 'atomization', 'atomic task', '과업 원자화', 'task 쪼개기', 'raw task 분해', (3) user wants phase and primitive labels on decomposed tasks. Do NOT use for: Stage 1 research, Stage 2 ETL, Stage 4 DNA/ontology, workflow design, AX task generation, or DB ingest."
---

# Task Atomization

Split raw tasks into atomic work units. Assign phase and primitive_lv1.

## Golden Rule

> If the immediate deliverable is different, **split**.
> If the immediate deliverable is the same, **keep as one**.

## When to use

- "이 raw task들을 atomic task로 원자화해줘"
- "Stage 3", "atomization", "과업 원자화", "task 쪼개기"

## When NOT to use

- Stage 1 research, Stage 2 ETL, Stage 4 DNA classification
- Workflow design, AX task generation, DB writes

## Splitting rules (summary)

- Split: "보고서를 작성하고 경영진에게 보고한다" → 2 tasks (작성=TRANSFORM, 보고=TRANSFER)
- Keep: "예산, 인력, 자원을 관리한다" → 1 task (same deliverable: 관리 결과)
- Avoid over-splitting: "데이터를 수집·정리·분석한다" → 1 task if single analytical output

See [golden-rule-and-splitting.md](references/golden-rule-and-splitting.md) for full rules.

## Phase / Primitive mapping

| Phase | Primitive_lv1 | 행위 |
|-------|--------------|------|
| P1 (Discover) | SENSE | 조사, 수집, 모니터링 |
| P2 (Design) | DECIDE | 판단, 평가, 의사결정 |
| P3 (Deliver) | TRANSFORM | 생산, 변환, 생성 |
| P3 (Deliver) | TRANSFER | 전달, 배포, 공유 |
| P3 (Deliver) | COMMIT | 승인, 확정, 계약 |
| P4 (Deploy) | ASSURE | 검증, 품질관리, 모니터링 |

See [phase-primitive-rules.md](references/phase-primitive-rules.md) for details.

## Output contract

Each atomic task produces:
```json
{
  "atomic_task_id": "at__{raw_role_task_id}__{index:03d}",
  "raw_role_task_id": "rrt__...",
  "atomic_index": 1,
  "atomic_text": "[대상] [동사]하기",
  "phase": "P1",
  "primitive_lv1": "SENSE",
  "phase_confidence": 85,
  "split_confidence": 90,
  "parent_context": "original raw task text",
  "split_reason": "different deliverables: report vs presentation",
  "semantic_bucket_hint": "Financial",
  "rationale": "...",
  "review_flags": []
}
```

See [output-format.md](references/output-format.md) for full spec.

## Review flags

- `low_specificity`: task too vague to classify
- `phase_boundary`: could belong to multiple phases
- `split_uncertain`: splitting decision is ambiguous
- `oversplit`: may have been over-decomposed

See [review-flags.md](references/review-flags.md).

## Reference files

- **[scope.md](references/scope.md)**: Trigger/non-trigger examples
- **[golden-rule-and-splitting.md](references/golden-rule-and-splitting.md)**: Split decision logic
- **[phase-primitive-rules.md](references/phase-primitive-rules.md)**: Phase/primitive assignment
- **[output-format.md](references/output-format.md)**: Exact JSON schema
- **[examples.md](references/examples.md)**: Canonical split/no-split examples
- **[review-flags.md](references/review-flags.md)**: Flag definitions
