# Prompts: [F4] 대체 feature 선정

Plan v2 공정 1 (Tool Feature Factcheck) Step S4의 [F4] 대체 feature 선정 프롬프트 + tiebreaker 4단 규정.

## 호출 시점

[F2] criticality 판정 이후, `candidate_replacements`가 비어 있지 않거나 신규 조사로 후보를 확보했을 때.

## 입력

- criticality 출력의 후보 리스트 (`candidate_replacements`)
- tool-features.json 해당 툴 블록 전체
- 기존 fail feature 정보 (feature name, 등장 모듈)
- 등장 모듈 ID (m1/m2/m3/m4)
- 관련 task의 학습 목표 문구

## 조건 분기 규칙 (우선순위 순)

### STEP 1. tool-features.json 내 후보 점수화

같은 툴의 다른 features 중 criticality의 `candidate_replacements`에 포함된 것이 있으면 아래 기준으로 점수화.

**점수 구성**:

| 축 | 배점 | 기준 |
|---|---|---|
| task 학습 목표 적합도 | 5점 척도 | LLM 판단, rationale 필수 |
| caveats 없음 | +1 | 있으면 0 |
| description 구체성 | +0.5 | quote 가능한 예시 포함이면 +0.5 |
| 지역 한정 | 세분화 | 아래 참조 |

**지역 한정 세분화**:
- 한국 포함 (또는 한국이 배제된 구성) = **즉시 탈락**
- 한국 비대상 (한국에서 사용 가능) = 감점 없음, 정상 후보
- 한국 포함 여부 불명확 = 추가 검색 1회 후 재판정, 여전히 불명확 시 보수적으로 탈락

**LLM 호출 파라미터 (결정성 확보)**:

- `temperature`: 0
- `response_format`: `json_schema` (아래 `scored_candidates` 스키마 강제)
- 동일 입력 → 동일 점수 보장 (tiebreaker 이전 단계에서의 base_score 결정성 확보. 동점 발생 빈도 안정화)

**점수화 프롬프트 (LLM 호출)**:

```
[시스템]
너는 AI 교육 커리큘럼 설계자이다. 주어진 후보 feature들을 task 학습 목표 적합도 기준 5점 척도로 평가한다.
rationale에는 학습 목표 문구와 후보 feature의 연결을 구체적으로 서술한다.

[입력]
- 대체할 기존 feature: {old_feature_name}
- task 학습 목표: {learning_goal}
- task action: {task_action}
- 후보 리스트: [{candidate_1}, {candidate_2}, ...]
- 각 후보의 tool-features.json 정보: description, caveats, plan, region_restriction

[출력 JSON 스키마]
{
  "scored_candidates": [
    {
      "name": "...",
      "base_score": 1~5,
      "base_score_rationale": "...",
      "caveats_bonus": 0 | 1,
      "description_bonus": 0 | 0.5,
      "region_status": "ok" | "korea_excluded" | "ambiguous",
      "total_score": 0.0
    },
    ...
  ]
}
```

### ★ 동점 해소 Tiebreaker 4단 (v2 신설) ★

grep 키워드: `caveats 없음 > Plus`

후보 2개 이상의 `total_score`가 같은 경우 아래 순서대로 적용.

**1차 tiebreaker**: 학습 목표 적합도 (LLM 5점 척도) 점수가 높은 쪽.

**2차 tiebreaker**: **caveats 없음 > Plus 있음 > 베타 있음** 순.
- caveats "없음" 후보 승리.
- 둘 다 caveats 있으면: "Plus" 후보 > "베타/Experimental" 후보.

**3차 tiebreaker**: description 구체성.
- description 길이가 더 긴 쪽.
- 또는 quote 가능한 예시(코드/명령어 블록)를 포함한 쪽.

**4차 tiebreaker (안전장치)**: tool-features.json features 배열에서 **먼저 등장한 순**.
- 결정성 최종 보장 (같은 입력에 같은 순서 보장되는 유일 장치).

### selection_rationale 포맷

동점 발생 여부와 무관하게 최고점 후보 1개 선정 시 `selection_rationale`에 아래 형식으로 기록:

```
총점 A vs B = X점 vs Y점, {tiebreaker 적용 단계}에서 {근거}로 A 선정.
학습 목표 적합도 N점 + caveats 없음 +1 + description 구체성 +0.5 = 총점
```

**예시**:
- 동점 없음: `"총점 A vs B = 5.5 vs 4.0, 1차 평가에서 A 우위로 선정. 학습 목표 적합도 4점 + caveats 없음 +1 + description 구체성 +0.5 = 5.5"`
- 2차 tiebreaker 적용: `"총점 A vs B = 4.5 vs 4.5, 2차 tiebreaker(caveats 없음 > Plus)에서 A 승. A는 caveats 없음, B는 Plus 한정"`

### STEP 2. 신규 웹 검색 트리거

tool-features.json 내 후보 없음 or STEP 1의 최고점 후보가 0점일 때 발동.

**검색어 패턴**:
- `{tool_name} {task_keyword} feature`
- `{tool_name} how to {task_action}`

**공식 소스 우선** (clarify §4.2 + 한국어 도메인 공식 소스 판정 규칙 5항, rubric.md 참조).

발견된 신규 후보에 대해 [F1] 시그널 판정 → pass/flag이면 채택, fail이면 STEP 3.

### STEP 3. 2회 실패 후 LD 선택지 제공

STEP 1·2 모두 실패 (후보 없음 or 전부 fail)이면:
- 루프 횟수 +1 후 재시도 (최대 2회).
- 2회 초과 시 [F3] Level 4 트리거 + LD 선택지 제공:

```
⚠ {tool_name}의 {feature_name} 대체가 2회 시도 후에도 실패했습니다.
criticality 판정: {criticality} — {rationale}

선택지:
1. 이 feature 포기 (해당 모듈에서 feature 참조 삭제, 실습 축소)
2. task 교체 (Skill 4 후퇴 — 전체 파이프라인 일부 재실행)
3. 실습 수동 재설계 (LD가 직접 수정)
```

## 판정 비대칭 반영

- 대체 후보에도 "애매하면 보수적 탈락" 적용 (clarify §3.1).
- false positive 방지: 대체 후보의 caveats·지역·플랜 제한 철저 검증.
- 지역 불명확은 재검색 후에도 보수적 탈락 (STEP 1 지역 세분화 참조).

## 결과 병합

선정된 후보를 `replacement_candidate` 필드에 기록:

```json
{
  "replacement_candidate": {
    "name": "...",
    "source": "tool-features.json" | "new_web_search",
    "selection_rationale": "총점 A vs B = 5.5 vs 4.0, 1차 평가에서 A 우위로 선정. 학습 목표 적합도 4점 + caveats 없음 +1 + description 구체성 +0.5 = 5.5",
    "refactcheck_signal": "pass" | "yellow_flag",
    "refactcheck_sources": [...]
  }
}
```

## 수락 기준

- `replacement_candidate.source == "tool-features.json"`이면 해당 툴의 features 배열에 실제로 존재하는 name이어야 함 (name 검증).
- 동점 발생 시 `selection_rationale`에 tiebreaker 적용 단계 + 근거 명시 (기준 2 (C) rationale 구체성 통제).
- 지역 세분화 결과가 `region_status` 필드에 기록됨 (ok/korea_excluded/ambiguous).
- STEP 2 신규 웹 검색으로 발견된 후보는 [F1] 재factcheck 통과해야 채택.
