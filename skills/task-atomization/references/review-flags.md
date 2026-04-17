# Review Flags

## Flag definitions

| Flag | When to add | Example |
|------|------------|---------|
| `low_specificity` | Task text too vague to reliably classify phase/primitive | "다양한 업무를 수행한다" |
| `phase_boundary` | Task could reasonably belong to 2+ phases | "데이터를 분석한다" (SENSE or DECIDE?) |
| `split_uncertain` | Split/no-split decision is ambiguous | "설계하고 관리한다" (one flow or two?) |
| `oversplit` | May have been over-decomposed; consider merging back | 4+ atomic tasks from 1 raw task |

## Rules

- `review_flags` is a JSON array: `[]` when no flags, `["low_specificity"]` when flagged
- Multiple flags allowed: `["phase_boundary", "split_uncertain"]`
- Flags are informational — they don't block processing
- When `phase_boundary` is set, `phase_confidence` should be < 70
- When `split_uncertain` is set, `split_confidence` should be < 70
