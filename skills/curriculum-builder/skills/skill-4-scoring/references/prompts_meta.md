# references/prompts_meta.md — multi_topic·matched_topic·diversity·LD 요약

Skill 4의 메타 LLM 호출 4종.
- 시작 시: multi_topic 감지 (1회)
- top3 확정 후: matched_topic 태깅 (복수 주제일 때만)
- top3 확정 후: 다양성 체크 (복수 주제일 때만)
- 마무리: LD 자연어 요약 생성

---

## 1. multi_topic 감지 프롬프트

**실행 시점**: Skill 4 시작 직후, 1회만.

```
당신은 입력된 교육 주제가 **복수 주제**인지 감지합니다.

[입력 주제]
"{input.topic}"

[판정 기준]
- 구분자(/, 쉼표, 괄호 나열)로 여러 개념이 나열됨 → is_composite = true
- 단일 주제 또는 하나의 개념을 설명한 문장 → is_composite = false

복합 주제인 경우, 각 주제 요소를 배열로 추출하세요.

[예시]

**단일 주제 케이스** (is_composite: false):
- "마케팅 자동화" → topic_elements: ["마케팅 자동화"]
- "데이터 분석 및 대시보드 구축" → topic_elements: ["데이터 분석 및 대시보드 구축"]
  (이유: "데이터 분석을 통한 대시보드 구축"이라는 연결된 단일 흐름. "및"이 나열이 아닌 순차·연결)
- "고객 CS 응대" → topic_elements: ["고객 CS 응대"]

**복수 주제 케이스** (is_composite: true):
- "AI(디자인, 컨텐츠, 영상) / 타이포그라피" → topic_elements: ["AI 디자인", "AI 컨텐츠", "AI 영상", "타이포그라피"]
  (이유: 괄호 나열 + 슬래시 구분. 명확한 복수 영역)
- "프롬프트 엔지니어링과 챗봇 개발" → topic_elements: ["프롬프트 엔지니어링", "챗봇 개발"]
  (이유: 서로 독립된 기술 영역을 "과"로 병렬 나열)
- "세일즈, 마케팅, CS" → topic_elements: ["세일즈", "마케팅", "CS"]
  (이유: 쉼표 나열, 각기 다른 직무 영역)

**경계 판정 원칙 — "및/과/와"의 의미 구분**:
- **연결·순차** (하나의 흐름·목적 내 서로 다른 단계·요소) → **단일** 판정
  - 예: "데이터 분석 및 대시보드 구축" — 분석이 대시보드 구축의 전제
- **병렬·나열** (서로 독립된 영역·기술·주제) → **복수** 판정
  - 예: "프롬프트 엔지니어링과 챗봇 개발" — 각기 독립된 기술 영역
- **판단 애매 시 단일로 기본 판정** (불필요한 쪼개짐 방지). Skill 4 내부 topic_fit 평가가 자연어로 맥락 해석

[출력 JSON 형식]
{
  "is_composite": <true | false>,
  "topic_elements": ["<주제1>", "<주제2>", ...]
}

※ is_composite = false일 때도 topic_elements는 입력 주제 1개 요소 배열로 반환 (예: ["{input.topic}"]).
```

---

## 2. matched_topic 태깅 프롬프트 (복수 주제일 때만)

**실행 시점**: top3 확정 후 + notable_outside_top3도 포함. `topic_input.is_composite = true`인 경우만.

```
당신은 이 task가 복수 주제 중 어느 요소와 가장 관련 있는지 태그합니다.

[주제 요소 목록]
{topic_input.topic_elements}

[Task 정보]
one_liner: {task.one_liner}
action: {task_cards.action}
immediate_output: {task_cards.immediate_output}

[지시]
topic_elements 중 가장 관련 있는 하나를 선택하세요.

**예외 — 다음 경우에는 `matched_topic: null`로 반환**:
- task가 여러 주제에 거의 동등하게 걸쳐 있어 1개 선택이 억지스러울 때
- task가 어느 주제와도 명확히 관련되지 않을 때

억지로 1개 고르지 말고, 판단이 어려우면 null + 그 이유를 reason에 기록.

[출력 JSON 형식]
{
  "matched_topic": <"<topic_elements 중 1개>" | null>,
  "reason": "<판정 근거 한 문장. null 반환 시 이유>"
}
```

각 top3·notable task마다 반복 호출. 단일 주제(`topic_input.is_composite = false`)일 때는 건너뛰고 `matched_topic: null`로 설정.

**Phase 1 한정**: 단일 값 + null 구조. task가 여러 주제에 매칭되는 경우(예: "AI 디자인"과 "AI 컨텐츠" 둘 다 관련)를 배열로 표현하는 것은 Phase 2 확장 과제.

---

## 3. top3 다양성 체크 프롬프트 (복수 주제일 때만)

**실행 시점**: matched_topic 태깅 완료 후. `topic_input.is_composite = true`인 경우만.

```
당신은 top3 task들이 복수 주제에 고르게 분포하는지 판정합니다.

[주제 요소]
{topic_input.topic_elements}

[Top 3 task와 각자 matched_topic]
- Top 1: {task_1.one_liner} → matched_topic: {task_1.matched_topic}
- Top 2: {task_2.one_liner} → matched_topic: {task_2.matched_topic}
- Top 3: {task_3.one_liner} → matched_topic: {task_3.matched_topic}

(matched_topic이 null인 task는 "unassigned"로 간주 — 쏠림 판정에서 제외하고, topic_coverage에 별도 기록)

[판정]
- balanced = true: 2개 이상 서로 다른 주제에 분포 (null은 제외하고 판단)
- balanced = false: 한 주제로 쏠려 있음 (3개 모두 같거나 2개 이상이 한 주제. null 있으면 null 제외한 나머지만 판단)

쏠린 경우 쏠린 주제를 skewed_to에 기록.

[출력 JSON 형식]
{
  "topic_coverage": { "<주제1>": <count>, "<주제2>": <count>, "unassigned": <count> },
  "balanced": <true | false>,
  "skewed_to": <"<주제명>" | null>
}
```

단일 주제일 때는 실행하지 않음. `diversity_check.performed = false`로 기록.

---

## 4. LD 자연어 요약 생성 프롬프트

**실행 시점**: JSON 저장 후, LD에게 보고할 자연어 텍스트 실시간 생성.

```
당신은 Skill 4의 최종 결과를 LD에게 자연어로 보고합니다.

[Input — top-tasks.json의 해당 per_tool 블록 전문]
{per_tool[현재_툴] 전문 JSON}

[참조 — 변환 규칙]
- references/rubric.md §5 "LD 친화 변환 규칙" 표를 그대로 따름
- SKILL.md §"LD 출력 템플릿" 형식에 맞춤

[변환 규칙 — 필수 준수]

1. **rubric 라벨 금지**. 다음 표현을 LD 출력에 쓰지 마세요:
   - V3 label ("속도 절감", "품질 개선", "질적 전환") → rubric.md §5의 V3 의미 문장으로 변환
   - V4 strength ("직접", "부분", "우회") → V4 종합 점수의 의미 문장으로 흡수

2. **커버리지 표현 금지**. "task 전반을 지원", "task 일부 커버" 금지.
   (커버리지 판단은 Skill 5 M4 설계 영역)

3. **V2는 breakdown + interpretation 쌍** 그대로 노출. caveats도 포함.

4. **Killer 탈락 task 미노출**. 남은 task 3개 미만일 때만 경고.

5. **고잠재력 저매칭 task** 구분 표시:
   - top3 안 (high_potential_low_match = true): 해당 task 안내 섹션에 "⚠ AI 전환 가치는 크지만 툴 매칭 약함. 재설계 검토 권장" + missed_feature_estimates 일부 공개 (confidence medium 이상만)
   - top3 밖 (notable_outside_top3): 별도 "주목할 task" 섹션으로 표시, 전체 rank 함께 기록

6. **복수 주제 쏠림 경고**: diversity_check.balanced = false인 경우 쏠림 주제 + 재실행 제안

7. **매칭 feature의 caveats 노출**: V4 matches의 각 항목에 `feature_caveats`가 null이 아니면 해당 feature 이름 아래에 `⚠ 참고: {feature_caveats}` 형식으로 표시.
   - 목적: LD가 실행 환경 제약(파일 업로드 불가·유료 플랜 한정 등)을 바로 인지하여 Skill 5(M4 설계)에서 대응 방식 판단
   - Skill 4는 input.json.security와의 실제 충돌 여부 판단하지 않음 (Skill 5 영역)
   - feature_caveats가 null인 매칭은 그대로 feature 이름만 표시 (⚠ 없음)

[출력 형식]
SKILL.md §"LD 출력 템플릿"을 그대로 따릅니다. 자연어 텍스트로 반환 (JSON 아님).

복수 툴이면 per_tool 블록마다 이 프롬프트를 반복 호출하여 각 툴별 LD 출력 섹션 생성.
```
