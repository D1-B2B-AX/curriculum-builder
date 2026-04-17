# Examples

## Good example

```json
{
  "task_id": "td__at__rrt__...__010__001",
  "one_liner": "월간 매출 원데이터를 분석·종합하여 경영 의사결정용 리포트를 작성한다",
  "trigger_text": "월간 결산 완료 시점",
  "inputs": [
    {"seq": 1, "input_text": "월간 매출 원데이터"},
    {"seq": 2, "input_text": "KPI 목표값"},
    {"seq": 3, "input_text": "전월 리포트"}
  ],
  "action_text": "Generate: 매출 트렌드 분석 및 주요 지표 요약 리포트를 새로 작성한다",
  "immediate_output": "월간 매출 분석 리포트 (PDF/문서)",
  "actor": "상품기획팀 카드기획 담당자",
  "cadence": "월 1회",
  "card_confidence": 85,
  "assumption_note": "KPI 목표값은 경영기획부에서 제공된다고 가정",
  "evidence_note": "현대카드 채용공고에서 '매월 프리미엄카드 지표 관리' 언급"
}
```

**Why good**:
- trigger is concrete (월간 결산 완료)
- inputs are practical artifacts (3개, 모두 실질적)
- action starts with primitive_lv2 (Generate:)
- immediate_output is a handoffable artifact (PDF 리포트)
- confidence is reasonable (85)

## Bad example

```json
{
  "task_id": "td__...",
  "one_liner": "매출 관리",
  "trigger_text": "필요 시",
  "inputs": [],
  "action_text": "매출을 관리한다",
  "immediate_output": "매출 관리",
  "actor": "담당자",
  "cadence": "수시",
  "card_confidence": 50
}
```

**Why bad**:
- `trigger_text`: "필요 시" is forbidden generic trigger
- `inputs`: empty — minimum is 1
- `action_text`: no primitive_lv2 prefix, vague
- `immediate_output`: "매출 관리" is an activity, not an artifact
- `one_liner`: too short, no what/how/value
- `cadence`: "수시" is vague

## I/O linked example

```json
[
  {
    "task_id": "td__...004__001",
    "one_liner": "고객 소비 패턴·트렌드를 분석하여 상품 기획 인사이트를 도출한다",
    "trigger_text": "[inferred] 분기별 소비 데이터 업데이트 시점",
    "inputs": [
      {"seq": 1, "input_text": "카드 거래 데이터 (결제 시스템)"},
      {"seq": 2, "input_text": "시장 트렌드 리포트"}
    ],
    "action_text": "DiscoverAndCaptureExternal: 고객 세그먼트별 소비 패턴을 분석하고 트렌드를 도출한다",
    "immediate_output": "고객 소비 트렌드 분석 보고서"
  },
  {
    "task_id": "td__...004__002",
    "one_liner": "소비 트렌드 기반으로 신규 카드 혜택·서비스를 설계한다",
    "trigger_text": "고객 소비 트렌드 분석 완료 시점",
    "inputs": [
      {"seq": 1, "input_text": "고객 소비 트렌드 분석 보고서 (Task 004_001 산출물)"},
      {"seq": 2, "input_text": "기존 카드 혜택 현황 데이터"}
    ],
    "action_text": "Generate: 분석 결과 기반 신규 혜택 및 서비스 아이템을 설계한다",
    "immediate_output": "신규 카드 혜택·서비스 설계안"
  }
]
```

**Why good**: Task 004_002's input explicitly references Task 004_001's output.
