# Scope

## What this skill does

- Take raw role-task descriptions as input
- Decide whether to split or keep each task (immediate-deliverable rule)
- Rewrite each result into clean `[대상] [동사]하기` format
- Assign phase (P1-P4) and primitive_lv1 (SENSE/DECIDE/TRANSFORM/TRANSFER/COMMIT/ASSURE)
- Add semantic_bucket_hint and review_flags
- Produce structured JSON output for downstream use

## What this skill does NOT do

- Stage 1 web research (use company-role-task-research)
- Stage 2 ETL / DB flattening
- Stage 4 DNA / ontology classification (domain_lv1, domain_lv2, mechanism)
- Workflow design or stage sequencing
- AX task generation
- DB writes or pipeline orchestration

## Trigger examples

| Input | Triggers? |
|-------|-----------|
| "이 raw task들을 atomic task로 원자화해줘" | Yes |
| "Stage 3 방식으로 쪼개줘" | Yes |
| "task들을 primitive 단위로 분해하고 phase 붙여줘" | Yes |
| "과업 원자화" | Yes |
| "현대카드 직무 리서치해줘" (no raw tasks) | No — Stage 1 |
| "task_dna 분류해줘" | No — Stage 4 |
| "워크플로 만들어줘" | No — Stage 6 |
| "AX task 생성해줘" | No — Stage 14 |
