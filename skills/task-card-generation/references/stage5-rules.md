# Stage 5 Rules

## Purpose

Stage 5 converts task_dna into operational task cards. Each card describes HOW a task is actually performed: what triggers it, what goes in, what action is taken, and what comes out.

## Role-level processing

All tasks for the same role must be processed together — not one at a time in isolation. This is because:
- One task's `immediate_output` may be another task's `input`
- Trigger events may depend on another task completing
- The skill must inspect same-role outputs and reuse them when appropriate

## Trigger rules

- If the trigger is directly visible from role/task context → use it directly
  - Example: "월간 결산 완료 시점", "파트너사 계약 만료 90일 전"
- If the trigger is not directly visible → prepend `[inferred]` and make a reasonable inference
  - Example: "[inferred] 분기별 포트폴리오 리뷰 시점"
- **Forbidden**: generic triggers like "필요 시", "수시", "업무 발생 시"

## Input rules

- Each task should usually have **1-3 important input items**
- Minimum allowed is 1
- Do NOT force the list to be filled to 3 if fewer inputs are actually sufficient
- Use only the inputs that are truly needed for the task
- A task in the same role may use another task's `immediate_output` as an input
- The skill must inspect same-role outputs and reuse them when appropriate

## Action rules

- `action_text` must start with the task's `primitive_lv2`
- Format: `"{primitive_lv2}: concrete operational description"`
- Example: "Generate: 매출 트렌드 분석 및 주요 지표 요약 리포트를 새로 작성한다"
- Must be concrete and operational, not vague

## Immediate Output rules

- Must be a concrete artifact that can be handed off
- Must NOT be an abstract activity label
- Good: "월간 매출 분석 리포트 (PDF/문서)"
- Bad: "매출 관리" (activity, not artifact)

## One-Liner rules

- Should express what / how / value in one sentence
- Should reflect Domain + Primitive + Mechanism
- Example: "월간 매출 원데이터를 분석·종합하여 경영 의사결정용 리포트를 작성한다"
