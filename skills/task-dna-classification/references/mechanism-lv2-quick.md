# Mechanism-LV2 Quick Reference

핵심 질문: **"이 과업의 핵심 가치가 M# 내에서 어떤 세부 메커니즘에 있는가?"**

For boundary cases, read the full [mechanism-lv2.md](mechanism-lv2.md).

## M1 Form — 물리 형태 변환 (4종)

"손으로/공정으로 만들거나 고쳐서 가치가 난다"

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| Create | 무→유 물리 결과물 생성 | 부품 제조, 3D 프린팅, 시제품 | 디지털 파일→M2.Generate |
| Combine | 여러 개를 조립/결합 | 부품 조립, 키트 패킹 | 데이터 병합→M2.Structure |
| Modify | 기존 물체 수정/개선/세팅 변경 | 수리, 교체, 업그레이드 | 문서 수정→M2.Refine |
| Decompose | 분해/해체/분리 | 해체, 분류, 재활용 | 데이터 분할→M2.Structure |

## M2 Content — 정보/콘텐츠 변환 (4종)

"정보를 바꿔 의미/유용성을 올린다"

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| Generate | 0→1 새 정보 생산 | 보고서 작성, 코드 개발, 설계 | 편집→Refine |
| Structure | 기존 정보 구조화/분류/태깅 | 데이터 정제, 카테고리화, 인덱싱 | 해석→Interpret |
| Interpret | 데이터→의미/인사이트 도출 | 트렌드 분석, 원인 분석, 해석 | 목표 설정→DECIDE |
| Refine | 기존 정보 개선/수정/업데이트 | 문서 수정, 리팩토링, 피드백 반영 | 0→1 생성→Generate |

## M3 Physical Coordinates — 시공간 최적화 (2종)

"적재적소에 적시에"

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| SpatialOptimize | 공간·위치·경로 최적화 | 배송 경로, 좌석 배치, 재고 위치 | 콘텐츠→M2 |
| TemporalOptimize | 시간·일정·순서 최적화 | 스케줄링, 배포 타이밍, 정기 보고 | 콘텐츠 생성→M2 |

## M4 Social Coordinates — 사회적 합의/보증 (2종)

"권리/의무/신뢰를 확립"

| LV2 | 정의 | 포함 | 제외 |
|-----|------|------|------|
| RightsAffirmation | 권리/의무/자격을 확립·변경 | 계약 서명, 승인, 자격 부여, 정책 시행 | 내용 작성→M2 |
| StateAssurance | 상태의 무결성/준수를 보증 | 모니터링, 검증, 감사, 품질 보증 | 콘텐츠 분석→M2 |

## Primary vs Secondary 규칙

- **Primary**: 과업의 핵심 가치가 있는 메커니즘 (반드시 1개)
- **Secondary**: 과업이 부수적으로 거치는 메커니즘 (0~1개)
- 대부분의 과업은 primary만 있으면 충분
- Secondary는 과업이 **진정으로 두 메커니즘을 동시에** 제공할 때만 부여
