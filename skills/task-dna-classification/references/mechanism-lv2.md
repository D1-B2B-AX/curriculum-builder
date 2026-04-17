# Mechanism-LV2 상세 레퍼런스

> Step ③ IVC DNA 정밀 분석 시 Mechanism-LV2 선택의 정의·경계·DoD를 제공한다.
> LV2 이름은 CamelCase 관례를 따른다 (Primitive-LV2·Domain-LV2와 동일).

핵심 질문: **"이 과업의 핵심 가치가 M# 내에서 어떤 세부 메커니즘에 있는가?"**

| M# | LV2 | 종수 |
|----|------|------|
| M1 Form | Create, Combine, Modify, Decompose | 4종 |
| M2 Content | Generate, Structure, Interpret, Refine | 4종 |
| M3 Physical Coordinates | SpatialOptimize, TemporalOptimize | 2종 |
| M4 Social Coordinates | RightsAffirmation, StateAssurance | 2종 |
| **합계** | | **12종** |

---

## C.1 M1. Form — 형태/물리 실체 변환 (4종)

물건·장비·공간의 형태/상태를 바꿔 효용을 올린다.

**언제 Primary인가?**
- "손으로/공정으로 만들거나 고쳐서 가치가 난다"가 핵심일 때
- 품질·내구성·안전이 물리적 결과물로 바로 체감될 때
- 같은 문서를 보내도, 실물이 바뀌지 않으면 가치가 거의 0일 때

**경계/제외:**
- 돈 이동 → M3(TemporalOptimize, Settle)
- 권리/승인/자격 부여 → M4(RightsAffirmation)
- 정보만 바꾸는 작업(문서/데이터) → 보통 M2

**즉시 산출물(DoD):** 완성품/반제품, 조립·수리 로그, 검사표, 교정 기록

### 1) Create (무→유 생성)

| 항목 | 내용 |
|------|------|
| **정의** | 없던 물리 결과물을 새로 생성 (제작, 프린팅, 조형) |
| **포함** | 부품 제조, 3D 프린팅, 시제품 제작, 설치 시공 |
| **제외** | 디지털 파일 생성 → M2(Generate) |

### 2) Combine (조립/결합)

| 항목 | 내용 |
|------|------|
| **정의** | 여러 개를 조립/결합해 하나로 만듦 |
| **포함** | 부품 조립, 키트 패킹, 모듈 합본 |
| **제외** | 디지털 데이터 병합 → M2(Structure) |

### 3) Modify (수정/개선/세팅 변경)

| 항목 | 내용 |
|------|------|
| **정의** | 기존 물리 대상의 성능/상태를 개선하거나 세팅을 변경 |
| **포함** | 장비 수리/캘리브레이션, 리모델링, 부품 교체, 재세팅 |
| **제외** | 디지털 문서 수정 → M2(Refine) |

### 4) Decompose (분해/해체/재활용)

| 항목 | 내용 |
|------|------|
| **정의** | 물리 대상을 분해/해체하여 재구성하거나 재활용 |
| **포함** | 어셈블리 분해, 부품 회수, 재활용 분류 |
| **제외** | 디지털 파일 분할/추출 → M2(Structure) |

**M1 KPI & Value Gate:**
- Time: 생산/수리 리드타임↓
- Error: 불량/재작업률↓
- Risk: 안전사고/현장리스크↓
- 보조: Trust(일관된 품질)↑

**M1 흔한 함정:**
- 단순 "설정값 문서화"는 M2. 실제 기기 상태 변경이면 M1
- 수리 원인 분석(해석)은 M2/ASSURE, 고치는 행위만 M1

---

## C.2 M2. Content — 내용/정보 조성 (4종)

정보를 만들고·구조화하고·해석하고·다듬어 의사결정과 설득력을 높인다.

**언제 Primary인가?**
- 결과물의 핵심 가치가 '내용 그 자체'에 있을 때 (문서, 코드, 모델, 리포트)
- 의미/논리/스토리가 전환율·결정을 좌우할 때
- "보내는 타이밍(M3)보다 무엇을 쓰느냐가 더 중요"할 때

**경계/제외:**
- 문서로 법적 효력이 생기면 → M4(RightsAffirmation)
- 배포/캘린더/정산 타이밍이 핵심이면 → M3
- 물리 형태가 핵심이면 → M1

**즉시 산출물(DoD):** 파일(제안서/데크/코드), 테이블/리포트, 모델/룰, 카탈로그/메타

### 1) Generate (새 내용 생성)

| 항목 | 내용 |
|------|------|
| **정의** | 없던 결과물을 새로 생성 — 글/코드/데크/데이터 |
| **포함** | 제안서 작성, 코드 개발, 보고서 초안, 콘텐츠 제작 |
| **제외** | N→1 결합은 Structure, 포맷만 바꾸면 Structure |
| **예시** | (교) 제안서 작성: Trigger(니즈 정리) → Input(요구사항/가격) → Action(데크/견적 작성) → Output(Proposal_v1.pdf) → Next(검토→M4, 발송→M3) |

### 2) Structure (구조화/표준화)

| 항목 | 내용 |
|------|------|
| **정의** | 목차·스키마·라벨링·표준화 등 탐색·재사용을 위한 구조화 |
| **포함** | 데이터 딕셔너리, 포맷 변환, N→1 데이터 조인, 1→N 분리/추출, 카탈로그화 |
| **제외** | 의미 해석·판단 → Interpret, 0→1 신규 생성 → Generate |

### 3) Interpret (해석/의미 도출)

| 항목 | 내용 |
|------|------|
| **정의** | 지표/데이터/발화를 의미로 해석하여 판단 근거 제공 |
| **포함** | 재무분석, 민감도 분석, 가설 도출, 다기준 평가/등급 산정 |
| **제외** | 단순 수집/기록 → SENSE(M2 아님), 신규 문서 작성 → Generate |
| **예시** | (범) 가격 가설 해석: Trigger(수주/실패 데이터) → Input(거래·비용·경쟁가) → Action(민감도/가설 도출) → Output(해석 메모/권고안) → Next(정책안 초안→DECIDE) |

### 4) Refine (윤문/클린징/품질 개선)

| 항목 | 내용 |
|------|------|
| **정의** | 윤문·클린징·중복제거·품질↑ — 의도를 유지하며 개선 |
| **포함** | 문서 윤문, 코드 리팩토링, 데이터 클린징, 결함 수정(디지털) |
| **제외** | 원의도 변경 → Generate, 물리 수리 → M1(Modify) |

**M2 KPI & Value Gate:**
- Time: 작성/분석 시간↓
- Error: 오탈자/수치오류↓
- WTP: 전환·설득↑
- Trust: 일관 정의/근거↑

**M2 흔한 함정:**
- "서명본 만들기"는 내용 생성이 아니라 법적 확정 → M4
- "보냈더니 성과↑"일 때, 보낸 타이밍(M3)인지 내용(M2)인지 구분

---

## C.3 M3. Physical Coordinates — 물리 좌표 최적화 (2종)

때와 곳(시·공간)을 최적화해서 접근성·적시성으로 가치를 키운다.

**언제 Primary인가?**
- 같은 내용이라도 언제/어디에/어떤 순서로 하느냐가 성패를 좌우
- 응답률·납기·현금화·자원충돌이 타이밍/라우팅 문제일 때
- 병목이 핸드오프/대기/왕복조율에 있을 때

**경계/제외:**
- 콘텐츠 품질이 핵심 → M2
- 권리 확정/승인 문제 → M4
- 물리 가공/제조 → M1

**즉시 산출물(DoD):** 스케줄/예약/배포/운송/정산 로그, 캘린더 이벤트, 트래킹/ETA, 결제승인 레코드

### 1) SpatialOptimize (공간/경로 최적화)

| 항목 | 내용 |
|------|------|
| **정의** | 위치·경로·라우팅 최적화 — 물리 이동의 효율을 높임 |
| **포함** | 배송 경로 최적화, 좌석/자재 동선 배치, 반품 라우팅 |
| **제외** | 타이밍/슬롯 문제 → TemporalOptimize |
| **예시** | (범) 배송 경로 최적화: Trigger(출고 확정) → Input(주소·제한·SLA) → Action(라우팅/배차) → Output(경로·ETA 로그) → Next(배송 완료·검수) |

### 2) TemporalOptimize (시간/타이밍 최적화)

| 항목 | 내용 |
|------|------|
| **정의** | 타이밍·슬롯·대기 최소화 — 적시 전달/정산으로 가치 극대화 |
| **포함** | 캘린더 초대·리마인드, 대금 수납 타이밍, 배포 시점 최적화, 인계·납품 적시성 |
| **제외** | 물리 경로/동선 문제 → SpatialOptimize |
| **예시** | (교) 미팅 초대 & 리마인드: Trigger(가용창 확인) → Input(참석자 가용성) → Action(캘린더 초대·T-24h 리마인드) → Output(이벤트/리마인드 로그) → Next(미팅 진행) |

**M3 KPI & Value Gate:**
- Time: 대기/왕복조율/납기 지연↓
- WTP: 응답률/참석률/전환↑
- Risk: 현금화 지연/재고 부족/노쇼↓

**M3 흔한 함정:**
- 이메일 "작성"은 M2, "보내는 타이밍·빈도"가 성패라면 M3
- 인보이스 발행은 M2(문서), 수납은 M3(TemporalOptimize)

---

## C.4 M4. Social Coordinates — 사회 좌표 최적화 (2종)

권리/보증을 명확히 해서 법적 효력·신뢰를 확보한다.

**언제 Primary인가?**
- 서명/승인/인증/허가가 있어야만 가치가 발생하거나 리스크가 0에 수렴
- "좋은 문서(M2)"보다 효력·책임·추적성이 진짜 레버리지일 때
- 외부/감사/규제 환경에서 증빙이 곧 가치일 때

**경계/제외:**
- 초안/가이드/설명서 → M2
- 납품/배송/정산 → M3
- 실물 제작/수정 → M1

### 1) RightsAffirmation (권리/의무 확정)

| 항목 | 내용 |
|------|------|
| **정의** | 계약/권한/예산/자격 확정 — 법적·제도적 귀속을 확립 |
| **포함** | 전자서명 완료, 예산 확정, 권한 부여/회수, 정책 공표, 수료증 발급, 라이선스 등록 |
| **DoD** | 서명본·인증서·권한로그·예산확정·허가증 |
| **예시** | (교) 본 계약 체결: Trigger(제안 합의) → Input(계약서/서명자 권한) → Action(전자서명/등록) → Output(서명본/계약 레코드) → Next(청구/수납→M3) |

### 2) StateAssurance (상태/품질 보증)

| 항목 | 내용 |
|------|------|
| **정의** | 품질/진위/준수 보증 — 검증/감사/모니터로 상태 확인 |
| **포함** | 체크리스트 검증, A/B 테스트, 대시보드 모니터링, 독립 감사, 위험 평가, 사고 대응 |
| **DoD** | 검증로그·감사보고·모니터 알람·위험목록·대응보고서 |
| **예시** | (범) 제안서 체크리스트 검증: Trigger(발송 전) → Input(체크리스트) → Action(규격/링크/가격 검증) → Output(검증 로그) → Next(수정→M2 또는 발송→M3) |

**M4 KPI & Value Gate:**
- Risk: 분쟁/컴플라이언스/페널티↓
- Trust: 신뢰/평판↑
- Option: 후속기회·갱신 가능성↑

**M4 흔한 함정:**
- "서명 없이" 슬라이드만 훌륭해도 권리 불확정이면 매출 0 → M4가 핵심
- 검증에서 수정까지 한 카드에 섞지 말 것 (검증=M4, 수정=M2-Refine)

---

## C.5 Primary/Secondary 지정 규칙

**원칙:**
- **Primary는 반드시 1개:** "이 축을 제거하면 가치가 70% 이상 증발하는가?"
- **Secondary는 보조:** 부가적으로 기여하지만, 제거해도 핵심 가치는 유지

### 빠른 판별 질문

| # | 질문 | → M |
|---|------|-----|
| 1 | 결과가 물리로 드러나나? | M1 |
| 2 | 내용 자체가 승패를 가르나? | M2 |
| 3 | 타이밍·위치가 승패를 가르나? | M3 |
| 4 | 권리/보증이 없으면 0원이 되나? | M4 |

### 예시 매핑

| 과업 | Primary | Secondary |
|------|---------|-----------|
| 제안서 '작성' | M2(Generate) | — |
| 제안서 '발송' | M3(TemporalOptimize) | M2(Structure) |
| 본 계약 서명 | M4(RightsAffirmation) | — |
| 청구/수납 | M3(TemporalOptimize) | — |
| 키트 제작 | M1(Combine) | — |
| 키트 납품 | M3(SpatialOptimize) | M1 |

### 이중계수 금지 체크

- 같은 원인으로 두 Gate를 중복 가산하지 말 것
- 예: "리마인드 자동화로 응답↑" → M3(TemporalOptimize) 덕분. 여기서 "내용도 좋았다(M2)"를 같은 효과로 또 더하지 말기
- 저장/배포를 한 카드에 섞지 말기 (작성=M2, 발송=M3)

---

## C.6 Primitive → Mechanism LV2 기본 매핑 가이드

> 아래는 **기본(default) 매핑**이다. 과업의 구체적 맥락에 따라 다른 M-LV2가 더 적절할 수 있으므로, C.5 빠른 판별 질문으로 최종 확정한다.

### TRANSFORM → M2(Content) / M1(Form)

| Primitive-LV2 | M2 (디지털) | M1 (물리) |
|---------------|------------|-----------|
| Generate | Generate | Create |
| Edit | Refine | — |
| Repair | Refine | Modify |
| Convert | Structure | — |
| Integrate | Structure | Combine |
| Structure | Structure | — |
| SplitExtract | Structure | Decompose |

### SENSE / DECIDE → M2(Content)

| Primitive-LV1 | 주요 M2-LV2 |
|---------------|-------------|
| SENSE | Structure (기록/구조화) |
| DECIDE — Select, Rank | Interpret (해석/판단) |
| DECIDE — Allocate, Schedule | Structure (배분/구조화) |
| DECIDE — SpecifyRules | Generate (규칙 생성) |

### TRANSFER → M3(Physical Coordinates)

| Primitive-LV2 | M3-LV2 |
|---------------|--------|
| Transport | SpatialOptimize |
| Distribute | TemporalOptimize |
| HandOver | TemporalOptimize |
| Deliver | TemporalOptimize |
| Settle | TemporalOptimize |

### COMMIT → M4(Social Coordinates)

| Primitive-LV2 | M4-LV2 |
|---------------|--------|
| ExecuteContract | RightsAffirmation |
| PromulgatePolicy | RightsAffirmation |
| GrantAuthorization | RightsAffirmation |
| CommitResources | RightsAffirmation |
| Certify | RightsAffirmation |
| RegisterFile | RightsAffirmation |

### ASSURE → M4(Social Coordinates)

| Primitive-LV2 | M4-LV2 |
|---------------|--------|
| Verify | StateAssurance |
| Validate | StateAssurance |
| Monitor | StateAssurance |
| Audit | StateAssurance |
| AssessRisks | StateAssurance |
| IncidentResponse | StateAssurance |
