# Examples

## Example 1: Good — Digital/ContentDocs/TRANSFORM

**Input**: atomic_text="월간 매출 리포트 작성하기", phase=P3, primitive_lv1=TRANSFORM

**Classification**:
```json
{
  "primitive_lv2": "Generate",
  "domain_lv1": "Digital",
  "domain_lv2": "ContentDocs",
  "mechanism_lv1": "M2",
  "mechanism_lv2": "Generate",
  "full_code": "Digital(ContentDocs).TRANSFORM[Generate]::M2(Generate)",
  "dna_confidence": 90,
  "rationale": "리포트 작성은 문서 생산(ContentDocs). Generate가 적합.",
  "review_flags": []
}
```

## Example 2: Good — Institutional/ASSURE

**Input**: atomic_text="PLCC 계약 조항 리스크 검토하기", phase=P4, primitive_lv1=ASSURE

**Classification**:
```json
{
  "primitive_lv2": "Validate",
  "domain_lv1": "Institutional",
  "domain_lv2": "Contracts",
  "mechanism_lv1": "M4",
  "mechanism_lv2": "StateAssurance",
  "full_code": "Institutional(Contracts).ASSURE[Validate]::M4(StateAssurance)",
  "dna_confidence": 92,
  "rationale": "계약 리스크 검토는 제도적 검증(Contracts+Validate). M4 StateAssurance.",
  "review_flags": []
}
```

## Example 3: Good — with secondary mechanism

**Input**: atomic_text="파트너사 비용 분담·수익 공유 모델 설계하기", phase=P3, primitive_lv1=TRANSFORM

**Classification**:
```json
{
  "primitive_lv2": "Generate",
  "domain_lv1": "Financial",
  "domain_lv2": "RevenueMargin",
  "mechanism_lv1": "M2",
  "mechanism_lv2": "Structure",
  "full_code": "Financial(RevenueMargin).TRANSFORM[Generate]::M2(Structure)",
  "secondary_mechanism_lv1": "M4",
  "secondary_mechanism_lv2": "Negotiate",
  "dna_confidence": 82,
  "rationale": "수익 모델 설계는 구조화(M2 Structure)가 주이나, 파트너 협상 요소도 있어 M4 Negotiate를 secondary로.",
  "review_flags": []
}
```

## Example 4: Bad — anchor violation

**Input**: atomic_text="경쟁사 동향 모니터링하기", phase=P1, primitive_lv1=SENSE

**Bad classification**:
```json
{
  "phase": "P4",
  "primitive_lv1": "ASSURE",
  "primitive_lv2": "Monitor"
}
```

**Why bad**: Changed phase from P1→P4 and primitive_lv1 from SENSE→ASSURE. These are immutable anchors from Stage 3. Even if "모니터링" sounds like ASSURE, the Stage 3 decision to classify this as P1/SENSE (competitive intelligence gathering) must be preserved.

**Correct**:
```json
{
  "phase": "P1",
  "primitive_lv1": "SENSE",
  "primitive_lv2": "DiscoverAndCaptureExternal",
  "review_flags": ["ontology_boundary"]
}
```

## Example 5: Bad — invented LV2

**Bad**:
```json
{
  "domain_lv2": "CardProducts",
  "mechanism_lv2": "DesignAndPlan"
}
```

**Why bad**: "CardProducts" and "DesignAndPlan" are not in the canonical ontology. Do not invent LV2 values. Use the closest existing value from the reference files.
