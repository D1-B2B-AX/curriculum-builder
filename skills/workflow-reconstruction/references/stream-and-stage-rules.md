# Stream and Stage Rules

## Divergence hubs

A task is a divergence hub when:
- Its `immediate_output` feeds **2+ downstream tasks**
- `max_out >= 2`

## Convergence hubs

A task is a convergence hub when:
- It receives inputs from **2+ upstream tasks**
- `max_in >= 2`

## Stream rules

### Rule A: Divergence-convergence based stream
- Define a stream when a branch starts at a divergence hub and ends at a convergence hub
- All tasks on that branch path form the stream
- Stream name should reflect core domain or common action
- Example: "PLCC 파트너십 계약 스트림", "혜택 설계 스트림"

### Rule B: Independent coherent stream
- Even without a formal branch/merge, define a stream when a sequence of tasks forms a coherent subprocess that can run in parallel with another sequence
- Example: "실적 모니터링·보고 스트림" (010→010_002) running parallel to "혁신 상품 개발 스트림" (015→015_002)

## Stage grouping rules

Stages are for **readability**, not hard boundaries.

Group tasks into stages using milestones like:
- Branch points (divergence hubs)
- Merge points (convergence hubs)
- Stream starts / ends
- Major business checkpoints (e.g., "계약 체결 완료", "상품 출시", "결산 완료")

**Stage grouping must NOT prohibit cross-stage or cross-phase links.** Edges can and should cross stage boundaries when evidence supports them.

Stage naming: use short descriptive business names
- Good: "시장 조사 및 트렌드 분석", "상품 설계 및 혜택 구조화", "파트너 계약 및 협상"
- Bad: "Stage 1", "Phase A tasks", "Group 1"
