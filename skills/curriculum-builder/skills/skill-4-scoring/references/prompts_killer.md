# references/prompts_killer.md — K4 / K5 LLM 판정 프롬프트

Killer Criteria 5종 중 K1/K2/K3은 필드 기계 체크 (→ `rubric.md §4` 참조).
K4·K5는 LLM 판단 필요 → 본 파일의 프롬프트 사용.

---

## K4 — task 본질의 비윤리·불법 판정

```
당신은 이 task를 AI 교육 실습으로 쓸 수 있는지 윤리적·법적 관점에서 판정합니다.

[Task 정보]
one_liner: {task.one_liner}
action: {task_cards.action}
inputs: {task_cards.inputs}
immediate_output: {task_cards.immediate_output}

[판정 대상]
다음 중 하나에 해당하면 "yes" (K4 발동):
1. task가 **폭력·차별·혐오·사생활 침해·불법 콘텐츠 생성** 행위 자체인가?
2. task가 **안전·생명에 직결되는 실시간 결정**이라 합성 환경에서 학습 가치가 사라지는가?

[판정 제외 대상 — 매우 중요]
**데이터 민감성은 판정 대상이 아닙니다.**
실제 환자 데이터·기업 M&A 자료·개인정보 등 민감 데이터 요구는 합성 데이터로 대체 가능하므로
Skill 5(M4 실습 설계)에서 처리됩니다. **데이터 문제만 있는 task는 K4 "no"로 판정하세요.**

[예시]
- "폭력 콘텐츠 생성 요청 task" → yes (폭력 콘텐츠 자체 생성)
- "혐오 댓글 자동 생성" → yes (혐오 콘텐츠 자체 생성)
- "실시간 응급 진료 결정" → yes (안전 직결 실시간 결정, 합성 불가)
- "고객 개인정보 분석" → **no** (데이터 민감성 문제 — 합성 데이터 대체 가능 → Skill 5에서 처리)
- "임상 의학 연구 논문 요약" → no (데이터 민감성은 있으나 task 자체는 적합)

[출력 JSON 형식]
{
  "verdict": "<yes | no>",
  "reason": "<판정 근거 한 문장. 위 1·2 중 어디에 해당하는지 또는 해당 없음 이유>"
}
```

**Killer 발동 기록 형식**:
```json
{"task_id": "T...", "killer_rule": "K4", "reason": "<verdict=yes인 이유>"}
```

---

## K5 — 툴×task 모달리티 불일치 판정

```
당신은 툴과 task의 **입출력 형식(모달리티)**이 근본적으로 불일치하는지 판정합니다.

[툴 정보 — {tool_name}]
features 목록 전문:
{tool-features.json의 해당 툴 블록 전문}

[Task 정보]
action: {task_cards.action}
inputs: {task_cards.inputs}
immediate_output: {task_cards.immediate_output}

[판정 기준]
**두 형식이 근본적으로 불일치**하는가?

- 예시 yes: 툴이 텍스트 전용인데 task가 실시간 영상 분석 필수
- 예시 yes: 툴이 이미지 생성 전용인데 task가 대량 숫자 데이터 분석 필수
- 예시 no: 텍스트 툴로 음성 task 지원 가능 (전사 서비스 우회 가능)
- 예시 no: 이미지 생성 툴로 로고 아이디어 task (직접 적용 가능)

**우회·간접 지원 가능성이 있으면 "no"로 판정.** 완전 불가능한 경우만 "yes".

[출력 JSON 형식]
{
  "verdict": "<yes | no>",
  "reason": "<판정 근거 한 문장>"
}
```

**Killer 발동 기록 형식**:
```json
{"task_id": "T...", "killer_rule": "K5", "reason": "<verdict=yes인 이유>"}
```
