# Task Card Fields

## Field definitions

### one_liner
- One sentence expressing what/how/value
- Reflects Domain + Primitive + Mechanism
- Good: "파트너사 결제 데이터를 분석하여 PLCC 혜택 구조의 수익성을 평가한다"
- Bad: "수익성 분석" (too short, no context)

### trigger_text
- The concrete event that initiates this task
- Must be specific and observable
- If inferred, prefix with `[inferred]`
- Good: "월간 결산 완료 시점", "PLCC 계약 만료 90일 전"
- Bad: "필요 시", "수시", "업무 발생 시"

### inputs
- Practical artifacts or information needed to perform the task
- Usually **1-3 items** (minimum 1)
- Do NOT inflate with filler items just to reach 3
- Each input: `{"seq": 1, "input_text": "월간 매출 원데이터"}`
- Can reference another same-role task's `immediate_output`
- Good: "CRM 고객 거래 이력", "전월 실적 리포트", "가격 정책 문서"
- Bad: "관련 자료", "필요 정보", "데이터" (too vague)

### action_text
- Must start with `primitive_lv2:` prefix
- Concrete operational description
- Good: "Generate: 매출 트렌드 분석 및 주요 지표 요약 리포트를 새로 작성한다"
- Bad: "매출을 관리한다" (no primitive prefix, vague)

### immediate_output
- A concrete, handoffable artifact
- Good: "PLCC 수익성 분석 보고서", "혜택 구조 설계안 (엑셀)", "파트너십 제안서 초안"
- Bad: "매출 관리", "수익성 분석", "상품 기획" (activities, not artifacts)

### actor
- Who performs this task
- Usually the role name or a specific sub-team
- Example: "상품기획팀 카드기획 담당자"

### cadence
- How often this task is performed
- Examples: "월 1회", "분기 1회", "수시 (이벤트 기반)", "연 1회"

### card_confidence
- 1-100 integer
- How confident the card content is
- 90+: directly from evidence
- 70-89: reasonable inference
- <70: significant assumption

### assumption_note
- What was assumed when writing this card
- null if no assumptions were made

### evidence_note
- What evidence supports this card's content
- null if purely inferred
