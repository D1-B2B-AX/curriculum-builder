# Output Format

## Required fields per atomic task

```json
{
  "atomic_task_id": "at__{raw_role_task_id}__{index:03d}",
  "raw_role_task_id": "rrt__co_0024_현대카드__r018__카드상품기획__상품기획팀-plcc팀__001",
  "atomic_index": 1,
  "atomic_text": "[대상] [동사]하기",
  "phase": "P1|P2|P3|P4",
  "primitive_lv1": "SENSE|DECIDE|TRANSFORM|TRANSFER|COMMIT|ASSURE",
  "phase_confidence": 85,
  "split_confidence": 90,
  "parent_context": "original raw task text verbatim",
  "split_reason": "reason for split, or 'no_split' if kept as one",
  "semantic_bucket_hint": "Digital|Financial|Human|Institutional|Relational|Physical",
  "rationale": "brief explanation of phase/primitive choice",
  "review_flags": []
}
```

## Field rules

- **atomic_text**: Must be `[대상] [동사]하기` format. Clean, self-explanatory.
- **phase_confidence**: 1-100 integer. How certain the phase assignment is.
- **split_confidence**: 1-100 integer. How certain the split/no-split decision is.
- **parent_context**: Copy of the original raw_task_text. Never modify.
- **split_reason**: `"no_split"` if kept as one. Otherwise explain what differs.
- **semantic_bucket_hint**: One of exactly 6 values:
  - `Digital` — IT, data, software, digital content
  - `Financial` — finance, accounting, payments, credit
  - `Human` — HR, people, organization, capacity
  - `Institutional` — legal, compliance, contracts, governance
  - `Relational` — sales, customers, partnerships, marketing
  - `Physical` — logistics, manufacturing, facilities

## Wrapper format

```json
{
  "role_id": "co_0024_현대카드__r018__...",
  "company": "현대카드",
  "role": "상품기획팀 / PLCC팀",
  "total_raw_tasks": 18,
  "total_atomic_tasks": 22,
  "atomic_tasks": [ ... ]
}
```
