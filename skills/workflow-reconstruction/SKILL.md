---
name: workflow-reconstruction
description: "Reconstruct a role-level business workflow DAG from Task Cards. Connects tasks using Input/Output evidence across all phases. Identifies entry/exit points, divergence/convergence hubs, parallel streams, and readable stages. Use when: (1) user asks to design a workflow from task cards, (2) user says 'Stage 6', 'workflow design', 'workflow reconstruction', '업무 흐름 설계', 'task card 기반 워크플로우', 'DAG 만들기', 'stream/hub/stage 식별'. Do NOT use for: Stage 1-5 (research, ETL, atomization, DNA, task cards), AX task generation, or DB ingest."
---

# Workflow Reconstruction

Reconstruct a role-level workflow DAG from Task Cards using I/O evidence.

## Core principles

> **Unified workflow first** — default to one integrated workflow. Split only if truly independent clusters exist.
> **Cross-phase links allowed** — phase is metadata, not a hard boundary. Connect across phases when evidence supports it.
> **Evidence-only edges** — all connections must be grounded in Task Card I/O. No invented links.

## When to use

- "Stage 6", "workflow design", "업무 흐름 설계", "DAG 만들기"
- After Stage 5 Task Cards are complete

## When NOT to use

- Stage 1-5 (research, ETL, atomization, DNA, task cards)
- AX task generation, DB writes

## Reconstruction workflow

1. Load all Task Cards for the role
2. Build I/O matrix: each task's `immediate_output` vs all tasks' `inputs` → read [io-chaining-rules.md](references/io-chaining-rules.md)
3. Create edges with `evidence_status` (evidence-based or inferred)
4. Identify entry/exit points → read [workflow-boundaries.md](references/workflow-boundaries.md)
5. Identify hubs and streams → read [stream-and-stage-rules.md](references/stream-and-stage-rules.md)
6. Group into readable stages
7. Compute DAG metrics
8. Self-critique before final output
9. Validate output format → read [output-format.md](references/output-format.md)

## Output contract (summary)

```json
{
  "workflow_id": "wf__...",
  "workflow_name": "...",
  "role_id": "...",
  "tasks": [{"task_id": "...", "task_order": 1, "stream_label": "...", "is_entry_point": true, "is_exit_point": false}],
  "edges": [{"from_task_id": "...", "to_task_id": "...", "evidence_status": "evidence-based", "note": "..."}],
  "stages": [{"stage_id": "...", "stage_order": 1, "stage_name": "...", "stage_slug": "...", "task_ids": [...]}],
  "n_tasks": 27, "n_edges": 30, "max_out": 5, "max_in": 3,
  "n_streams": 3, "has_div": true, "has_conv": true,
  "self_critique": "..."
}
```

## Reference files

- **[stage6-rules.md](references/stage6-rules.md)**: Integration-first, cross-phase, evidence-only principles
- **[workflow-boundaries.md](references/workflow-boundaries.md)**: Entry/exit points, workflow split rules
- **[io-chaining-rules.md](references/io-chaining-rules.md)**: Output→Input matching, evidence vs inferred
- **[stream-and-stage-rules.md](references/stream-and-stage-rules.md)**: Hub, stream, stage grouping rules
- **[output-format.md](references/output-format.md)**: Exact JSON schema, DAG metrics
- **[examples.md](references/examples.md)**: Linear chain, branching, inferred link, independent cluster
