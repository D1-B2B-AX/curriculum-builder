# Stage 4 Operational Rules

## Anchor rule (CRITICAL)

- `phase` → IMMUTABLE. Set in Stage 3. Never change.
- `primitive_lv1` → IMMUTABLE. Set in Stage 3. Never change.
- If classification suggests a different phase/primitive_lv1, add `anchor_violation` flag but do NOT change the anchor values.

## Allowed-value discipline

- `primitive_lv2` must come from [primitive-lv2.md](primitive-lv2.md)
- `domain_lv1` ∈ {Digital, Financial, Human, Institutional, Relational, Physical}
- `domain_lv2` must come from [domain-lv2.md](domain-lv2.md)
- `mechanism_lv1` ∈ {M1, M2, M3, M4}
- `mechanism_lv2` must come from [mechanism-lv2.md](mechanism-lv2.md)
- Do NOT invent new LV2 values.

## semantic_bucket_hint usage

- If Stage 3 provided `semantic_bucket_hint`, use it as a starting signal for `domain_lv1`.
- It is a hint, not a binding constraint. Override if evidence points elsewhere.

## Mechanism inference defaults

| Primitive_lv1 | Default mechanism_lv1 | When |
|--------------|----------------------|------|
| SENSE | M2 (Content) | Most information gathering |
| DECIDE | M2 (Content) | Most analytical judgment |
| TRANSFORM | M2 (Content) | Content production |
| TRANSFORM | M3 (Physical) | Physical/logistical production |
| TRANSFER | M3 (Physical) | Distribution/delivery |
| TRANSFER | M2 (Content) | Information sharing |
| COMMIT | M4 (Social) | Authorization/approval |
| ASSURE | M4 (Social) | Compliance/quality check |

These are defaults. Override with evidence from the task context.

## full_code format

```
Domain(LV2).Primitive[P-LV2]::M#(M-LV2)
```

Examples:
- `Financial(RevenueMargin).DECIDE[Rank]::M2(Interpret)`
- `Relational(AccountsCustomers).SENSE[DiscoverAndCaptureExternal]::M2(Generate)`
- `Digital(ContentDocs).TRANSFORM[Generate]::M2(Generate)`

## Classification workflow

1. Read atomic task text + parent_context
2. Preserve anchors: phase, primitive_lv1
3. Choose primitive_lv2 (read primitive-lv2.md, match to primitive_lv1)
4. Choose domain_lv1 → domain_lv2 (read domain-lv2.md, use semantic_bucket_hint)
5. Infer mechanism_lv1 → mechanism_lv2 (read mechanism-lv2.md, use defaults above)
6. If task spans two mechanisms, assign secondary_mechanism
7. Generate full_code
8. Set dna_confidence (1-100)
9. Write rationale
10. Add review_flags if needed

## Review flags

| Flag | When |
|------|------|
| `ontology_boundary` | Task sits at boundary of two domains or primitive_lv2 values |
| `mechanism_mismatch` | Chosen mechanism doesn't align naturally with the primitive |
| `anchor_violation` | Evidence suggests different phase/primitive_lv1 than Stage 3 assigned |
