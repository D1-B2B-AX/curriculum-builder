# Workflow Boundaries

## Entry points

A task is an entry point when:
- Its `trigger_text` originates from an **external source** (customer, external system, inbound event, upstream system signal, calendar event)
- It has **no incoming edges** from other tasks in the same role
- It starts a process chain

Examples of entry-point triggers:
- "파트너사 계약 만료 90일 전" (external calendar event)
- "[inferred] 연간 PLCC 사업 확장 계획 수립 시점" (organizational cycle)
- "매월 결산 마감 완료 시점" (upstream system signal)

## Exit points

A task is an exit point when:
- Its `immediate_output` achieves a **core business outcome**
- It has **no outgoing edges** to other tasks in the same role (or its output leaves the role)

Examples of exit-point outputs:
- "PLCC 파트너십 최종 계약서 (서명본)" — contract executed
- "프리미엄카드 월간 실적 보고서 (경영진 배포용)" — report delivered
- "카드 상품 시스템 개발 완료 보고서" — system delivered

## Workflow split rule

Split into separate workflows **only** when:
- No meaningful I/O linkage exists between two clusters of tasks
- The clusters serve genuinely different business processes
- Even a single shared input or output justifies keeping them unified

When in doubt: **keep unified**. One integrated workflow is preferred.
