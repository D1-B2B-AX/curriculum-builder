# references/prompts_v2.md — V2 duration / topic_fit 프롬프트

V2 proxy 중 LLM 호출이 필요한 2개.
- ② duration: task의 1회 수행 소요시간 추정
- ⑤ topic_fit: 입력 주제와 task의 관련성 판정

나머지 3개 proxy(frequency, source_trust, centrality)는 `rubric.md §3`의 필드 매핑으로 LLM 호출 없이 계산.

---

## 1. V2 duration 추정 프롬프트

```
당신은 이 task의 **1회 수행 소요시간**을 추정합니다.

[Task 정보]
action: {task_cards.action}
inputs: {task_cards.inputs}
immediate_output: {task_cards.immediate_output}

[판정 기준 (duration_band)]
하루 이상 (>4h): 전략 기획, 대규모 분석, 여러 단계 통합 작업
반일 (2~4h): 보고서 작성, 대면 미팅 시리즈, 심층 분석
1~2시간: 회의 진행, 리뷰·검토, 중간 규모 작업
30분 이내: 짧은 응답, 간단 확인, 체크리스트 실행
몇 분: 승인, 단순 체크, 표기 업데이트

[지시]
task의 action·inputs·immediate_output 규모와 복잡도를 종합적으로 보고 판정.
판단 근거를 한 문장으로 제시.

[출력 JSON 형식]
{
  "duration_band": "<하루 이상 | 반일 | 1~2시간 | 30분 이내 | 몇 분>",
  "rationale": "<판정 근거 한 문장>"
}
```

**점수 매핑**: 출력의 duration_band를 `rubric.md §3-②`의 매핑표로 변환 (5→5 / 반일→4 / 1~2h→3 / 30분→2 / 몇 분→1).

---

## 2. V2 topic_fit 판정 프롬프트

```
당신은 task가 입력 교육 주제와 얼마나 관련 있는지 판정합니다.

[입력 교육 주제]
"{input.topic}"

(복수 주제인 경우 주제 요소 배열: {topic_input.topic_elements})

[Task 정보]
one_liner: {task.one_liner}
action: {task_cards.action}

[판정 기준]
직접 관련: task의 핵심 행위가 입력 주제와 직접 대응
인접 관련: task가 입력 주제의 주변·보조 영역에 해당
무관: task와 입력 주제가 개념적으로 별개 영역

[지시]
복수 주제일 경우 가장 관련성 높은 요소 기준으로 판정 (matched_topic 태깅은 prompts_meta.md에서 별도 수행).

[출력 JSON 형식]
{
  "fit": "<직접 관련 | 인접 관련 | 무관>",
  "reason": "<판정 근거 한 문장>"
}
```

**점수 매핑**: 출력의 fit을 `rubric.md §3-⑤`의 매핑표로 변환 (직접 관련→5 / 인접 관련→3 / 무관→0).
