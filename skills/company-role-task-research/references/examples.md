# Examples

## Example 1: Strong official evidence (Tier A)

**Input**: 현대카드 상품기획팀/PLCC팀

**Search**: "현대카드 상품기획 채용" → 공식 채용공고 2건 발견

**Output** (축약):
```json
{
  "company": "현대카드",
  "role": "상품기획팀 / PLCC팀",
  "summary": "현대카드 공식 채용공고 2건에서 18개 과업 추출. PLCC 파트너십과 카드 상품 라이프사이클 관리가 핵심.",
  "evidence_quality": "strong",
  "tasks": [
    {"task_text": "카드 상품별(M/X/Zero 등) 기획·마케팅·운영 및 Performance를 관리한다", "source_tier": "A", "confidence": 95},
    {"task_text": "PLCC 신규 Deal을 발굴·제안하고 파트너사와의 사업 전략 방향을 수립한다", "source_tier": "A", "confidence": 95},
    {"task_text": "파트너사 결제 데이터를 분석하여 PLCC 상품의 혜택 구조를 설계한다", "source_tier": "A", "confidence": 90},
    {"task_text": "고객 소비 트렌드를 분석하여 신규 카드 혜택 및 서비스를 기획한다", "source_tier": "B", "confidence": 85}
  ],
  "sources": [
    {"url": "https://careers.hyundaicard.com/...", "title": "현대카드 상품기획 채용", "source_type": "company_jd", "source_tier": "A"}
  ]
}
```

## Example 2: Same-company non-JD evidence (Tier B)

**Input**: KB국민은행 IT기획

**Search**: "KB국민은행 IT기획 채용" → 공식 JD 없음 → KB국민은행 IR/디지털 전략 페이지에서 추론

**Output** (축약):
```json
{
  "company": "KB국민은행",
  "role": "IT기획",
  "summary": "공식 JD 미발견. KB국민은행 디지털 전략 보고서와 IR에서 15개 과업 추론. 신한은행 IT기획 JD 1건으로 보완.",
  "evidence_quality": "moderate",
  "tasks": [
    {"task_text": "차세대 코어뱅킹 시스템 마이그레이션 계획을 수립하고 진행을 관리한다", "source_tier": "B", "confidence": 80},
    {"task_text": "디지털 채널(모바일뱅킹, 인터넷뱅킹) 고도화 프로젝트를 기획한다", "source_tier": "B", "confidence": 75},
    {"task_text": "IT 투자 예산을 편성하고 프로젝트 우선순위를 결정한다", "source_tier": "C", "confidence": 70}
  ]
}
```

## Example 3: Sparse evidence fallback (Tier D/E)

**Input**: 평화발레오 품질관리

**Search**: "평화발레오 품질관리 채용" → 결과 없음 → "자동차 부품 품질관리 직무" 일반 자료

**Output** (축약):
```json
{
  "company": "평화발레오",
  "role": "품질관리",
  "summary": "평화발레오 관련 직접 증거 없음. 자동차 부품 업계 품질관리 일반 자료와 Valeo 그룹 JD에서 12개 과업 추정. 회사 특이 과업은 확인 불가.",
  "evidence_quality": "weak",
  "tasks": [
    {"task_text": "입고 부품 및 원자재의 수입검사를 수행하고 불량률을 관리한다", "source_tier": "D", "confidence": 60},
    {"task_text": "IATF 16949 품질경영시스템 인증을 유지하고 내부 심사를 수행한다", "source_tier": "D", "confidence": 55},
    {"task_text": "고객사(OEM) 클레임에 대응하고 시정조치 보고서를 작성한다", "source_tier": "E", "confidence": 45, "source_note": "자동차 부품 업계 일반 추정"}
  ]
}
```
