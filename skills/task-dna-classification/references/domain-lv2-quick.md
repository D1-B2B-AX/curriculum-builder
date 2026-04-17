# Domain-LV2 Quick Reference

핵심 질문: **"과업이 끝났을 때, 어떤 종류의 자산/상태가 바뀌었는가?"**

For boundary cases, read the full [domain-lv2.md](domain-lv2.md).

## PHYSICAL — 5종

| LV2 | 핵심 | 포함 | 헷갈림 |
|-----|------|------|--------|
| Inventory | 재고 품목 수량·상태·위치 | 입출고, 피킹, 사이클카운트 | 운송→Logistics |
| Equipment | 설비·장비 가동·보전 | 정비, 수리, 캘리브레이션 | 사용권 승인→Institutional |
| Facilities | 건물·공간 용량·배치·예약 | 공간 배정, 좌석 배치 | 예약 규칙→Institutional |
| Logistics | 운송·배송 경로·상태 | 배차, 라우팅, 배송 추적 | 소유권 이전→Institutional |
| SupplyNetwork | 공급망 계약·SLA·리드타임 | 발주, 납기 관리, 복수 소싱 | 단가 결정→Financial |

## DIGITAL — 5종

| LV2 | 핵심 | 포함 | 헷갈림 |
|-----|------|------|--------|
| RawData | 비가공 원천 데이터 | 로그, 이벤트, 센서값 | 집계→DerivedData |
| DerivedData | 집계·가공된 파생 데이터 | KPI 산출, 세그먼트, 예측값 | 해석→Interpret(M2) |
| ContentDocs | 문서·보고서·미디어 콘텐츠 | 보고서, 교안, 블로그, 영상 | 마케팅→Relational |
| SoftwareAutomation | 코드·시스템·자동화 파이프라인 | 앱 개발, API, RPA | 수동 SOP→Institutional |
| ModelArtifacts | ML 모델·가중치·실험 기록 | 학습 모델, 하이퍼파라미터 | 예측 결과→DerivedData |

## FINANCIAL — 5종

| LV2 | 핵심 | 포함 | 헷갈림 |
|-----|------|------|--------|
| BudgetForecast | 예산·비용·예측·손익 계획 | 예산 편성, P&L, 수익 예측 | 실제 정산→ClaimsObligations |
| PricingBilling | 가격·혜택·요금·청구 구조 | 가격 정책, 할인 설계, 인보이스 | 계약→Institutional |
| RevenueMargin | 매출·마진·수익성 실적 | 매출 분석, 마진 추적, ARPU | 예측→BudgetForecast |
| ClaimsObligations | 채권·채무·수수료·이자 | 미수금, 카드론, 수수료 수익 | 예산→BudgetForecast |
| TaxCompliance | 세무·관세·법적 공시 | 세금 신고, 관세 산정 | 감사→ASSURE |

## HUMAN — 5종

| LV2 | 핵심 | 포함 | 헷갈림 |
|-----|------|------|--------|
| CapabilitySkill | 역량·교육·자격 상태 | 교육 이수, 스킬 평가, 자격 | 채용→TalentPipeline |
| CapacityLoad | 인력 배치·워크로드 | 인력 배치, 초과근무, 스케줄링 | 급여→Financial |
| TalentPipeline | 채용·온보딩·퇴직 파이프라인 | 채용 공고, 면접, 온보딩 | 평가→CapabilitySkill |
| PerformanceEngagement | 성과 평가·동기·만족도 | 성과 리뷰, 1on1, eNPS | 교육→CapabilitySkill |
| SafetyWellbeing | 안전·건강·복지 | 산업안전, EAP, 건강검진 | 보험→Financial |

## INSTITUTIONAL — 5종

| LV2 | 핵심 | 포함 | 헷갈림 |
|-----|------|------|--------|
| Contracts | 계약·합의·SLA | 계약 체결, 갱신, 해지 | 가격→Financial |
| PoliciesStandards | 내부 정책·규정·SOP | 규정 제정, 가이드라인 | 법적 고시→GovernanceAuthority |
| GovernanceAuthority | 의사결정 권한·위임 | 승인 매트릭스, 권한 이양 | 결재→COMMIT |
| CertificationsLicenses | 인증·자격·라이선스 | ISO 인증, 사업자 등록 | 내부 자격→Human |
| RiskRegister | 리스크 관리·컴플라이언스 | 리스크 평가, 컴플라이언스 체크 | 감사→ASSURE |

## RELATIONAL — 5종

| LV2 | 핵심 | 포함 | 헷갈림 |
|-----|------|------|--------|
| AccountsCustomers | 고객 관계·상태·이력 | CRM, 고객 세그먼트, 이탈 관리 | 매출→Financial |
| LeadsPipeline | 리드·기회·영업 파이프라인 | 리드 발굴, 기회 관리, 파이프라인 | 계약→Institutional |
| PartnersChannels | 파트너·채널·제휴 관계 | 파트너 관리, 채널 전략, 제휴 | 계약→Institutional |
| AudienceAttention | 마케팅·도달·캠페인 | 캠페인, 광고, 콘텐츠 마케팅 | 콘텐츠 제작→Digital |
| PublicCommunity | 공개 시장·미디어·커뮤니티 | PR, 경쟁사 모니터링, 시장 동향 | 내부 보고서→Digital |
