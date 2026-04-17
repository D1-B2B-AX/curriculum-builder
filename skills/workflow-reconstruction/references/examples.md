# Examples

## Example 1: Simple linear cross-phase chain

```
004__001 (P1/SENSE) → 004__002 (P3/TRANSFORM) → 005__001 (P2/DECIDE)
소비 트렌드 분석     →  신규 혜택 개발         →  포트폴리오 평가

Edge 1: evidence-based — "소비 트렌드 분석 보고서" → 004__002 input 직접 참조
Edge 2: evidence-based — "신규 혜택·서비스 설계안" → 005__001 input으로 참조
```

Cross-phase: P1→P3→P2. Phase order doesn't constrain workflow.

## Example 2: Branching stream with convergence

```
         → 003__001 (혜택 설계) ─┐
004__001 ─┤                       ├→ 005__001 (포트폴리오 평가)
         → 007__001 (수익 분석) ─┘

Divergence hub: 004__001 (out-degree 2+)
Convergence hub: 005__001 (in-degree 2+)
Stream: "혜택 설계 스트림" (003__001 branch)
Stream: "수익 구조 분석 스트림" (007__001 branch)
```

## Example 3: Inferred link

```
Edge: 013__001 → 003__002
from: "파트너사 고객 인사이트 보고서"
to input: "데이터 사이언스 태그 기반 고객 인사이트 보고서 (Task 013__001 산출물)"
evidence_status: "evidence-based" (직접 참조)

Edge: 018__001 → 001__001
from: "경쟁사 벤치마킹 리포트"
to input: "경쟁사 카드 상품 벤치마킹 리포트 (Task 018__001 산출물)"
evidence_status: "evidence-based" (직접 참조)
```

## Example 4: Independent cluster split

**When to split**: Role has two completely independent process groups:
- Group A: 카드 상품 기획 (tasks 001-018) — all connected via I/O
- Group B: 사내 교육 운영 (tasks 019-021) — zero I/O links to Group A

→ Split into 2 workflows because no meaningful linkage exists.

**When NOT to split**: Even if tasks seem thematically different, if they share even one I/O link, keep unified.

## Example 5: Bad — invented link

```
Bad edge: 016__001 → 011__001
Reason: "포트폴리오 대시보드가 캠페인 기획에 도움이 될 것으로 판단"
Problem: 016__001's output is NOT referenced in 011__001's inputs.
```

**Why bad**: No I/O evidence. "도움이 될 것" is speculation, not evidence. Do NOT create this edge.
