# Output Format

## Required fields per classified task

```json
{
  "task_id": "td__{atomic_task_id}",
  "atomic_task_id": "at__rrt__co_0024_현대카드__r018__...__001",
  "task_name": "atomic_text from Stage 3",
  "phase": "P2",
  "primitive_lv1": "DECIDE",
  "primitive_lv2": "Rank",
  "domain_lv1": "Financial",
  "domain_lv2": "RevenueMargin",
  "mechanism_lv1": "M2",
  "mechanism_lv2": "Interpret",
  "full_code": "Financial(RevenueMargin).DECIDE[Rank]::M2(Interpret)",
  "secondary_mechanism_lv1": null,
  "secondary_mechanism_lv2": null,
  "dna_confidence": 85,
  "rationale": "brief explanation of classification choices",
  "review_flags": []
}
```

## Field rules

- **task_id**: `td__` + atomic_task_id (replace `at__` prefix with `td__`)
- **task_name**: Copy atomic_text verbatim from Stage 3
- **phase, primitive_lv1**: Copy from Stage 3 — NEVER change
- **primitive_lv2**: Must be a valid child of primitive_lv1 (see primitive-lv2.md)
- **domain_lv1**: One of: Digital, Financial, Human, Institutional, Relational, Physical
- **domain_lv2**: Must be a valid child of domain_lv1 (see domain-lv2.md)
- **mechanism_lv1**: One of: M1, M2, M3, M4
- **mechanism_lv2**: Must be a valid child of mechanism_lv1 (see mechanism-lv2.md)
- **full_code**: `Domain(LV2).Primitive[P-LV2]::M#(M-LV2)`
- **secondary_mechanism**: null if not needed. Only set when task genuinely spans two mechanism types.
- **dna_confidence**: 1-100 integer
- **rationale**: Brief explanation (1-2 sentences)
- **review_flags**: JSON array, empty `[]` when clean

## Wrapper format

```json
{
  "role_id": "co_0024_현대카드__r018__...",
  "company": "현대카드",
  "role": "상품기획팀 / PLCC팀",
  "total_tasks": 27,
  "tasks": [ ... ]
}
```
