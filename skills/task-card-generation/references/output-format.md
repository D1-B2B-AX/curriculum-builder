# Output Format

## Per-task card

```json
{
  "task_id": "td__at__rrt__co_0024_...__001__001",
  "one_liner": "what/how/value in one sentence",
  "trigger_text": "concrete event or [inferred] event",
  "inputs": [
    {"seq": 1, "input_text": "practical artifact or data source"},
    {"seq": 2, "input_text": "another input if needed"}
  ],
  "action_text": "PrimitiveLv2: concrete operational description",
  "immediate_output": "concrete handoffable artifact",
  "actor": "role or sub-team name",
  "cadence": "frequency",
  "card_confidence": 85,
  "assumption_note": "what was assumed, or null",
  "evidence_note": "what evidence supports this, or null"
}
```

## Field constraints

- **task_id**: Preserved from input. NEVER change.
- **inputs**: Array of `{seq, input_text}`. Usually 1-3 items. Minimum 1.
- **action_text**: Must start with `primitive_lv2:` prefix.
- **immediate_output**: Must be a concrete artifact, not an activity.
- **card_confidence**: 1-100 integer.
- **trigger_text**: If inferred, must start with `[inferred]`.

## Wrapper format

```json
{
  "role_id": "co_0024_현대카드__r018__...",
  "company": "현대카드",
  "role": "상품기획팀 / PLCC팀",
  "total_cards": 27,
  "task_cards": [ ... ]
}
```
