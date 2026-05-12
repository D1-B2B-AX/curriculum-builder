# Reconstruction Prompts (Level 1~3 + behavior_update_reflection)

Plan v2 공정 1 (Tool Feature Factcheck)의 Step S6에서 사용하는 재구성 프롬프트 템플릿.
본 템플릿은 `references/phase1-module-schema.md`를 참조한다.

## 공통 제약 (모든 Level)

- **생성된 v2.md는 원본 m{N}-{tool}.md의 헤딩 스키마를 유지한다.**
- 헤딩 레벨(`# / ## / ###`)과 헤딩 순서를 원본과 동일하게 유지한다.
- `references/phase1-module-schema.md`의 필수 헤딩 리스트(M1/M2/M3/M4)를 만족한다.
- 원본에 없던 헤딩을 임의로 추가하지 않는다. 원본 헤딩을 삭제하지 않는다.
- 본문(heading 사이 텍스트)만 재작성 대상이며, Level 2는 feature 명칭만 교체, Level 3는 실습 단계 텍스트만 재작성.
- task_name, 학습 목표 블록은 Level 3에서도 원본과 정확히 일치시킨다.

## Level 1 (M1/M2 경량 교체)

```
[시스템]
원본 모듈에서 feature "{old_feature}" 언급 블록을 "{new_feature}"로 치환한다.
본문 서술 외의 모든 헤딩·순서를 원본과 동일하게 유지한다.
원본 m{N}-{tool}.md의 헤딩 스키마를 유지한다.
references/phase1-module-schema.md의 M1 또는 M2 필수 헤딩 리스트를 만족한다.

[입력]
- 원본 모듈 md: {original_md}
- 신규 feature 정보: {new_feature_info} (tool-features.json 또는 신규 웹 검색 결과)

[출력]
원본과 동일한 헤딩 구조를 가진 v2.md. 본문만 치환.

[수락 기준]
- diff 범위가 feature 언급 블록에 한정된다 (헤딩 구조 변경 0건).
- heading_schema_preserved = true.
```

## Level 2 (M3/M4 feature만 교체)

```
[시스템]
원본 모듈의 실습 흐름(시나리오 step 수·순서, 학습 목표, task 내용)을 유지한다.
feature "{old_feature}"를 "{new_feature}"로 교체하되 해당 feature 등장 지점의
본문은 동일 의미로 재서술할 수 있다. 새 feature의 사용 방식이 이전과 다르면
해당 step 내부 문구를 조정하나, step 수·순서 자체는 원본과 동일하게 유지한다.
원본 m{N}-{tool}.md의 헤딩 스키마를 유지한다.

[제약 — 모듈 유형별]
- **공통**: 원본 헤딩 스키마 유지 (공통 제약 + phase1-module-schema.md 참조).
- **M4 재구성 시**:
  - `## 실습 시나리오` 내부 **numbered list step 수는 원본과 동일** (정규식 `^\s*\d+\.\s+\*\*` 카운트 기반).
  - M4 타이틀 `# M4 메인 실습 — {task_one_liner} ({tool_name})`의 `{task_one_liner}` 부분 **불변**.
  - `## 학습 목표` 섹션 본문 **불변**.
  - `## 실습 task 선정 근거` 상단 "**선정**: Top {rank} — `{task_one_liner}`" 문구 **불변**.
  - `## 사용 feature 목록` 표에서 `{old_feature}` 행을 `{new_feature}` 행으로 교체 (표 행 수 자체는 유지).
- **M3 재구성 시**:
  - `## 기초 실습 시나리오` 하위 **`### 실습 N` 서브헤딩 수는 원본과 동일**.
  - 해당 feature의 `### 실습 N: {old_feature} 기초` 서브헤딩은 `### 실습 N: {new_feature} 기초`로 교체.
  - `## 학습 목표` 섹션 본문 **불변**.
  - `## M4와의 연결` 섹션의 feature 목록에서 `{old_feature}`를 `{new_feature}`로 교체 (M4와 동기화).

[수락 기준]
- 헤딩 구조 원본과 동일 (heading_schema_preserved=true).
- M4 step 수 변화 0건 / M3 서브헤딩 수 변화 0건.
- 학습 목표·task 블록 원본과 바이트 일치.
```

## Level 3 (M3/M4 실습 세부 재작성)

```
[시스템]
원본 모듈의 학습 목표·task 내용은 불변. 실습 시나리오 내부의 step 본문을
"{new_feature}" 기준으로 재작성한다. task 자체 교체가 필요하면 Level 4로
escalate (본 Level에서는 task 불변 전제).
원본 m{N}-{tool}.md의 헤딩 스키마를 유지한다.

[제약 — 모듈 유형별]
- **공통**: 원본 헤딩 스키마 유지 (공통 제약 + phase1-module-schema.md 참조).
- **M4 재구성 시**:
  - 타이틀의 `{task_one_liner}` 부분 **불변**.
  - `## 학습 목표` 섹션 본문 **정확히 일치**.
  - `## 실습 task 선정 근거` 상단 "**선정**: Top {rank} — `{task_one_liner}`" 문구 **정확히 일치**.
  - `## 실습 시나리오` 내부 numbered list 본문 재작성 가능. step 수는 원본 유지 권장이나 변경 가능(변경 시 `level_selection_basis`에 근거 필수 — 예: "신규 feature는 단일 호출로 이전 2개 step 통합 가능").
  - `## 사용 feature 목록` 표와 `## 예상 산출물` 본문은 새 시나리오에 맞춰 갱신 가능.
- **M3 재구성 시**:
  - `## 학습 목표` 섹션 본문 **정확히 일치**.
  - `## 기초 실습 시나리오` 하위 각 `### 실습 N: {feature_name} 기초` 블록의 "학습 포인트 / 사용 feature / mini 입력 / 행동 / 결과 확인 / M4 연결" 본문 재작성 가능.
  - `### 실습 N` 서브헤딩 수는 M4의 "사용 feature 목록" 행 수와 동일 유지 (역산 원칙).
  - `## M4와의 연결` 섹션이 새 M4의 feature 구성과 동기화되었는지 확인.

[수락 기준]
- 헤딩 구조 원본과 동일.
- 학습 목표·task 블록 바이트 일치.
- step 수 변경이 있으면 replacement_plan.level_selection_basis에 근거 문장 존재.
```

## behavior_update_reflection (STEP 8 경량 반영)

```
[시스템]
feature name은 유지. change_delta 내용만 본문에 반영한다.
원본 m{N}-{tool}.md의 헤딩 스키마를 유지한다.

[제약 — 공통]
- 원본 헤딩 스키마 유지.
- feature name 불변, 실습 골자·학습 목표 불변.
- change_delta의 핵심 명사구(3단어 이상 연속 일치) 최소 1개를 본문에 삽입.

[제약 — 모듈 유형별 삽입 위치]
- **M4 적용 시**: `## 실습 시나리오` 내부 numbered list 중 해당 feature 등장 step의 "행동" 또는 "결과 확인" 본문, 또는 `## 사용 feature 목록` 표의 "활용 방식" 열에 change_delta 반영.
- **M3 적용 시**: `### 실습 N: {feature_name} 기초` 블록의 "학습 포인트" 또는 "행동" 본문에 change_delta 반영.
- **M1 적용 시**: `## 사용된 feature 상세 (꼭지 3의 근거 자료)` 표의 "요약 설명" 열 또는 "caveats" 열에 change_delta 반영.
- **M2 적용 시**: `## 배경 근거 (LD 검토용)` 하위 `### Why — 스코어링 근거 요약`의 해당 feature 줄 또는 feature_caveats "※ 참고" 인접 위치에 반영.

[수락 기준]
- feature name 원본과 일치.
- change_delta 핵심 명사구 3단어 이상 연속 일치 문구가 v2.md 본문에 존재 (grep 기반 검증 가능).
- 헤딩 구조 원본과 동일.
```

## 프롬프트 호출 파라미터

- **temperature**: 0.3 (약간의 창의성 필요, 하지만 결정성 우선)
- **response_format**: text (본문 생성이라 json_schema 아님)
- **max_tokens**: 원본 모듈 길이 × 1.5 정도 여유

재구성된 본문은 S6 수락 기준(헤딩 diff 0건 / step 수 보존 / task 블록 바이트 일치)을 통과해야 한다. 위반 시 재생성 1회 시도 후 실패하면 LD 선택지로 에스컬레이션.
