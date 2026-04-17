---
name: company-role-task-research
description: "Research action-level tasks (15-20) for a specific company and role using web search. Use when: (1) user provides a company name AND a role/job title and wants to know what that role actually does, (2) user says '직무 리서치', '직무 과업 조사', 'task research', 'role research', '이 회사의 이 직무가 무슨 일을 하는지 조사', '회사명+직무명으로 task 조사'. Do NOT use for: general company analysis without a role, generic role descriptions without a company, DB/pipeline/ETL work, AX task generation, or implementation planning."
---

# Company Role Task Research

Research real responsibilities and recurring work for a specific role at a specific company.

## When to use

- User provides **company name + role name** and wants task-level research
- Phrases: "직무 리서치", "직무 과업 조사", "task research", "이 직무가 뭘 하는지 조사해줘"

## When NOT to use

- Company analysis without a role → use `company-ai-research`
- Role description without a company → just answer directly
- DB writes, pipeline stages, ETL → not this skill
- AX task generation → use `stage14_v2_ax_generator`

## Workflow

1. **Parse input**: Extract company name and role name
2. **Web search**: Use WebSearch/WebFetch with source priority (see [source-priority.md](references/source-priority.md))
3. **Extract tasks**: Apply extraction rules (see [task-extraction-rules.md](references/task-extraction-rules.md))
4. **Produce output**: Structured result with 15-20 tasks (see [output-format.md](references/output-format.md))

## Source priority (summary)

| Tier | Source | Trust |
|------|--------|-------|
| A | Company official JD/careers | Highest |
| B | Same-company IR/product/service pages | High |
| C | Same-industry peer company JDs | Medium |
| D | Industry reports, job wikis | Low |
| E | General knowledge inference | Lowest |

Search strategy: `"{company} {role} 채용"` → `"{company} careers"` → peer JDs → industry articles.

## Task extraction (summary)

- **15-20 tasks** target (minimum 10)
- Action-level: "~한다", "~를 수행한다" (verb-ending)
- Concrete recurring work, not abstract competencies
- Company-specific and role-specific
- No vague consulting language ("다양한 업무를 수행", "전략적 역할 담당")

## Output contract

```json
{
  "company": "현대카드",
  "role": "상품기획팀 / PLCC팀",
  "summary": "2-3 sentence research summary",
  "evidence_quality": "strong|moderate|weak",
  "tasks": [
    {
      "task_text": "action-level task (~한다)",
      "source_tier": "A",
      "confidence": 90,
      "source_note": "현대카드 공식 채용공고"
    }
  ],
  "sources": [
    {
      "url": "https://...",
      "title": "Source title",
      "source_type": "company_jd",
      "source_tier": "A"
    }
  ]
}
```

## Reference files

- **[scope.md](references/scope.md)**: What this skill does / does not do, trigger examples
- **[source-priority.md](references/source-priority.md)**: Source ranking, search strategy, fallback rules
- **[task-extraction-rules.md](references/task-extraction-rules.md)**: How to extract, merge, deduplicate tasks
- **[output-format.md](references/output-format.md)**: Exact output shape, field requirements, good/bad examples
- **[examples.md](references/examples.md)**: 3 compact worked examples
