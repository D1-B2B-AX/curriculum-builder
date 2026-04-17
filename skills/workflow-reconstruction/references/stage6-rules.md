# Stage 6 Rules

## Purpose

Stage 6 reconstructs a role-level business workflow from Task Cards. It is NOT isolated task sequencing — it is holistic workflow reconstruction that considers the entire role's task set as one design surface.

## Workflow integration principle

- Default to **one integrated workflow** whenever tasks can be connected
- Split into separate workflows **only** if there are two or more truly independent process clusters with no meaningful I/O links
- When in doubt, keep unified

## Cross-phase rule

- Cross-phase connections are **allowed and expected** when Input/Output evidence supports them
- Phase (P1/P2/P3/P4) is descriptive metadata, not a hard workflow boundary
- A P1 task's output can feed a P3 task's input — this is normal business flow
- Do NOT constrain analysis to phase-local connections only

## Evidence-only rule

- All edges must be grounded in Task Card Input/Output evidence
- No invented or unsupported edges
- Two types of evidence:
  - `evidence-based`: direct output→input text match
  - `inferred`: reasonable semantic match with explanatory note
- Inferred edges are allowed but must always include a `note` explaining the reasoning

## No-invention rule

- Do NOT invent new tasks that don't exist in the input
- Do NOT create edges that have no I/O basis
- If a connection seems logical but has no I/O evidence, mark it `inferred` with explanation
