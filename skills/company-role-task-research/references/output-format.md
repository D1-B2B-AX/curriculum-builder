# Output Format

## Required fields

```json
{
  "company": "string — company name",
  "role": "string — role/team name",
  "summary": "string — 2-3 sentence research summary",
  "evidence_quality": "strong | moderate | weak",
  "tasks": [
    {
      "task_text": "action-level task description (~한다)",
      "source_tier": "A|B|C|D|E",
      "confidence": 90,
      "source_note": "where this task came from"
    }
  ],
  "sources": [
    {
      "url": "https://...",
      "title": "Page title",
      "source_type": "company_jd|company_ir|company_service|peer_jd|industry_report|knowledge",
      "source_tier": "A|B|C|D|E"
    }
  ]
}
```

## evidence_quality rules

- **strong**: 3+ Tier A/B sources, 15+ tasks from official evidence
- **moderate**: 1-2 Tier A/B sources, or primarily Tier C
- **weak**: Only Tier D/E, heavy inference

## Task list rules

- 15-20 tasks (min 10, max 25)
- Each task has source_tier and confidence (1-100)
- Tasks sorted by confidence descending
- Mark inferred tasks explicitly: source_tier="E", source_note="추정"

## Summary rules

- 2-3 sentences
- What sources were found
- How many tasks extracted
- Notable findings or gaps

## Good output example

```json
{
  "company": "현대카드",
  "role": "상품기획팀 / PLCC팀",
  "summary": "현대카드 공식 채용공고 2건과 IR 보고서에서 18개 과업을 추출. PLCC 파트너십 관리와 카드 상품 기획이 핵심 업무.",
  "evidence_quality": "strong",
  "tasks": [
    {"task_text": "카드 상품별(M/X/Zero 등) 기획·마케팅·운영 및 Performance를 관리한다", "source_tier": "A", "confidence": 95, "source_note": "현대카드 채용공고"},
    {"task_text": "PLCC 신규 Deal을 발굴·제안하고 파트너사와의 사업 전략을 수립한다", "source_tier": "A", "confidence": 95, "source_note": "현대카드 채용공고"}
  ]
}
```

## Bad output example

```json
{
  "tasks": [
    {"task_text": "다양한 업무를 수행합니다"},
    {"task_text": "전략적 사고를 바탕으로 성장합니다"}
  ]
}
```

Why bad: vague, not action-level, no source info, missing required fields.
