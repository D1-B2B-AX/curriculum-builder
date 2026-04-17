# Output Format

## Top-level structure

```json
{
  "plan": "integrated|split",
  "workflow_id": "wf__co_0024_현대카드__r018__카드상품기획__상품기획팀-plcc팀",
  "workflow_name": "현대카드 상품기획팀/PLCC팀 통합 업무 워크플로우",
  "role_id": "co_0024_현대카드__r018__카드상품기획__상품기획팀-plcc팀",
  "tasks": [...],
  "edges": [...],
  "stages": [...],
  "n_tasks": 27,
  "n_edges": 30,
  "max_out": 5,
  "max_in": 3,
  "n_streams": 3,
  "has_div": true,
  "has_conv": true,
  "self_critique": "..."
}
```

## Task-level fields

```json
{
  "task_id": "td__...",
  "task_order": 1,
  "stream_label": "시장조사",
  "is_entry_point": true,
  "is_exit_point": false
}
```

## Edge-level fields

```json
{
  "from_task_id": "td__...004__001",
  "to_task_id": "td__...003__001",
  "evidence_status": "evidence-based",
  "note": "소비 트렌드 분석 보고서 → 혜택 구조 설계 input으로 직접 참조"
}
```

- `evidence_status` ∈ {"evidence-based", "inferred"}
- `note`: always required for inferred; optional but recommended for evidence-based

## Stage-level fields

```json
{
  "stage_id": "st__wf__...P1",
  "stage_order": 1,
  "stage_name": "시장 조사 및 트렌드 분석",
  "stage_slug": "market-research",
  "task_ids": ["td__...004__001", "td__...018__001", "td__...002__001"]
}
```

## DAG metrics

| Metric | Definition |
|--------|-----------|
| `n_tasks` | Total tasks in workflow |
| `n_edges` | Total edges |
| `max_out` | Largest out-degree (max divergence) |
| `max_in` | Largest in-degree (max convergence) |
| `n_streams` | Number of parallel streams |
| `has_div` | `true` if `max_out >= 2` |
| `has_conv` | `true` if `max_in >= 2` |

## self_critique

A brief (2-4 sentence) self-assessment:
- Are there any tasks with 0 edges that should be connected?
- Are there any suspicious inferred links that might be wrong?
- Is the workflow truly unified or should it be split?
- Any missing evidence that would strengthen the DAG?
