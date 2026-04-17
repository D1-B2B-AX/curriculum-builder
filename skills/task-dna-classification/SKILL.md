---
name: task-dna-classification
description: "Classify atomic tasks into IVC DNA fields: primitive_lv2, domain_lv1/lv2, mechanism_lv1/lv2, and full_code. Preserves phase and primitive_lv1 as immutable anchors. Uses Primitive/Domain/Mechanism ontology lenses. Use when: (1) user asks to classify atomic tasks into DNA, (2) user says 'Stage 4', 'DNA classification', 'DNA 분류', 'primitive/domain/mechanism 분류', 'full_code 생성', (3) user wants ontology-based classification of already-atomized tasks. Do NOT use for: Stage 1 research, Stage 2 ETL, Stage 3 atomization, workflow design, AX task generation, or DB ingest."
---

# Task DNA Classification

Classify atomic tasks through three ontology lenses: Primitive, Domain, Mechanism.

## Core anchor rule

> **phase** and **primitive_lv1** are IMMUTABLE. Never change them. They were set in Stage 3.

## When to use

- "Stage 4", "DNA classification", "DNA 분류", "full_code 생성"
- After Stage 3 atomization is complete

## When NOT to use

- Stage 1-3 (research, ETL, atomization)
- Stage 5+ (task cards, workflows, AX tasks)
- DB writes or pipeline orchestration

## Classification workflow

1. Read atomic task (preserve `phase`, `primitive_lv1`)
2. Choose `primitive_lv2` → read [primitive-lv2-quick.md](references/primitive-lv2-quick.md)
3. Choose `domain_lv1` / `domain_lv2` → read [domain-lv2-quick.md](references/domain-lv2-quick.md)
4. Infer `mechanism_lv1` / `mechanism_lv2` → read [mechanism-lv2-quick.md](references/mechanism-lv2-quick.md)
5. Assign secondary mechanism if justified
6. Generate `full_code`: `Domain(LV2).Primitive[P-LV2]::M#(M-LV2)`
7. Add rationale and review flags if needed → read [stage4-rules.md](references/stage4-rules.md)

**Boundary cases only**: If the quick reference is insufficient for a specific boundary decision, read the full ontology file:
- [primitive-lv2.md](references/primitive-lv2.md) (full DoD, KPI, pitfalls)
- [domain-lv2.md](references/domain-lv2.md) (full state variables, confusion notes)
- [mechanism-lv2.md](references/mechanism-lv2.md) (full value logic, mappings)

## Output contract (summary)

```json
{
  "task_id": "td__...",
  "atomic_task_id": "at__...",
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
  "rationale": "...",
  "review_flags": []
}
```

See [output-format.md](references/output-format.md) for full spec.

## Review flags

- `ontology_boundary`: classification sits at boundary of two domains/primitives
- `mechanism_mismatch`: mechanism doesn't align naturally with primitive
- `anchor_violation`: attempted to change phase or primitive_lv1

## Reference files

**Default (read these first):**
- **[primitive-lv2-quick.md](references/primitive-lv2-quick.md)**: Compact Primitive LV2 table (name + definition + include/exclude)
- **[domain-lv2-quick.md](references/domain-lv2-quick.md)**: Compact Domain LV2 table (name + definition + include/exclude)
- **[mechanism-lv2-quick.md](references/mechanism-lv2-quick.md)**: Compact Mechanism LV2 table (name + definition + include/exclude)
- **[stage4-rules.md](references/stage4-rules.md)**: Operational rules, anchor rules, full_code format, flags
- **[output-format.md](references/output-format.md)**: Exact JSON schema
- **[examples.md](references/examples.md)**: 5 classification examples (good + bad)

**Deep reference (boundary cases only):**
- **[primitive-lv2.md](references/primitive-lv2.md)**: Full ontology with DoD, KPI, pitfalls, templates
- **[domain-lv2.md](references/domain-lv2.md)**: Full ontology with state variables, confusion notes
- **[mechanism-lv2.md](references/mechanism-lv2.md)**: Full ontology with value logic, primary/secondary mappings
