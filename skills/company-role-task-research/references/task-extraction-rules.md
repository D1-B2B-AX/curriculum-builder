# Task Extraction Rules

## Target count

- **15-20 tasks** (ideal)
- Minimum 10, maximum 25
- If fewer than 10 achievable, mark evidence_quality as "weak"

## Action-level requirement

Every task must be action-level — describing a concrete, recurring action:

Good: "카드 상품별 기획·마케팅·운영 및 Performance를 관리한다"
Good: "파트너사 결제 데이터를 분석하여 PLCC 상품의 혜택 구조를 설계한다"
Bad: "다양한 업무를 수행합니다" (too vague)
Bad: "열정적으로 성장합니다" (not a task)
Bad: "전략적 역할 담당" (abstract competency label)

## Verb endings

- Korean: "~한다", "~를 수행한다", "~를 관리한다", "~를 분석한다"
- Must describe what the person repeatedly does, not what they are

## What to extract

- Concrete recurring responsibilities
- Measurable or observable actions
- Company-specific and role-specific details
- Domain terminology from the actual JD/source

## What to avoid

- Vague capability statements ("리더십 발휘")
- HR recruiting language ("열정적인 인재")
- Generic descriptions that apply to any role
- Duplicate tasks with slightly different wording

## Merge rules

- Same action with different wording → merge into one task
- Related sub-tasks → keep separate if they represent distinct work
- Overlapping tasks from different sources → keep the more specific version

## Split rules

- "A 및 B를 수행한다" where A and B are genuinely different actions → split
- "A를 포함한 B" where A is a sub-task of B → keep as one

## Deduplication

- Exact duplicate → remove
- Semantic duplicate (same meaning, different words) → keep the more specific version
- Near-duplicate from different sources → keep the one from the higher-tier source

## Normalization

- Consistent verb ending ("~한다" form)
- Remove company recruiting preamble ("저희 팀은...", "함께할 분은...")
- Preserve domain-specific terms (PLCC, GPCC, FDS, etc.)
- Keep enough context for the task to be self-explanatory
