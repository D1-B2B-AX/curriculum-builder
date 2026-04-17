---
name: task-card-generation
description: "Generate Stage 5 operational task cards from task_dna. Produces one task card per task with trigger, inputs, action, immediate_output, one_liner, and I/O linkage across same-role tasks. Use when: (1) user asks to create task cards or write operational task cards, (2) user says 'Stage 5', 'Task Card', 'task card 작성', '운영용 task card', 'Trigger/Input/Output 정리', 'task_dna를 카드로 변환'. Do NOT use for: Stage 1-4 (research, ETL, atomization, DNA classification), workflow design, AX task generation, or DB ingest."
---

# Task Card Generation

Generate operational task cards from task_dna. One card per task, role-level processing.

## Core rules

> **task_id is IMMUTABLE.** Never change it.
> **Process all tasks for the same role together** — not one at a time in isolation.
> **action_text must start with primitive_lv2** (e.g., "Generate: ...", "Rank: ...").

## When to use

- "Stage 5", "Task Card", "task card 작성", "Trigger/Input/Output 정리"
- After Stage 4 DNA classification is complete

## When NOT to use

- Stage 1-4 (research, ETL, atomization, DNA)
- Stage 6+ (workflows, AX tasks)
- DB writes or pipeline orchestration

## Workflow

1. Load all tasks for the role (preserve task_id)
2. Scan all tasks to identify potential I/O links → read [io-linking-rules.md](references/io-linking-rules.md)
3. For each task, write card fields → read [task-card-fields.md](references/task-card-fields.md)
4. Apply trigger/action/output discipline → read [stage5-rules.md](references/stage5-rules.md)
5. Validate output format → read [output-format.md](references/output-format.md)
6. Check wording quality → read [examples.md](references/examples.md)

## Field summary

| Field | Rule |
|-------|------|
| `one_liner` | What/How/Value in one sentence |
| `trigger_text` | Concrete event. If inferred, prefix `[inferred]` |
| `inputs` | 1-3 practical items. No filler. Reuse same-role outputs when real |
| `action_text` | Must start with `primitive_lv2:` |
| `immediate_output` | Concrete artifact, not abstract activity |
| `actor` | Who performs this |
| `cadence` | How often |
| `card_confidence` | 1-100 integer |

## Output contract (summary)

```json
{
  "task_id": "td__...",
  "one_liner": "...",
  "trigger_text": "...",
  "inputs": [{"seq": 1, "input_text": "..."}],
  "action_text": "Generate: ...",
  "immediate_output": "...",
  "actor": "...",
  "cadence": "...",
  "card_confidence": 85,
  "assumption_note": "...",
  "evidence_note": "..."
}
```

## Reference files

- **[stage5-rules.md](references/stage5-rules.md)**: Trigger/Action/Output discipline, role-level processing
- **[task-card-fields.md](references/task-card-fields.md)**: Field definitions, good/bad values
- **[io-linking-rules.md](references/io-linking-rules.md)**: Same-role I/O linkage rules
- **[output-format.md](references/output-format.md)**: Exact JSON schema
- **[examples.md](references/examples.md)**: Good/bad card examples
