# Source Priority

## Tier ranking

| Tier | Source type | Trust | Example |
|------|------------|-------|---------|
| A | Company official JD / careers page | Highest | 현대카드 채용공고 |
| B | Same-company non-JD (IR, product, service, news) | High | 현대카드 IR 보고서, 서비스 소개 페이지 |
| C | Same-industry peer company JD | Medium | 신한카드 동일 직무 채용공고 |
| D | Industry reports, job wikis, community posts | Low | 직무 분석 블로그, 커리어 사이트 |
| E | General knowledge inference (no source) | Lowest | LLM 사전학습 지식 기반 추정 |

## Search strategy (priority order)

1. `"{company} {role} 채용"` or `"{company} {role} JD"`
2. `"{company} careers"` or `"{company} 채용사이트"`
3. Same-industry peer company: `"{peer_company} {role} 채용"`
4. `"{role} 직무 분석"` or `"{role} 업무 내용"`

## Fallback rules

- If Tier A/B sources found → use primarily, supplement with C
- If only Tier C available → use peer JDs, mark evidence_quality as "moderate"
- If only Tier D/E available → mark evidence_quality as "weak", explicitly note inference
- Never fabricate sources — if no URL exists, set source_tier to E and source_note to "추정"

## Adjacent-company evidence rules

- Same industry + same role title = acceptable as Tier C
- Different industry + same role title = Tier D at best
- Always prefer same-company evidence over peer evidence
- When using peer evidence, note which company it came from
