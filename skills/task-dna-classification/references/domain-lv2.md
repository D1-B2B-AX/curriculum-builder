# Domain-LV2 상세 레퍼런스

> Step ③ IVC DNA 정밀 분석 시 Domain-LV2 선택의 정의·경계·DoD를 제공한다.

핵심 질문: **"그 과업이 끝났을 때, 어떤 종류의 자산/상태가 바뀌었는가?"**

---

## B.1 PHYSICAL (물리 자산) — 5종

**핵심 질문:** "분자/물체/공간이 실제로 움직이거나, 상태·형태가 바뀌는가?"

### 1) Inventory (재고 품목: 원자재/반제품/완제품)

| 항목 | 내용 |
|------|------|
| **정의** | 개별 품목(LOT/시리얼 포함)의 수량·상태·위치를 다루는 자산군 |
| **포함** | 입고/출고/피킹/패킹/이동/사이클카운트/스크랩 |
| **제외** | 운송(경로/배송)은 Logistics, 소유권 이전은 Institutional(Contract/Settle) |
| **DoD** | 재고 트랜잭션 레코드(입·출고 기록), 재고 스냅샷 |
| **상태변수** | item_id, lot/serial, qty, uom, location_id, condition, owner, hold_flag, timestamp |
| **태스크** | (교) 실습 키트 피킹→패킹→출고 기록 / (범) 반제품 WIP 이동/사이클 카운트 |
| **KPI** | 재고정확도(%), 재고회전율, 재고차이액, 유휴/만성품 비율 |
| **헷갈림** | "송장 발행"은 Financial(PricingBilling), "운송장 생성/배송"은 Logistics/Transport |

### 2) Equipment (설비/장비/비품)

| 항목 | 내용 |
|------|------|
| **정의** | 가동 자산(프로젝터/음향/서버/차량)의 수명·가동·보전 상태 |
| **포함** | 설치, 예방보전, 고장수리, 캘리브레이션 |
| **제외** | 사용권 승인은 Institutional(GovernanceAuthority) |
| **DoD** | 자산 레코드 변경, 정비/수리 작업오더, 점검 로그 |
| **상태변수** | asset_id, model, serial, location, status, mtbf, mttr, last_maint, next_pm |
| **태스크** | (교) 프로젝터 램프 교체/밝기 캘리브레이션 / (범) 서버 팬 교체, UPS 점검 |
| **KPI** | 가동률(%), MTBF/MTTR, 정비 적시율, 다운타임 |
| **헷갈림** | "수리 승인권 부여"는 GovernanceAuthority, 실제 수리는 Physical.Transform/Repair |

### 3) Facilities (건물/강의실/스튜디오 등 공간)

| 항목 | 내용 |
|------|------|
| **정의** | 고정 공간의 용량·가용성·배치/예약 상태 |
| **포함** | 공간 배정, 좌석 배치, 유지관리 |
| **제외** | 예약 규칙 제정은 Institutional(PoliciesStandards) |
| **DoD** | 공간 예약 레코드, 배치도, 점검 로그 |
| **상태변수** | facility_id, capacity, layout, occupancy, schedule, restrictions |
| **태스크** | (교) 강의실 A 예약/좌석 배치도 업데이트 / (범) 회의실/스튜디오 블로킹 |
| **KPI** | 공간 활용률, 예약 충돌률, 설비민원 건수 |
| **헷갈림** | 단순 달력 이벤트 생성은 TRANSFER-Schedule이지만, 대상이 "공간 자산"이면 Physical에도 영향 |

### 4) ToolsConsumables (공구/소모품/보호구)

| 항목 | 내용 |
|------|------|
| **정의** | 저가·소모성·주로 재보충/분배가 핵심인 품목 |
| **포함** | 재고 보충, 사용량 기록, 안전재고 관리 |
| **제외** | 교육 자료 파일은 Digital(ContentDocs) |
| **DoD** | 출고/소진 레코드, 발주 요청 |
| **상태변수** | sku, qty_on_hand, usage_rate, min/max, reorder_point |
| **태스크** | (교) 마커/포스트잇 소진 기록 & 재주문 / (범) ESD 장갑/토너 재보충 |
| **KPI** | 품절률, 과다재고율, 재보충 리드타임 |
| **헷갈림** | 강사 USB의 안에 든 파일은 Digital |

### 5) LogisticsTopologyConditions (위치/경로/환경조건)

| 항목 | 내용 |
|------|------|
| **정의** | 노드(창고/교실), 링크(운송경로), 조건(온·습도/진동)의 물류 망과 상태 |
| **포함** | 경로 최적화, 지오펜스, 보관 조건 기록 |
| **제외** | 실제 돈 결제는 Financial(Liquidity/ClaimsObligations) |
| **DoD** | 운송 계획/경로 레코드, 환경 센싱 로그 |
| **상태변수** | node_id, lane_id, eta, temp/humidity, carrier, sla |
| **태스크** | (교) 키트 냉난방 조건 준수 모니터링 / (범) 배송 경로 ETA 최적화 |
| **KPI** | 제시간 도착률, 콜드체인 위반률, 총물류비 |
| **헷갈림** | 경로 데이터 모델링 자체는 Digital(DerivedData)이지만, 대상은 물리 흐름 |

> **Physical 경계 퀵룰:** 소유권/권리 문제면 Institutional, 데이터만 다루면 Digital.

---

## B.2 DIGITAL / INFORMATION (디지털·정보) — 6종

**핵심 질문:** "비트/콘텐츠/코드/모델 등 정보 그 자체가 바뀌는가?"

### 1) RawData (원시 데이터)

| 항목 | 내용 |
|------|------|
| **정의** | 처리 전 원시 데이터(로그/CSV/JSON/이미지 등) |
| **포함** | 이벤트 로그, 센서 캡처, 원본 설문 응답 |
| **제외** | 집계/피처/리포트는 DerivedData |
| **DoD** | 원시 테이블/파일(불변 저장) |
| **상태변수** | source, schema, ts, row_count, completeness |
| **태스크** | 스키마 등록, 수집 파이프라인 확인 |
| **KPI** | 신선도, 결측률, 스키마 드리프트 |
| **헷갈림** | CSV 내용이 재무 데이터여도, 파일 자체를 처리하는 과업이면 Digital(RawData) |

### 2) DerivedData (파생 데이터)

| 항목 | 내용 |
|------|------|
| **정의** | 집계/가공/피처/리포트 산출물 |
| **포함** | DAU, 전환율, 피처 테이블, 큐브 |
| **제외** | 문서/슬라이드 서술 콘텐츠는 ContentDocs |
| **DoD** | 파생 테이블/리포트(계보 포함) |
| **상태변수** | lineage, refresh_freq, last_build, metric_def |
| **태스크** | ETL/ELT, 메트릭 정의 관리 |
| **KPI** | 재빌드 성공률, 정의 일관성 |
| **헷갈림** | 재무비율 산출처럼 내용이 금융이어도, 행위가 집계/가공이면 Digital(DerivedData) |

### 3) ContentDocs (문서/미디어/콘텐츠)

| 항목 | 내용 |
|------|------|
| **정의** | 문서/미디어/슬라이드/이미지/오디오 등 표현물 |
| **포함** | 제안서, 커리큘럼 데크, 가이드 PDF, 동영상 |
| **제외** | 서명·공표되어 권리 발생 시 Institutional로 넘어감 |
| **DoD** | 파일(버전/소유자/링크) |
| **상태변수** | title, version, owner, template_id, approvals |
| **태스크** | 작성/윤문/버전관리/배포 |
| **KPI** | 제작시간, 재사용률, 리뷰턴어라운드 |
| **헷갈림** | 문서가 법적 효력을 발생시키면 Institutional(Contracts 등)으로 전환 |

### 4) SoftwareAutomation (소프트웨어/자동화)

| 항목 | 내용 |
|------|------|
| **정의** | 코드/스크립트/파이프라인/봇 |
| **포함** | 배치 잡, API, 노코드 플로우, IaC |
| **제외** | 배포 정책/권한은 Institutional(PoliciesStandards/IdentityAccess) |
| **DoD** | 리포지토리 커밋/릴리즈 아티팩트 |
| **상태변수** | repo, branch, version, tests, coverage, ci_status |
| **태스크** | 구현, 리팩토링, 테스트, 배포 |
| **KPI** | 빌드성공률, 배포빈도, MTTR |
| **헷갈림** | 배포 승인 정책은 Institutional, 실제 코드 변경은 Digital |

### 5) ModelsRules (모델/룰셋)

| 항목 | 내용 |
|------|------|
| **정의** | ML 모델, 룰셋, 프롬프트 템플릿 등 의사결정 엔진 |
| **포함** | 스코어카드, 추천모델, 프롬프트 체인 |
| **제외** | 룰의 정책 공표는 Institutional(PoliciesStandards) |
| **DoD** | 모델 바이너리/카드, 룰 파일, 성능리포트 |
| **상태변수** | metrics(auc, f1), drift, data_version, bias_checks |
| **태스크** | 학습, 검증, 배포, 모니터링 |
| **KPI** | 오차/정확도, 드리프트, 실사용 성과 |
| **헷갈림** | 모델 학습은 Digital, 모델 기반 정책 제정은 Institutional |

### 6) MetadataCatalog (메타데이터/카탈로그)

| 항목 | 내용 |
|------|------|
| **정의** | 데이터 사전, 계보, 품질지표, 접근정책 메타정보 |
| **포함** | 데이터 딕셔너리, 카탈로그, 태깅 |
| **제외** | 접근권 자체 부여는 Institutional(IdentityAccess) |
| **DoD** | 메타 레코드/카탈로그 페이지 |
| **상태변수** | owner, pii_flag, quality_score, retention, acl |
| **태스크** | 등록/태깅/정책 링크 |
| **KPI** | 카탈로그 커버리지, 메타 누락률, 검색 적중률 |
| **헷갈림** | 메타데이터 접근 권한 설정은 Institutional(IdentityAccess) |

> **Digital 경계 퀵룰:** 문서가 효력을 발생하면 Institutional(COMMIT).

---

## B.3 FINANCIAL (재무·현금흐름·청구권) — 6종

**핵심 질문:** "현금·채권·가격·예산·세무 등 돈과 약정이 바뀌는가?"

### 1) Liquidity (현금/예치/계좌)

| 항목 | 내용 |
|------|------|
| **정의** | 은행 잔액·현금성 자산 |
| **포함** | 계좌 생성, 잔액 조회/조정, 자금이체 |
| **제외** | 세금 신고는 Institutional(LicensesPermitsRegulatoryFilings) |
| **DoD** | 잔액 레코드, 입·출금 기록 |
| **상태변수** | account_id, balance, currency, available, hold |
| **태스크** | 자금집금, 출납, 은행조정 |
| **KPI** | 잔액 정확도, 일일 미조정 항목 |
| **헷갈림** | 실제 돈 이동(입금/환불)은 TRANSFER(Settle), 잔액 상태 관리는 Financial |

### 2) ClaimsObligations (채권/채무)

| 항목 | 내용 |
|------|------|
| **정의** | 받을돈(AR)/줄돈(AP)/대출 |
| **포함** | 청구, 수납 대기, 미지급 관리 |
| **제외** | 실제 수납/지급은 TRANSFER(Settle) |
| **DoD** | 채권/채무 레코드, aging 리포트 |
| **상태변수** | invoice_id, due_date, amount, status, aging_bucket |
| **태스크** | 미수금 회수, 지급 스케줄링 |
| **KPI** | DSO/DPO, 연체율 |
| **헷갈림** | 법인카드 사용 내역 CSV 처리는 Digital(RawData), 미지급금 관리 자체는 Financial |

### 3) PricingBilling (가격/청구)

| 항목 | 내용 |
|------|------|
| **정의** | 가격표/할인정책/인보이스 문서 |
| **포함** | 가격책정, 인보이스 생성·발송 |
| **제외** | 정책 공표는 Institutional(PoliciesStandards), 입금은 TRANSFER(Settle) |
| **DoD** | Pricebook, Invoice.pdf, 청구라인아이템 |
| **상태변수** | price_list, discount_rules, tax_rules, invoice_status |
| **태스크** | 견적/인보이스 발행, 할인 적용 |
| **KPI** | 청구정확도, 발행→수납 리드타임 |
| **헷갈림** | "송장 발행" = PricingBilling, "수납 처리" = TRANSFER(Settle) |

### 4) BudgetForecast (예산/전망)

| 항목 | 내용 |
|------|------|
| **정의** | 예산·계획·전망 |
| **포함** | 분기 예산 수립, 롤링 포캐스트 |
| **제외** | 예산 확정은 COMMIT(CommitResources) |
| **DoD** | 예산안/전망 시트 |
| **상태변수** | version, scenario, variance, assumption |
| **태스크** | 버전 관리, 편차 분석 |
| **KPI** | 예산-실적 편차, 예측 정확도 |
| **헷갈림** | 예산 "편성"은 Financial, 예산 "확정/승인"은 COMMIT |

### 5) PositionsInvestments (포지션/투자)

| 항목 | 내용 |
|------|------|
| **정의** | 지분/채권/파생/예치상품의 포지션 |
| **포함** | 매수/매도/배당/이자 |
| **제외** | 규제 신고는 Institutional(LicensesPermitsRegulatoryFilings) |
| **DoD** | 체결 레코드, 보유 현황 |
| **상태변수** | instrument, qty, cost, market_value, pnl |
| **태스크** | 리밸런싱, 평가손익 계산 |
| **KPI** | 수익률, VAR, 리밸런싱 규율 준수 |
| **헷갈림** | 투자 의사결정은 DECIDE, 포지션 상태 관리는 Financial |

### 6) TaxStatutory (세무/법정금)

| 항목 | 내용 |
|------|------|
| **정의** | 원천/부가세/공과금 등 법정금 |
| **포함** | 신고·납부·세액 계산 |
| **제외** | 신고서 제출 행위는 Institutional(LicensesPermitsRegulatoryFilings)와 겹치며, 돈 납부는 TRANSFER(Settle) |
| **DoD** | 세액 계산서, 신고서 초안/접수증 |
| **상태변수** | tax_type, base, rate, filing_period, status |
| **태스크** | 원천징수 정산, 부가세 신고 |
| **KPI** | 가산세 발생률, 신고 적시율 |
| **헷갈림** | 세액 "계산"은 Financial, 신고서 "제출"은 Institutional |

> **Financial 경계 퀵룰:** 돈 이동은 TRANSFER(Settle), 금액 약정/계약은 COMMIT(ExecuteContract).

---

## B.4 HUMAN (인적 역량·상태) — 6종

**핵심 질문:** "사람의 시간·역량·건강·역할·성과 상태가 바뀌는가?"

### 1) CapacityLoad (가용시간/배치/부하)

| 항목 | 내용 |
|------|------|
| **정의** | 가용시간·배치·휴가·근무 계획/실적 |
| **포함** | 스케줄링, 할당, 초과근무 기록 |
| **제외** | 캘린더 발송 자체는 TRANSFER |
| **DoD** | 배치/스케줄 레코드 |
| **상태변수** | person_id, availability, allocation, timeoff |
| **태스크** | 프로젝트 가용성 배정, 휴가 승인, 온보딩 배치 |
| **KPI** | 활용률, 과부하 지수, 충돌률 |
| **헷갈림** | 온보딩(배치/할당)은 CapacityLoad, 온보딩 교육 이수 기록은 CapabilitySkill |

### 2) CapabilitySkill (역량/스킬)

| 항목 | 내용 |
|------|------|
| **정의** | 스킬·자격·학습 진척 |
| **포함** | 역량 매트릭스, 교육 이수 기록 |
| **제외** | 자격 **부여(증서 발급)**는 Institutional(LicensesPermitsRegulatoryFilings) |
| **DoD** | 스킬 프로파일/러닝 로그 |
| **상태변수** | skills, level, certifications, progress |
| **태스크** | 교육 계획, 스킬 갭 분석 |
| **KPI** | 스킬 커버리지, 러닝 진척율 |
| **헷갈림** | 교육 "수료증 발급"은 Institutional, 교육 "이수 기록"은 Human |

### 3) EngagementMotivation (몰입/동기)

| 항목 | 내용 |
|------|------|
| **정의** | 만족/몰입/보상 체감 |
| **포함** | eNPS, 참여율, 감정 스냅샷 |
| **제외** | 보상 정책 변경은 Institutional(PoliciesStandards) |
| **DoD** | 설문/지표 레코드 |
| **상태변수** | eNPS, participation, feedback_tags |
| **태스크** | 설문 설계·분석, 액션 플랜 |
| **KPI** | 응답률, eNPS 점수 추이 |
| **헷갈림** | 설문 "설계"는 DECIDE, 설문 "응답 수집"은 SENSE, 결과 "분석"은 TRANSFORM |

### 4) WellbeingSafety (건강/안전)

| 항목 | 내용 |
|------|------|
| **정의** | 건강/안전/피로/스트레스 등 리스크 |
| **포함** | 안전교육 이수, 사고 보고, 건강지표 |
| **제외** | 의료 정보 민감 처리 규정은 Institutional(PoliciesStandards) |
| **DoD** | 사건/점검 로그, 컴플라이언스 체크 |
| **상태변수** | incident_rate, fatigue_score, ppe_usage |
| **태스크** | 사고 예방 캠페인, 리스크 평가 |
| **KPI** | 사고율, 휴업일수, 교육 이수율 |
| **헷갈림** | 안전 "규정 제정"은 Institutional, 안전 "상태 모니터링"은 Human |

### 5) RoleSeniority (역할/직급)

| 항목 | 내용 |
|------|------|
| **정의** | 직무·직급·권한 범위 상태 |
| **포함** | 직무 정의, 롤 매핑 |
| **제외** | 권한 부여 행위는 COMMIT(GrantAuthorization) |
| **DoD** | 역할 프로파일/조직도 |
| **상태변수** | role, grade, scope, delegation |
| **태스크** | 역할 설계, 직무기술서 관리 |
| **KPI** | 역할-권한 정합성, 승인 계층 적합도 |
| **헷갈림** | 권한을 실제로 부여/회수하면 COMMIT(GrantAuthorization), 그 보유 상태는 Human(RoleSeniority) |

### 6) Performance (성과)

| 항목 | 내용 |
|------|------|
| **정의** | 목표 대비 실적/품질/성장률 |
| **포함** | OKR/KPI, 리뷰, 보정 |
| **제외** | 인사 정책 변경은 Institutional(PoliciesStandards) |
| **DoD** | 평가서/지표 리포트 |
| **상태변수** | objective, key_results, rating, trend |
| **태스크** | 목표 설정·리뷰, 1:1 코칭 |
| **KPI** | 목표 달성률, 성장률, 분포 공정성 |
| **헷갈림** | 성과 "측정"은 Human, 성과 "정책 변경"은 Institutional |

> **Human 경계 퀵룰:** 권한을 실제로 부여/회수하면 COMMIT(GrantAuthorization), 그 보유 상태는 Human(RoleSeniority).

---

## B.5 RELATIONAL (대외 관계/시장 주의) — 6종

**핵심 질문:** "회사 밖 사람/조직과의 관계 상태가 바뀌는가?"

### 1) AudienceAttention (잠재고객/주의)

| 항목 | 내용 |
|------|------|
| **정의** | 트래픽/구독/도달/노출 |
| **포함** | 웹/SNS 방문·팔로워·구독자 |
| **제외** | 콘텐츠 파일 자체는 Digital(ContentDocs) |
| **DoD** | 채널 지표 레코드/대시보드 |
| **상태변수** | reach, impressions, subs, churn |
| **태스크** | 캠페인 계획/집행/측정 |
| **KPI** | 도달/조회/CTR, 구독 순증 |
| **헷갈림** | 광고 소재 제작은 Digital(ContentDocs), 소재의 도달/반응은 Relational |

### 2) LeadsPipeline (리드/파이프라인)

| 항목 | 내용 |
|------|------|
| **정의** | 리드/기회/제안 진척 상태 |
| **포함** | MQL/SQL, 기회 단계, 제안·협상 |
| **제외** | 계약 체결은 Institutional(Contracts) |
| **DoD** | 파이프라인 레코드(스테이지/금액/확률) |
| **상태변수** | stage, owner, amount, close_prob, next_step |
| **태스크** | 리드 스코어링, 넥스트 액션 설정 |
| **KPI** | 스테이지 전환율, 사이클 타임, 승률 |
| **헷갈림** | 리드 "데이터 수집"은 SENSE, 리드 "관계 상태"는 Relational |

### 3) AccountsCustomers (고객 계정/관계)

| 항목 | 내용 |
|------|------|
| **정의** | 활성 고객 관계/구매력/유지 지표 |
| **포함** | 코호트, NRR/GRR, 헬스스코어 |
| **제외** | 채권/청구는 Financial(ClaimsObligations/PricingBilling) |
| **DoD** | 계정 헬스/계약 이력 레코드 |
| **상태변수** | arr, nrr, health, csat, tenure |
| **태스크** | 갱신/업셀/리텐션 플랜 |
| **KPI** | NRR, 이탈률, CSAT/NPS |
| **헷갈림** | 계약 갱신 "제안서 작성"은 Relational, 계약 "서명/체결"은 Institutional(Contracts) |

### 4) PartnersChannels (파트너/채널)

| 항목 | 내용 |
|------|------|
| **정의** | 리셀러/제휴/통합 파트너 관계 상태 |
| **포함** | 공동 세일즈, MDF, 통합 상태 |
| **제외** | 파트너십 계약은 Institutional(Contracts) |
| **DoD** | 파트너 계정/성과 레코드 |
| **상태변수** | tier, mdf, pipeline_shared, integration_status |
| **태스크** | 리드 교환, 공동 캠페인 |
| **KPI** | 파이프라인 기여, 파트너 NPS |
| **헷갈림** | 파트너십 "계약 체결"은 Institutional, 이후 "관계 상태"는 Relational |

### 5) SuppliersVendors (공급사/벤더)

| 항목 | 내용 |
|------|------|
| **정의** | 공급사 성과/가격/리스크 |
| **포함** | 납기/품질/가격지수, SLA 준수 |
| **제외** | PO/계약은 COMMIT, 지급은 TRANSFER(Settle) |
| **DoD** | 벤더 성과 레코드, 리스크 매트릭스 |
| **상태변수** | on_time, defect_rate, price_index, risk_score |
| **태스크** | 벤더 평가/개선요구 |
| **KPI** | 납기준수, 불량률, 코스트 변동 |
| **헷갈림** | 벤더 "평가"는 Relational, 벤더 "계약"은 Institutional |

### 6) PublicCommunity (대중/커뮤니티)

| 항목 | 내용 |
|------|------|
| **정의** | 대중/커뮤니티/미디어와의 평판·관계 |
| **포함** | 언론 노출, 커뮤니티 활동, 리뷰 |
| **제외** | 법적 공표 문서 효력은 Institutional |
| **DoD** | 언급/감성 레코드, PR 클리핑 |
| **상태변수** | mentions, sentiment, share_of_voice |
| **태스크** | 미디어 대응, 커뮤니티 운영 |
| **KPI** | 감성점수, SOV, 위기대응 리드타임 |
| **헷갈림** | PR 보도자료 "작성"은 Digital(ContentDocs), "배포 후 반응"은 Relational |

> **Relational 경계 퀵룰:** 파트너십 계약은 COMMIT(ExecuteContract), 이후 관계 상태는 Relational(PartnersChannels).

---

## B.6 INSTITUTIONAL (제도·권리·규범) — 6종

**핵심 질문:** "법·제도적 권리/의무/자격/권한/거버넌스가 바뀌는가?"

### 1) Contracts (계약)

| 항목 | 내용 |
|------|------|
| **정의** | 상거래/용역/라이선스 계약서 및 부속 |
| **포함** | 서명본 관리, 갱신/해지 |
| **제외** | 초안 작성은 Digital(ContentDocs), 발송은 TRANSFER |
| **DoD** | 서명본/계약 레코드(유효기간/금액/조건) |
| **상태변수** | counterparty, term, value, obligations, renew_date |
| **태스크** | 협상, 체결, 갱신/해지 관리 |
| **KPI** | 체결률, 소송/분쟁률, 갱신율 |
| **헷갈림** | 계약서 "초안 작성"은 Digital, "서명/체결"은 Institutional, "리스크 검토"는 ASSURE |

### 2) PoliciesStandards (정책/표준)

| 항목 | 내용 |
|------|------|
| **정의** | 내규/보안·품질 정책 공표물(효력 有) |
| **포함** | 할인/취소/보안/품질 표준 |
| **제외** | 룰 초안은 DECIDE(SpecifyRules) |
| **DoD** | 정책 문서(발효일·적용범위·버전) |
| **상태변수** | scope, effective_from, owner, exceptions |
| **태스크** | 제정/개정/공지/폐지 |
| **KPI** | 준수율, 예외 승인율, 위반 건수 |
| **헷갈림** | 정책 "초안 설계"는 DECIDE, 정책 "공표/시행"은 Institutional |

### 3) LicensesPermitsRegulatoryFilings (인허가/규제신고)

| 항목 | 내용 |
|------|------|
| **정의** | 정부 인허가/신고/인증 |
| **포함** | 허가증 취득/갱신, 신고 접수 |
| **제외** | 준비 문서 작성은 Digital/TRANSFORM, 수수료 납부는 TRANSFER(Settle) |
| **DoD** | 허가증/접수증, 규제 상태 레코드 |
| **상태변수** | license_id, scope, expiry, regulator, status |
| **태스크** | 신청, 보완 대응, 갱신 |
| **KPI** | 승인 리드타임, 보완요청률, 만료 미갱신 0건 |
| **헷갈림** | 자격증 "학습/준비"는 Human(CapabilitySkill), "발급"은 Institutional |

### 4) IPRights (지식재산/권리)

| 항목 | 내용 |
|------|------|
| **정의** | 특허/상표/저작권/데이터 권리/라이선스 |
| **포함** | 출원/등록/양도/라이선스 체결 |
| **제외** | 콘텐츠 파일은 Digital(ContentDocs) |
| **DoD** | 권리 증서/등록 레코드/라이선스 계약 |
| **상태변수** | right_type, jurisdiction, owner, term, scope |
| **태스크** | 출원·유지, 사용권 부여/회수 |
| **KPI** | 등록 성공률, 침해/분쟁 건수 |
| **헷갈림** | 콘텐츠 "제작"은 Digital, 콘텐츠 "저작권 등록"은 Institutional |

### 5) GovernanceAuthority (거버넌스/의결)

| 항목 | 내용 |
|------|------|
| **정의** | 이사회/위원회/위임전결/규정 |
| **포함** | 결의안, 권한 위임/회수 |
| **제외** | 개인 권한 부여는 IdentityAccess |
| **DoD** | 결의서/의사록/전결표 |
| **상태변수** | body, quorum, resolution, delegation_matrix |
| **태스크** | 안건 상정·의결, 규정 관리 |
| **KPI** | 의결 적시성, 준법성, 권한 충돌 0건 |
| **헷갈림** | 조직 "거버넌스 구조"는 Institutional, 개인의 "역할 상태"는 Human(RoleSeniority) |

### 6) IdentityAccess (IAM: 계정/접근권)

| 항목 | 내용 |
|------|------|
| **정의** | 계정/역할/접근권의 법적 효력 있는 부여/회수 |
| **포함** | 역할 기반 접근, 권한 승인/회수, SSO 통합 |
| **제외** | 직무/직급 상태 설명은 Human(RoleSeniority) |
| **DoD** | 권한 변경 로그(주체/범위/기한) |
| **상태변수** | identity, role, policy, grant_time, expiry |
| **태스크** | 권한 신청·심사·부여·회수 |
| **KPI** | 승인 시간, 권한 크리프, 접근 위반 0건 |
| **헷갈림** | 권한 "보유 상태"는 Human(RoleSeniority), 권한 "부여/회수 행위"는 Institutional |

> **Institutional 경계 퀵룰:** 문서가 법적 효력 없음 → Digital. 효력 발생 → Institutional.

---

## B.7 도메인 선택 진단 체크리스트

### 빠른 분류 질문

| 질문 | Domain |
|------|--------|
| 손에 잡히는 물건/공간이 바뀌나? | **Physical** |
| 파일/코드/데이터/모델 등 정보 그 자체가 바뀌나? | **Digital** |
| 현금/청구권/가격/예산/세무가 바뀌나? | **Financial** |
| 사람의 시간·역량·건강·역할·성과가 바뀌나? | **Human** |
| **외부**(고객/파트너/공급사/대중)와의 관계 상태가 바뀌나? | **Relational** |
| 계약/정책/권한/허가/지식재산/거버넌스 같은 법·제도적 효력이 바뀌나? | **Institutional** |

### 경계 퀵룰 (실무용)

| 상황 | 분류 |
|------|------|
| 문서/코드 만들기 | Digital.TRANSFORM → 그 문서로 권리 발생 → Institutional.COMMIT |
| 돈 실제 이동(입금/환불/청산) | Financial + TRANSFER(Settle) |
| 캘린더 초대/배송/배포/예약 | TRANSFER(M3), 대상이 공간 자산이면 Physical 상태도 갱신 |
| 검증/감사/모니터 | ASSURE(M4-StateAssurance), 수정은 TRANSFORM(Repair)로 분리 |
| 권한을 실제 부여/회수 | Institutional(IdentityAccess), 그 보유 상태는 Human(RoleSeniority) |
