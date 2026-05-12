# Rubric: Tool Feature Factcheck 분석 프레임워크 [F1]~[F4]

Plan v2 공정 1 (Tool Feature Factcheck)의 Core 본질인 4개 프레임워크의 **조건 분기 규칙**.
품질 형용사("적절히", "잘") 금지. 모든 분기는 `IF X → Y` 형태의 결정 가능한 규칙.

## 판정 비대칭 원칙 (최상위 규약)

- **false positive > false negative**: "있는데 없다고 판정" (false negative)보다 "없는데 있다고 판정" (false positive)이 더 위험. 애매하면 보수적으로 탈락 처리.
- **단 과잉 탈락도 경계**: 애매하면 무조건 탈락 금지. 아래 4가지 경우는 pass 경로 유지:
  - 동작 일부 변경 = STEP 8로 yellow flag (탈락 아님) — 실습에 변경 반영
  - 업데이트 기록 부재 ≠ 자동 결함 = STEP 6-a로 pass 가능 — 공식 문서가 현재형으로 기술되고 task 정합 OK면 그대로 사용
  - 지역 제한 명시되어도 한국 비대상이면 = STEP 3-b로 통과 — 국내 교육 현장에서 사용 가능
  - 공식 소스 애매 = STEP 2-5로 type="ambiguous" → yellow_flag (수동 검증 권장) — 자동 탈락 아님
- STEP 9(가장 애매한 케이스 - 이름·동작 불일치까지)만 보수적 탈락.

## 시점 2축 검증 원칙

모든 시그널 판정 시 2개 날짜를 **별도로** 기록:
1. **글 작성일 (content_date)**: 글 자체의 publish date
2. **feature 출시/최종 업데이트일 (feature_release_date)**: 본문에서 추출

"2026년 글이지만 2023년 feature를 현재처럼 소개" = 시점 불일치 → 추가 검색으로 최신 상태 재확인 (6개월 경과 여부는 **feature 기준일**로 판정).

단 **업데이트 부재 자체는 결함이 아님** (STEP 6-a 참조): 장기 안정 기능은 최종 업데이트가 오래될 수 있음. 공식 문서가 현재형으로 기술 + task 정합 OK면 pass.

---

# [F1] 시그널 판정 프레임워크

**입력**: feature name + 웹 검색 결과 (공식/준공식/2차 소스 URL + 발췌 텍스트 + 공개일 + feature 출시/최종 업데이트 시점)

**조건 분기 규칙**:

```
STEP 1. 공식 소스에서 "deprecated" 또는 "sunset" 또는 "discontinued" 명시 발견
  → 시그널 A (탈락 필수, verdict=fail)

STEP 2. 공식 소스·준공식 소스 어디에도 feature name이 등장하지 않음
  (공식 검색어 3개 시도 후에도 미발견: 공식 help/docs, changelog, blog/newsroom)
  → 시그널 A (탈락 필수, verdict=fail)
```

### ★ 공식 소스 판정 기준 — 기본 4종 + 한국어 도메인 공식 소스 판정 5항 ★

**기본 4종** (clarify §4.2):
- (i) 공식 도메인 (help/docs 포함)
- (ii) 공식 blog / newsroom
- (iii) 인증된 공식 소셜 계정 (X/LinkedIn 인증 마크)
- (iv) 인증된 CEO/제품 책임자 개인 계정

**한국어 도메인 공식 소스 판정 규칙 5항** (grep 키워드: `한국어 도메인 공식 소스`):

1. **회사 공식 도메인**: `{회사}.com`, `{회사}.co.kr` 등 회사 공식 도메인은 기본 공식 (sources[].type="official").

2. **플랫폼 기반 블로그/커뮤니티**: `blog.naver.com/{userId}`, `cafe.naver.com/{groupId}`, `tistory.com/{userId}`, `medium.com/{userId}` 등은 **기본 비공식** (sources[].type="secondary"). 공식으로 인정하려면 아래 3조건 중 **최소 2개 충족** 필수:
   - (a) 운영자 명이 회사명·공공기관명과 일치 (예: "삼성전자 공식 블로그", "SK하이닉스 뉴스룸")
   - (b) 블로그 프로필에 "공식"/"official" 또는 회사 인증 마크 (네이버 블루뱃지 등)
   - (c) 회사 공식 홈페이지(.com/.co.kr)에서 해당 블로그 URL로 링크 존재 (즉 회사가 자사 채널로 인정)

3. **공공기관 블로그** (과기정통부, NIPA, KISA 등): 도메인이 `.go.kr` 또는 `.or.kr`이면 공식 (sources[].type="official"). 공공기관이 플랫폼 블로그(blog.naver.com 등)를 쓸 때는 위 2번 3조건 적용.

4. **CEO/제품책임자 개인 계정** (X/LinkedIn 등 clarify §4.2 기준 iv): 인증 마크 + 회사 공식 홈페이지에서 프로필 링크 존재 필수. 둘 다 충족하면 공식.

5. **애매한 경우 "ambiguous" 3차 카테고리** (v2.1 정정 — 과잉 탈락 방지):
   - 판정 비대칭 원칙을 유지하되 secondary로 즉시 탈락 처리하지 **않는다**.
   - sources에 `type="ambiguous"`, `ambiguity_note="공식 여부 판별 불가 — 수동 검증 권장"` 기록.
   - 자동 게이트 2는 official + ambiguous **모두 0건**일 때만 발동.
   - ambiguous가 1건 이상이면 `verdict=yellow_flag`, `flag_reason="공식 소스 판별 불가 — 수동 검증 권장"`으로 처리 (탈락 아님). LD 고지 §S8에서 "수동 검증 권장" 리스트로 분리 표시.

### sources[].type 4종 정의

| type | 정의 | ambiguity_note 기록 |
|---|---|---|
| `official` | 기본 4종 OR 한국어 도메인 1·3·4번 OR 플랫폼 블로그 2번 3조건 중 2개 이상 | null |
| `semi-official` | 회사 관계자 공식성 일부 확인 (인증 없으나 회사 언급 존재) | null |
| `secondary` | 개인 리뷰·블로그·커뮤니티 (공식성 없음 확정) | null |
| `ambiguous` | 공식 여부 판별 불가 (수동 검증 필요) | "공식 여부 판별 불가 — 수동 검증 권장" |

---

### [F1] STEP 3~9 계속

```
STEP 3. 공식 소스에 명시적으로 "지역 제한" 문구 발견
  → 제한 지역 목록 추출 → 한국 포함 여부 확인:
    - STEP 3-a. 제한 지역에 한국 포함 (또는 "Asia 제외", "US-only", "EEA-only" 등 한국이 배제된 것이 명확)
      → 시그널 C-지역 (탈락 필수, verdict=fail)
    - STEP 3-b. 제한되는 지역이 있으나 한국은 제한 대상 아님 (예: "유럽 일부 국가 미지원", "중국 미지원" 등 한국 비대상)
      → 본 단계에서 C-지역으로 판정하지 않고 STEP 4 이하 계속 진행
      → sources에 "지역 제한 있음 (한국 비대상)" 메모, region_note 필드에 기록
    - STEP 3-c. 제한 지역 명시는 있으나 한국 포함 여부 불명확
      → 추가 검색 1회 (`{tool_name} {feature_name} Korea availability`) 후 재판정
      → 여전히 불명확 시 보수적으로 C-지역 처리 (verdict=fail)

STEP 4. 공식 소스에 "Plus only" / "Pro only" / "Enterprise only" / "Beta" / "Experimental"
  → 시그널 C-플랜 (유지 + yellow flag, verdict=yellow_flag)
  → flag_reason = "Plus 플랜 한정" 또는 "Beta 한정" 등

STEP 5. 공식 소스에 등장 + **최근 업데이트 기록(`feature_release_date` 기준 6개월 내)** 존재 + 이름·동작 불변
  → 시그널 pass (green, verdict=pass)
  (6개월 판정 기준은 글 작성일 content_date가 아니라 feature 출시/최종 업데이트일 feature_release_date. 시점 2축 검증 원칙 참조)

STEP 6. 공식 소스에 등장하나 최근 업데이트 기록 부재 (최종 기록 6개월 이상 경과 또는 릴리즈 노트에 변경사항 없음) + 이름·동작 일치 + 공식 문서에 현재도 사용 가능하게 기술되어 있음
  → 업데이트 없음 ≠ 결함: 출시 후 안정적으로 유지되는 기능은 릴리즈 노트에 재등장하지 않을 수 있음. 다음 추가 체크로 분기:
    - STEP 6-a. 공식 문서가 현재 시점에도 현재형으로 기술 + "deprecated" 표시 없음 + task 정합 OK
      → 시그널 pass (green, verdict=pass) — 별도 flag 없음
      → sources에 stability_note = "장기 안정 기능, 최종 업데이트는 {YYYY-MM} 이후 부재" 메모
    - STEP 6-b. 공식 문서는 있으나 현재 사용 가능 여부가 불명확 (문서 마지막 수정일이 오래됨 + 최근 언급 부재)
      → 시그널 B + yellow flag (verdict=yellow_flag, flag_reason="최신 사용 가능 여부 확인 권장")
    - STEP 6-c. task 정합 불일치 or 애매
      → 시그널 B-2 (탈락, 대체 루프 진입, verdict=fail)

STEP 7. 공식 소스 1건만 있고 교차검증 2차 소스 없음
  → 시그널 D (유지 — 공식 확인만으로 충분, verdict=pass)
  → 교차검증 부재 사유를 flag에 기록하지 않음

STEP 8. 공식 소스에 등장 + 이름 동일 + 동작 일부 변경 (기능 추가/옵션 변경/UX 조정 등이지만 핵심 동작은 유지)
  → 시그널 B-변경감지 (유지 + yellow flag):
    - verdict = yellow_flag
    - flag_reason = "동작 일부 변경됨 — 변경 사항: {변경 내용}. 실습 설계에 반영 필요"
    - change_delta 필드에 변경 내용 명시 (다음 공정 또는 재구성 단계에서 실습에 녹일 수 있도록)
    - **탈락시키지 않음** — 동작 일부 변경은 실습 반영으로 처리 가능

STEP 9. STEP 1~8 어디에도 해당 안 함 (예: 공식 소스는 있지만 내용이 극히 모호하거나 이름도 동작도 설명과 일치하지 않음)
  → 시그널 B 보수 판정 (탈락, 대체 루프 진입, verdict=fail)
```

### [F1] 판정 결과 JSON 스키마

```json
{
  "tool": "...",
  "feature_name": "...",
  "signal": "A" | "B" | "B-변경감지" | "C-region" | "C-plan" | "D" | "pass",
  "verdict": "pass" | "yellow_flag" | "fail",
  "sources": [{
    "url": "...",
    "type": "official" | "semi-official" | "secondary" | "ambiguous",
    "content_date": "YYYY-MM-DD",
    "feature_release_date": "YYYY-MM-DD | null",
    "excerpt": "...",
    "stability_note": null | "장기 안정 기능, 최종 업데이트는 YYYY-MM 이후 부재",
    "ambiguity_note": null | "공식 여부 판별 불가 — 수동 검증 권장"
  }],
  "flag_reason": null | "Plus 플랜 한정" | "최신 사용 가능 여부 확인 권장" | "동작 일부 변경됨 — ..." | "공식 소스 판별 불가 — 수동 검증 권장" | "...",
  "change_delta": null | "{변경 내용 서술}",
  "region_note": null | "지역 제한 있음 (한국 비대상)" | "한국 포함 제한",
  "fail_reason": null | "...",
  "today_usable": true | false
}
```

---

## ★ 자동 게이트 1 (region_note 모순) ★

grep 키워드: `자동 게이트 1 한국 비대상`

- **발동 조건**: `region_note`가 "한국 비대상" 패턴을 포함하면서 `verdict=fail`인 항목.
- **처리**:
  1. warning 플래그 기록 (`consistency_warning="region_note=한국 비대상 AND verdict=fail"`)
  2. 해당 feature에 대해 [F1] 전체 재판정 트리거 **(1회 한정)** (같은 웹 검색 결과를 다시 프롬프트에 넣고 STEP 3-b 경로 엄수 지시)
  3. **1회 재판정 후에도** `verdict=fail`이면 **LD 선택지로 에스컬레이션** (loop_count 증가 없이 즉시):
     ```
     ⚠ 구조적 모순 감지: {tool_name}/{feature_name}은 한국 비대상 지역 제한임에도
       fail 판정되었습니다. LD 확인이 필요합니다.
     선택지: 1. 수동 검증 후 pass/yellow_flag로 승격 / 2. fail 확정 유지 (근거 기재)
     ```

## ★ 자동 게이트 2 (공식 소스 누락 — v2.1 완화) ★

grep 키워드: `자동 게이트 2 공식 소스 누락`

- **발동 조건 (v2.1 완화)**: `type="official"` 태깅 sources **0건** **AND** `type="ambiguous"` 태깅 sources **0건** (둘 다 없을 때만). `verdict`가 pass 또는 yellow_flag로 판정된 항목이 대상.
- **발동 시 처리**:
  1. verdict를 `fail`로 강제 전환
  2. `fail_reason="공식 소스 누락 (자동 게이트 2)"`로 기록
  3. replacement_queue로 이관 (S4에서 대체 루프 진입)
- **ambiguous 1건 이상인 경우 (v2.1 신설)**:
  - 자동 게이트 2 **미발동**
  - verdict를 `yellow_flag`로 전환 (기존 pass였던 경우)
  - `flag_reason="공식 소스 판별 불가 — 수동 검증 권장"` 기록
  - LD 고지 §S8에서 **"수동 검증 권장 feature" 리스트로 분리 표시** (탈락 아님)

---

# [F2] criticality 판정 프레임워크

**언제 호출**: 시그널이 탈락(A·C-지역·B-2) 판정된 feature에 대해 대체 루프 진입 직전.

**입력**: 해당 feature + 등장 모듈 (m1/m2/m3/m4 파일 내용) + top-tasks.json의 관련 task 블록 + tool-features.json

**LLM 호출 파라미터**:
- `temperature`: 0
- `response_format`: json_schema (아래 스키마 강제)
- 동일 입력 → 동일 출력 보장

**출력 JSON 스키마**:

```json
{
  "criticality": "non-critical" | "semi-critical" | "critical",
  "rationale": "구체 근거 2~4문장. '왜 그런가'를 학습 목표·task 구조 기반으로 설명",
  "level_decision": "level2" | "level3" | null,
  "level_decision_rationale": "level_decision의 근거 1~2문장",
  "candidate_replacements": ["tool-features.json 내 대체 후보 feature name 0~3개"],
  "_meta": {
    "changed_steps_ratio": 0.0
  }
}
```

**필드 설명**:
- `level_decision`:
  - non-critical → "level2" 고정
  - semi-critical → LLM 판정 ("feature 교체만으로 실습 골자를 유지할 수 있는가?" yes→level2 / no→level3)
  - critical → "level3" (loop<2) 또는 null (loop≥2로 Level 4 escalate)
  - **이 필드가 Level 결정의 단독 소스** (v2.1 정정).
- `level_decision_rationale`: Level 선택 근거. rationale의 부분집합 또는 독립 서술 모두 허용.
- `_meta.changed_steps_ratio`: 사후 검증용 **보조 메타데이터** (0.0~1.0 또는 null). v2.1 정정으로 **결정에 불개입**.

**criticality 정의 (프롬프트의 판정 질문)**:

> "이 feature를 제거하고 이 툴의 다른 feature만으로 같은 task를 다루는 실습을 설계 가능한가?"
>
> (a) **대체 가능 (non-critical)** — 이 툴의 다른 feature로 같은 task의 실습 구성 가능
>
> (b) **부분 대체 가능 (semi-critical)** — 다른 feature로 일부 단계는 대체 가능하나 실습 골자의 일부를 재설계해야 함
>
> (c) **대체 불가 (critical)** — 이 feature가 이 task 실습의 핵심이며, 다른 feature로는 같은 학습 목표를 달성 불가 → task 자체 교체 고려

---

# [F3] 재구성 깊이 자동 판정 프레임워크

**언제 호출**: criticality 판정 후, 대체 feature를 결정하기 직전.

**입력**: criticality 판정 + 해당 feature 등장 모듈 ID + 대체 후보 feature + 모듈 원본 내용 + [F2] 프롬프트 응답 (`level_decision`, `level_decision_rationale`, `_meta.changed_steps_ratio`)

**조건 분기 규칙**:

```
IF module_id == "m1" or module_id == "m2":
  → Level 1 (경량 — feature 포함 블록만 문자열 교체)
  → 다른 판정 없이 바로 진행 (clarify §3.6 "M1/M2는 경량")

ELIF module_id == "m3" or module_id == "m4":
  IF criticality == "non-critical":
    → Level 2 (부분 교체 — feature만 바꾸고 실습 골자 유지)

  ELIF criticality == "semi-critical":
    ★ Level 2 vs Level 3 단일 값 결정 규칙 (v2.1 — LLM 단독 결정) ★
    (grep 키워드: "부분 교체로 충분")

    [결정 규칙 — 단일 조건]
    [F2] 프롬프트 출력의 `level_decision` 값을 그대로 채택:
    - `level_decision == "level2"` → Level 2
    - `level_decision == "level3"` → Level 3
    - `level_decision == null` → 오류 (semi-critical인데 LLM 미응답)
      → [F2] 재호출 1회 후에도 null이면 보수적으로 Level 3 (false positive 방지 원칙)

    [결정성 확보]
    - [F2] LLM 호출 시 temperature=0 + response_format=json_schema로 강제 (§1.2 참조)
    - 동일 입력 → 동일 출력 보장
    - 문구 grep·step 비율 계산에 의존하지 않으므로 LLM 서술 스타일에 결과가 좌우되지 않음

  ELIF criticality == "critical":
    IF 대체 루프 시도 횟수 < 2:
      → Level 3 로 시도 (실습 전체 재설계, task는 유지)
      → 재factcheck 실패 시 다음 루프에서 Level 4
    ELSE (루프 2회 초과):
      → Level 4 (task 재선정) 판정 + LD 선택지 제공 트리거
```

### 보조 메타데이터 (사후 검증·관찰용, 결정에 불개입)

**`rationale_keyword_present: true/false` 플래그** 기록 규정:

- [F2] 출력의 `rationale`에 허용 동의 표현 3개 중 1개 이상 포함되었는지 grep 결과:
  1. "부분 교체로 충분"
  2. "경량 수정 가능"
  3. "feature 교체만으로 실습 성립"
- **Level 결정에는 영향 없음** — `level_decision` 단독 채택 원칙.
- Validation v2 기준 2 (C) **rationale 구체성 서브 체크의 보조 신호**로만 기록.
- Plan v2 §1.3에 위 3개 표현이 grep 가능한 문자열로 출현하여 Validation v2 활성화 스위치 조건 유지 (validation-v2.md 기준 2 (A)·(C) 활성화 grep).

**`_meta.changed_steps_ratio`** (0.0~1.0 또는 null):
- [F2] 응답의 보조 비율. 실습 step 중 교체 시 수정 필요한 비율.
- **30% 이하/초과 자체는 결정에 불개입**. 차후 분포 관찰 후 재검토용 관찰 지표.

### Level 정의 (clarify §3.5 단계적 fallback과 1:1 매핑)

- **Level 1**: 기능만 대체, 실습 내용 변경 없음 (M1/M2 전용)
- **Level 2**: feature 교체 + 실습 유지 (M3/M4, non-critical 또는 semi-critical 중 "부분 교체로 충분")
- **Level 3**: 실습 세부 순서·내용 재작성 (M3/M4, semi-critical 중 "실습 세부 재작성 필요" 또는 critical 1차 시도)
- **Level 4**: task 재선정 (Skill 4 후퇴 — 본 공정 내에서 수행 안 함. LD 선택지 제공)

---

# [F4] 대체 feature 선정 프레임워크

**언제 호출**: criticality의 `candidate_replacements`가 비어 있지 않거나, 신규 조사로 후보를 확보했을 때.

**입력**: criticality 출력의 후보 리스트 + tool-features.json 해당 툴 블록 + 기존 fail feature 정보 + 등장 모듈 ID

**조건 분기 규칙 (우선순위 순)**:

```
STEP 1. tool-features.json 내 같은 툴의 다른 features 중 criticality의 candidate_replacements에 포함된 것이 있음
  → 후보 점수화:
    - task 학습 목표 적합도 (LLM 판단: 5점 척도, rationale 필수)
    - caveats 없음 = +1 / Plus/베타 있음 = 0
    - 지역 한정 있음 → 제한 지역 확인:
      · 한국 포함(또는 한국이 배제된 구성) = 즉시 탈락
      · 한국 비대상 (한국에서 사용 가능) = 감점 없음, 정상 후보
      · 한국 포함 여부 불명확 = 추가 검색 1회 후 재판정, 여전히 불명확 시 보수적으로 탈락
    - description 구체성 (quote 가능) = +0.5
```

### ★ 동점 해소 Tiebreaker 4단 (v2 신설) ★

grep 키워드: `caveats 없음 > Plus`

후보 2개 이상의 총점이 같은 경우 아래 순서대로 적용:

1. **1차 tiebreaker**: 학습 목표 적합도 (LLM 5점 척도) 점수가 높은 쪽.
2. **2차 tiebreaker**: **caveats 없음 > Plus 있음 > 베타 있음** 순 (caveats "없음" 후보 > caveats "Plus" 후보 > caveats "베타/Experimental" 후보).
3. **3차 tiebreaker**: description 구체성 (길이 · quote 가능한 예시 포함 여부).
4. **4차 tiebreaker (안전장치)**: tool-features.json features 배열에서 먼저 등장한 순 (결정성 최종 보장).

→ 최고점 후보 1개 선정 → 재factcheck [F1] 돌입.
→ `selection_rationale`에 **"총점 A vs B = X점 vs Y점, {tiebreaker 적용 단계}에서 {근거}로 A 선정"** 형태로 **점수 분해를 명시적으로 기록** (기준 2 (C) rationale 구체성 통제).

### [F4] STEP 2~3

```
STEP 2. tool-features.json 내 후보 없음 or STEP 1의 최고점 후보가 0점
  → 신규 웹 검색 트리거 (동일 툴 내 해당 task 적합 feature 탐색):
    검색어 패턴: "{tool_name} {task_keyword} feature" / "{tool_name} how to {task_action}"
    공식 소스 우선 (clarify §4.2 + 한국어 도메인 공식 소스 판정 규칙 5항)
  → 발견된 신규 후보에 대해 [F1] 시그널 판정 → pass/flag이면 채택

STEP 3. STEP 1·2 모두 실패 (후보 없음 or 전부 fail)
  → 루프 횟수 +1 후 재시도 (최대 2회)
  → 2회 초과 시 [F3] Level 4 트리거 + LD 선택지 제공

[판정 비대칭 반영]
- 대체 후보에도 "애매하면 보수적 탈락" 적용 (clarify §3.1)
- false positive 방지: 대체 후보의 caveats·지역·플랜 제한 철저 검증
```

### [F4] 결과 병합 JSON 스키마

```json
{
  "feature_name": "...",
  "criticality": "non-critical" | "semi-critical" | "critical",
  "criticality_rationale": "...",
  "level_decision": "level2" | "level3" | null,
  "level_decision_rationale": "...",
  "reconstruction_level": 1 | 2 | 3 | 4,
  "level_selection_basis": "LLM level_decision='level2' (근거: {level_decision_rationale 요약})"
                         | "LLM level_decision='level3' (근거: {...})"
                         | "M1/M2 강제 Level 1 (LLM level_decision 무시)"
                         | "non-critical 강제 Level 2"
                         | "critical loop<2 → Level 3" | "critical loop≥2 → Level 4",
  "rationale_keyword_present": true | false,
  "_meta_changed_steps_ratio": 0.0,
  "replacement_candidate": {
    "name": "...",
    "source": "tool-features.json" | "new_web_search",
    "selection_rationale": "총점 A vs B = X점 vs Y점, {tiebreaker 단계}에서 {근거}로 A 선정. 학습 목표 적합도 N점 + caveats 없음 +1 + description 구체성 +0.5 = 총점"
  },
  "loop_count": 0
}
```

---

## 공통 수락 기준 (Core Step 의미 체크)

- verdict 결정이 [F1]의 조건 분기 9단계와 **일치**해야 함.
- criticality 판정이 [F2] 프롬프트 출력과 일치하고 rationale이 학습 목표·task 구조를 근거로 함 (빈 문자열·추상 표현만 있으면 fail).
- reconstruction_level이 [F3] 조건 분기표와 일치. semi-critical은 [F2]의 `level_decision` 값으로 **단독 결정**.
- [F2] LLM 호출 시 temperature=0 + response_format=json_schema 적용 확인.
- replacement_candidate.source가 "tool-features.json"이면 해당 툴의 features 배열에 실제로 존재하는 name이어야 함.
- 동점 발생 시 selection_rationale에 tiebreaker 적용 단계 + 근거 명시.
