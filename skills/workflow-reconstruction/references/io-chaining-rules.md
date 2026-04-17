# I/O Chaining Rules

## How to compare

For each pair of tasks (A, B):
1. Compare Task A's `immediate_output` against Task B's `inputs[].input_text`
2. If match found → create edge A→B

## Evidence levels

### evidence-based
- Direct text match or near-exact containment
- Task B's input explicitly references Task A's output
- Example: A output = "PLCC 카드 수익성 분석 보고서", B input = "PLCC 카드 수익성 분석 보고서 (Task 003__002 산출물)"

### inferred
- Reasonable semantic match — output type matches input need, but no explicit reference
- Must include explanatory `note`
- Example: A output = "고객 소비 트렌드 분석 보고서", B input = "시장 트렌드 데이터" — semantically related but not exact match
- Note: "소비 트렌드 분석 보고서가 시장 트렌드 데이터의 주 출처로 추정"

### no-link
- No semantic relationship between output and input
- Do NOT create an edge

## Cross-phase I/O

- A P1/SENSE task's output can feed a P3/TRANSFORM task's input
- A P4/ASSURE task's output can feed a P2/DECIDE task's input (feedback loop)
- Phase does NOT restrict edge creation

## Multiple consumers

- One task's output may be consumed by multiple tasks → creates multiple edges (divergence)
- This is normal and expected for hub tasks (e.g., "경쟁사 벤치마킹 리포트" used by 5 tasks)

## Multiple producers

- One task may consume outputs from multiple other tasks → multiple incoming edges (convergence)
- This is normal for integration/decision tasks
