# Scope

## What this skill does

- Take a company name and a role name as input
- Perform web research to find what that role actually does at that company
- Extract 15-20 action-level tasks describing concrete recurring work
- Organize sources by quality tier (A-E)
- Produce a structured, reusable output

## What this skill does NOT do

- General company analysis (use company-ai-research)
- Financial analysis (use company-financial-research)
- DB writes or pipeline processing
- AX task generation or level assignment
- Downstream ETL, atomization, or stage recompute
- Generic role descriptions without a company

## Trigger examples

| Input | Triggers? |
|-------|-----------|
| "현대카드 데이터/AI 직무 task 리서치해줘" | Yes |
| "삼성SDS HR 직무가 실제로 하는 일을 조사해줘" | Yes |
| "KB국민은행의 IT기획 직무 과업을 조사해줘" | Yes |
| "이 회사의 이 직무가 무슨 일을 하는지 조사" | Yes |
| "현대카드 분석해줘" (no role) | No — company analysis |
| "HR이 뭐하는 직무야?" (no company) | No — generic role |
| "Stage 14 AX task 생성해줘" | No — pipeline work |
| "task_dna 테이블 업데이트해줘" | No — DB work |
