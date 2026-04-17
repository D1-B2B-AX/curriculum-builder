# Phase and Primitive Rules

## Allowed values

**phase** ∈ {P1, P2, P3, P4}
**primitive_lv1** ∈ {SENSE, DECIDE, TRANSFORM, TRANSFER, COMMIT, ASSURE}

## Phase-Primitive mapping

| Phase | Name | primitive_lv1 | 대표 행위 |
|-------|------|--------------|----------|
| P1 | Discover | SENSE | 조사, 수집, 탐색, 모니터링, 리서치 |
| P2 | Design | DECIDE | 판단, 평가, 분석→의사결정, 기준 수립, 우선순위 결정 |
| P3 | Deliver | TRANSFORM | 생산, 변환, 생성, 개발, 제작 |
| P3 | Deliver | TRANSFER | 전달, 배포, 공유, 보고, 발송 |
| P3 | Deliver | COMMIT | 승인, 확정, 계약, 체결, 집행 |
| P4 | Deploy | ASSURE | 검증, 품질관리, 준수 확인, 사후 모니터링 |

## Constraint

- P1 → only SENSE
- P2 → only DECIDE
- P3 → TRANSFORM or TRANSFER or COMMIT
- P4 → only ASSURE

If phase=P1 but primitive_lv1≠SENSE → invalid. Fix the phase or primitive.

## Classification examples

| Task | Phase | Primitive | Why |
|------|-------|-----------|-----|
| 경쟁사 동향을 조사한다 | P1 | SENSE | 정보 수집 |
| 고객 데이터를 분석하여 세그먼트를 결정한다 | P2 | DECIDE | 분석→판단 |
| 제안서 초안을 작성한다 | P3 | TRANSFORM | 문서 생산 |
| 보고서를 경영진에게 보고한다 | P3 | TRANSFER | 전달 행위 |
| 계약을 체결한다 | P3 | COMMIT | 확정 행위 |
| 출시 후 시장 반응을 모니터링한다 | P4 | ASSURE | 사후 검증 |

## Bad classification examples

| Task | Wrong | Right | Why wrong |
|------|-------|-------|-----------|
| 시장을 조사한다 | P3/TRANSFORM | P1/SENSE | 조사는 수집, 생산 아님 |
| 전략을 수립한다 | P1/SENSE | P2/DECIDE | 전략 수립은 의사결정 |
| 품질을 검수한다 | P3/TRANSFORM | P4/ASSURE | 검수는 검증 행위 |

## Edge cases

- "분석한다" → context-dependent
  - "데이터를 분석한다" (수집 목적) → P1/SENSE
  - "데이터를 분석하여 판단한다" (의사결정) → P2/DECIDE
  - "분석 보고서를 작성한다" (생산) → P3/TRANSFORM
- "관리한다" → usually P4/ASSURE (ongoing oversight), but context matters
- "기획한다" → usually P2/DECIDE (planning = decision-making)
