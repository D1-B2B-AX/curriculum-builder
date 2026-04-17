# I/O Linking Rules

## Why I/O linking matters

Stage 5 must reason about task-to-task dependencies within the same role. One task's `immediate_output` often becomes another task's `input`.

## Explicit linkage

When Task A's output is clearly the input for Task B:
- Task A: immediate_output = "PLCC 수익성 분석 보고서"
- Task B: inputs = [{"seq": 1, "input_text": "PLCC 수익성 분석 보고서 (Task A 산출물)"}]

## Inferred linkage

When the connection is reasonable but not explicit:
- Task A (SENSE): immediate_output = "고객 소비 트렌드 분석 결과"
- Task B (TRANSFORM): inputs should include "고객 소비 트렌드 분석 결과" if Task B is about developing new benefits based on trend analysis

## When NOT to force a link

- Do not create artificial links just because two tasks exist in the same role
- Only link when the output genuinely serves as input
- If a task's inputs come from external sources (CRM, 기간계, 외부 데이터), do not force a same-role link

## Scanning workflow

1. List all tasks for the role
2. For each task, note its `immediate_output`
3. When writing inputs for each task, check if any same-role output matches
4. If match found → reference it explicitly
5. If no match → use external inputs (data sources, documents, systems)

## Example

```
Role: 상품기획팀 / PLCC팀

Task A: "고객 소비 패턴·트렌드 분석하기" (SENSE)
  → immediate_output: "고객 소비 트렌드 분석 보고서"

Task B: "신규 카드 혜택 및 서비스 개발하기" (TRANSFORM)
  → inputs: [
      {"seq": 1, "input_text": "고객 소비 트렌드 분석 보고서 (Task A 산출물)"},
      {"seq": 2, "input_text": "기존 카드 혜택 현황 데이터"}
    ]

Task C: "PLCC 카드 수익성 분석하기" (DECIDE)
  → inputs: [
      {"seq": 1, "input_text": "파트너사 결제 데이터 (CRM)"},
      {"seq": 2, "input_text": "혜택 구조 설계안 (Task D 산출물)"}
    ]
```
