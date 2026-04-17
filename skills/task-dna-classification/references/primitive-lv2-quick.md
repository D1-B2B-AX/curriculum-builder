# Primitive-LV2 Quick Reference

For boundary cases, read the full [primitive-lv2.md](primitive-lv2.md).

## SENSE (P1) — 6종

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| CaptureTelemetry | 시스템/디바이스 자동 이벤트·로그·메트릭 원형 적재 | 앱/웹 이벤트, 서버 메트릭, IoT 스트림 | 지표 산출(DAU)→DECIDE |
| RecordTransaction | 비즈니스 상태 전이 사건을 고유 ID로 기록 | CRM 리드 생성, 결제 Webhook, 티켓 | 인보이스 생성→TRANSFORM |
| DiscoverAndCaptureExternal | 외부 출처에서 사실·문서를 탐색·취득 | 시장조사, 채용공고 수집, 경쟁사 동향, 특허 검색 | 의미 요약→TRANSFORM |
| ReceiveInbound | 상대방이 보내온 아티팩트를 수신·등록 | 이력서 접수, 제안서 수신, 자재 입고 | 평가→DECIDE |
| SurveyAndCollectResponses | 구조화된 질문으로 응답을 수집 | 설문, NPS, 퀴즈, 투표 | 분석→DECIDE |
| ObserveAndNote | 비구조적 관찰·메모를 기록 | 현장 관찰, 수업 참관, 미팅 노트 | 보고서 작성→TRANSFORM |

## DECIDE (P2) — 4종

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| DefineTargets | 목표·기준·임계값을 설정 | KPI 목표, 예산 기준, 전략 방향, 합격 기준 | 실행→TRANSFORM |
| Select | 후보군에서 최적안을 고름 | 벤더 선정, 채널 선택, 도구 선택 | 순위만 매기기→Rank |
| Rank | 복수 대상을 기준으로 순위화 | 성과 순위, 우선순위, 스코어링 | 1개만 고르기→Select |
| SpecifyRules | 규칙·정책·SOP를 명문화 | 시스템 요건, 프로세스 정의, 가이드라인 | 법적 고시→COMMIT |

## TRANSFORM (P3, M2 Content) — 4종

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| Generate | 0→1 새 콘텐츠/아티팩트 생산 | 보고서 작성, 코드 개발, 디자인, 교안 | 기존 편집→Refine |
| Structure | 기존 데이터를 구조화·분류·태깅 | 데이터 정제, 카테고리화, 인덱싱 | 해석→Interpret |
| Interpret | 데이터에서 의미·인사이트 도출 | 트렌드 분석, 대시보드 해석, 원인 분석 | 목표 설정→DECIDE |
| Refine | 기존 아티팩트를 개선·수정·업데이트 | 문서 수정, 코드 리팩토링, 디자인 피드백 반영 | 0→1 생성→Generate |

## TRANSFER (P3) — 3종

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| Distribute | 산출물을 다수 수신자에게 배포 | 이메일 발송, 보고서 배포, 공지 | 1:1 납품→Deliver |
| Deliver | 특정 수신자에게 산출물을 납품·인도 | 고객 납품, 결과물 전달, 핸드오프 | 대중 배포→Distribute |
| Settle | 금전적 정산·지급·수금 | 급여 지급, 수수료 정산, 환불 | 승인→COMMIT |

## COMMIT (P3) — 3종

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| Authorize | 진행 권한·승인을 부여 | 결재, 예산 승인, 접근 권한 부여 | 계약→ExecuteContract |
| ExecuteContract | 계약·합의를 법적으로 확정 | 계약 서명, MOU 체결, SLA 합의 | 승인→Authorize |
| Enact | 규칙·정책을 공식 시행 | 제도 시행, 공시, 정책 발효 | 규칙 정의→DECIDE.SpecifyRules |

## ASSURE (P4) — 4종

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| Validate | 목적 적합성(fit-for-purpose) 검증 | UAT, 파일럿 테스트, 시장 테스트 | 규격 적합→Verify |
| Verify | 명세 대비 정확성·규격 적합 확인 | 단위 테스트, QC, 검수, 교정 | 목적 적합→Validate |
| Monitor | 지속적 지표 추적·이상 감시 | KPI 모니터링, 대시보드, 알림 | 1회 검사→Verify |
| Audit | 사후 독립적 적합성·준수 여부 심사 | 감사, 컴플라이언스 검토, 인증 심사 | 일상 모니터링→Monitor |
