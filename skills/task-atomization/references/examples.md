# Examples

## Example 1: Split case (different deliverables)

**Raw task**: "월간 매출 리포트를 작성하고 경영진에게 보고한다"

**Decision**: SPLIT — deliverables differ (문서 vs 전달 행위)

**Result**:
```json
[
  {
    "atomic_index": 1,
    "atomic_text": "월간 매출 리포트 작성하기",
    "phase": "P3",
    "primitive_lv1": "TRANSFORM",
    "split_reason": "different deliverables: document production vs delivery",
    "semantic_bucket_hint": "Financial"
  },
  {
    "atomic_index": 2,
    "atomic_text": "월간 매출 리포트를 경영진에게 보고하기",
    "phase": "P3",
    "primitive_lv1": "TRANSFER",
    "split_reason": "different deliverables: document production vs delivery",
    "semantic_bucket_hint": "Financial"
  }
]
```

## Example 2: No-split object enumeration (same deliverable)

**Raw task**: "예산, 인력, 자원 관리"

**Decision**: KEEP — all objects share the same management action and deliverable type.

**Result**:
```json
[
  {
    "atomic_index": 1,
    "atomic_text": "예산·인력·자원을 종합적으로 관리하기",
    "phase": "P4",
    "primitive_lv1": "ASSURE",
    "split_reason": "no_split",
    "split_confidence": 95,
    "semantic_bucket_hint": "Human"
  }
]
```

## Example 3: Bad oversplit

**Raw task**: "고객 데이터를 분석하여 마케팅 전략을 수립한다"

**Bad result** (oversplit):
```
1. 고객 데이터 수집하기 (SENSE)
2. 고객 데이터 정리하기 (TRANSFORM)
3. 고객 데이터 분석하기 (DECIDE)
4. 마케팅 전략 수립하기 (DECIDE)
```

**Why bad**: Steps 1-3 are sub-steps of a single analytical flow. The immediate deliverable is one: "마케팅 전략".

**Good result**:
```
1. 고객 데이터를 분석하여 마케팅 전략 수립하기 (P2/DECIDE)
```

## Example 4: Bad no-split

**Raw task**: "시장 동향을 조사하고, 신상품을 기획하고, 출시 후 성과를 모니터링한다"

**Bad result** (no split):
```
1. 시장 동향 조사·신상품 기획·출시 후 성과 모니터링하기
```

**Why bad**: Three clearly different phases (P1/SENSE → P2/DECIDE → P4/ASSURE) with different deliverables.

**Good result**:
```
1. 시장 동향 조사하기 (P1/SENSE)
2. 신상품 기획하기 (P2/DECIDE)
3. 출시 후 성과 모니터링하기 (P4/ASSURE)
```
