---
name: skill-curriculum-final
description: curriculum-builder Phase 2의 네 번째 공정. 공정 3 산출(short-refined.md·long-refined.md + meta-refined.json)을 받아, 모듈별 LD 설명 4건(M1·M2·M3·M4 각 5-7줄 산문체)을 작성하여 LD가 받는 최종 단일 문서 curriculum-final_{company}_{role}_{timestamp}.md를 합성한다. 표 본체는 공정 3 산출 그대로 보존(글자 단위), LD 설명만 추가. 메타 흡수 통합과 본 도구 메타 워딩 필터링 의무. 합성 1 + 평가 1 = 2 LLM 호출. Sonnet 시작(퀄리티 불안 시 Opus). GAS 2회 POST(Phase 2 도달 + 조건부 Phase 3 진입 의도).
---

# Phase 2 공정 4: Curriculum-Final

curriculum-builder Phase 2의 네 번째이자 마지막 공정. 공정 3 산출(`short-refined.md`·`long-refined.md` + `short-meta-refined.json`·`long-meta-refined.json`)을 1차 source로 받아, **모듈별 LD 설명 4건**(M1·M2·M3·M4 각 5-7줄 산문체)을 작성하고 LD가 받는 단일 최종 문서 `curriculum-final_{company}_{role}_{timestamp}.md`로 합성한다.

표 본체(공정 3 산출의 short·long 표)는 **글자 단위 그대로 보존**, LD 설명만 추가한다. 모듈 구성 설명 산문체와 메타 흡수 통합이 본 공정의 핵심이다.

---

## 본 공정의 위치

| 단계 | 산출 |
|---|---|
| Phase 1 | curriculum.md (Phase 1 조합 산출 — LD 친화 spec 표준) |
| ↓ | |
| 공정 1 (factcheck) | factcheck-result.json + m{N}-{tool}.v2.md (영향 모듈만) |
| ↓ | |
| 공정 1 후속 (curriculum-rebuild) | `phase2/factcheck/curriculum-post-factcheck.md` ★ 항상 생성 (변경 0건이면 curriculum.md 복사 + 헤더 갱신·llm_generated 또는 copy_only 분기) |
| ↓ | |
| 공정 2 (hours-blocks) | `phase2/blocks/{short.md, long.md, short-meta.json, long-meta.json}` |
| ↓ | |
| 공정 3 (block-refinement) | **`phase2/block-refinement/{short-refined.md, long-refined.md, short-meta-refined.json, long-meta-refined.json}`** |
| ↓ | |
| **공정 4 (curriculum-final) ← 본 공정** | **`{run_folder}/curriculum-final_{company}_{role}_{timestamp}.md`** (run_folder 직속·LD가 받는 최종본) + `{run_folder}/phase2/curriculum-final-meta/{final-result.json, self-check-result.json}` (부속 메타·검증 자료) |

| 항목 | 영역 |
|---|---|
| 1차 input | `phase2/block-refinement/short-refined.md` · `long-refined.md` · `short-meta-refined.json` · `long-meta-refined.json` |
| 보조 input | `phase2/factcheck/curriculum-post-factcheck.md` (source 우선순위 1순위 직접 참조용) · `input.json` |
| LLM 호출 | 합성 1 + 평가 1 = **총 2회** (Sonnet 시작) |
| 최종 산출 | `curriculum-final_{company}_{role}_{timestamp}.md` (LD가 받는 유일한 메인 문서. 동일 회사·직무 재실행 시 timestamp로 구분) |
| 합성 단위 | 단일 chunk — 4 모듈(M1·M2·M3·M4) 동시 합성. 통합 산문 4건(short·long 차이를 한 산문 안에서 자연 서술) |
| 분량 | 모듈별 5-7줄 산문체 권장 (soft. 너무 짧거나 너무 긴 경우만 검출) |

---

## 본 공정의 사명

curriculum-builder 사명 4 미션 중 **(3) 톤앤매너 정합** + **(4) LD 친화 설명** 담당. 단 본 공정은 **모듈 구성 설명 산문체 + 메타 흡수 통합**만 처리한다 — 표 bullet은 공정 3 산출 그대로 보존(글자 단위 일치 의무).

### 공정 3과의 분담

| 공정 | 담당 |
|---|---|
| 공정 3 | 표 bullet 워딩만 정정 (LD 친화 spec 정합) |
| **공정 4 (본)** | **모듈 구성 설명 산문체 + 메타 흡수 통합 + 정직성 라벨 차등 처리** |

### 톤앤매너 source — Phase 1 조합 spec + `curriculum.md` 모듈 구성 설명 산문체 패턴 (한 묶음)

| source | 차용 부분 |
|---|---|
| skill-phase1-curriculum-assembly + `curriculum.md` 모델 | **모듈 구성 설명 산문체 패턴만** 차용 (3-5줄 산문체. 본 공정은 5-7줄로 약간 풍부 — 공정 2·3 부연 흡수 통합 분량). §"Bullet 작성 원칙"은 표 bullet 영역 spec이라 본 공정 산문체에 직접 적용 X |

### BGF리테일 제안서 — 본 공정 차용 X

본 공정은 산문체 합성이므로 BGF의 bullet 짧은 명사구 패턴은 **차용하지 않는다**. BGF 차용은 표 bullet 영역(공정 3) 전용. 본 공정 산출에 BGF 영역(4 컬럼·실습 마커·sub 시수·교육 목표·짧은 명사구) 어느 것도 박지 X.

★ 본 공정과 공정 3의 차이 명확화: 공정 3 = 표 bullet 워딩 정정(BGF + curriculum.md 두 source 차용) / 본 공정 = 모듈 구성 설명 산문체(curriculum.md 산문체 패턴만 차용·BGF X).

### 핵심 의도

- LD 검토용 표준 spec 정합 — 모듈별 LD 설명이 산문체로 자연 한국어·풀어쓰기·LD 친화
- 표 본체는 공정 3 산출 그대로 보존 (글자 단위 일치 의무 — 게이트 a)
- 메타 영역(공정 2 부연 메모·공정 3 observations·정직성 라벨) 흡수 통합 + 본 도구 메타 워딩 필터링
- 정직성 라벨(short_equivalent / expanded) 차등 처리 — short_equivalent 모듈은 3 요소(정직성 표시·확장 어려움 사유·절감 시간 활용 제안) 자연 포함 의무

### source 우선순위 (모듈 LD 설명 합성 시)

| 순위 | source | 용도 |
|---|---|---|
| 1순위 | `phase2/factcheck/curriculum-post-factcheck.md` 모듈 구성 설명 (공정 1 후속 산출) | LD 친화 산문체 표준. 5-7줄 산문체 풀이의 기본 토대 |
| 2순위 | 공정 2 부연(`phase2/blocks/short-meta.json`·`long-meta.json`의 `module_labels`·`observations`) — 공정 3 산출에 자연 흡수됨 | 시수 풍부화·정직성 라벨·long expanded 사유 등 공정 2 발생 부분 |
| 3순위 | 공정 3 부연(`phase2/block-refinement/short-meta-refined.json`·`long-meta-refined.json`의 `observations`·`moved_to_annotation_memo`) | 공정 3 워딩 정정 사례·이동된 부연(필터링 후) |

★ **부연설명이 필요한 부분만 추가** — 1순위(curriculum-post-factcheck.md 모듈 구성 설명)를 기본 토대로 하고, 공정 2·3 발생 부분만 흡수 통합. 공정 2·3 메타가 없으면 1순위 그대로 차용해도 OK.

---

## Input

| 파일 | 읽는 부분 | 용도 |
|---|---|---|
| `phase2/block-refinement/short-refined.md` | 표 short 본체 | 표 본체 보존 (글자 단위) |
| `phase2/block-refinement/long-refined.md` | 표 long 본체 | 표 본체 보존 (글자 단위) |
| `phase2/block-refinement/short-meta-refined.json` | observations·moved_to_annotation_memo | 메타 흡수 통합 (3순위 source) |
| `phase2/block-refinement/long-meta-refined.json` | observations·moved_to_annotation_memo·정직성 라벨 | 메타 흡수 통합 (3순위 source) |
| `phase2/factcheck/curriculum-post-factcheck.md` (보조) | 모듈 구성 설명 산문체 | source 우선순위 1순위 — LD 친화 산문체 표준 |
| `input.json` | company·role·tools·topic | 생성 정보 헤더 |

★ 공정 2 부연(`phase2/blocks/{short-meta.json, long-meta.json}`)의 핵심 영역은 공정 3 산출 `*-meta-refined.json`에 자연 흡수됨 — 별도 read 불필요.

---

## Output (산출 3건)

| 파일 | 형태 | 부분 |
|---|---|---|
| **`{run_folder}/curriculum-final_{company}_{role}_{timestamp}.md`** ★ **run_folder 직속** (LD가 폴더 열면 바로 보임) | md (LD가 받는 유일한 메인 문서. timestamp = YYYYMMDDHHMM 12자리. 동일 회사·직무 재실행 시 timestamp로 구분) | 표 short + 표 long + 모듈별 LD 설명 4건 |
| `{run_folder}/phase2/curriculum-final-meta/final-result.json` | JSON (부속 메타·검증 자료 — LD가 안 봐도 됨) | 메타데이터 + 게이트 결과 + 호출 통계 + chunk-extraction·synthesis·evaluation 통합 |
| `{run_folder}/phase2/curriculum-final-meta/self-check-result.json` | JSON (부속 메타·검증 자료) | 자체 검증 12 항목 결과 |

★ **`curriculum-final_*.md`는 `phase2/` 안이 아니라 run_folder 직속에 저장한다.** 부속 json 2건만 `phase2/curriculum-final-meta/`에 (폴더 이름에 `-meta` — 이 폴더가 최종본이 아니라 메타 자료임을 명시).

### `curriculum-final_{company}_{role}_{timestamp}.md` 구조

```
# {company} {role} — AI 교육 커리큘럼

> 생성 정보
> - 회사·직무: {company} / {role}
> - 주제: {topic}
> - 대상 툴: {tools comma join}
> - 시수 기준: long = M1·M2 2h / M3·M4 4h, 총 12h / short = 총 6h
> - 생성일: {YYYY-MM-DD}

## 커리큘럼 개요

{company} {role}을 위한 "{topic}" 교육 커리큘럼. 본 커리큘럼은 {tools} 툴을 다루며, 각 툴별로 M1(툴 소개) → M2(When/Why) → M3(기초) → M4(메인 실습) 구조로 구성되어 있다. LD가 이를 하나의 통합 과정으로 묶을지 별도 과정으로 운영할지는 교육 설계에 따라 결정.

---

## [{tool_1}]

### 커리큘럼 표 — long (12h)

{공정 3 산출 phase2/block-refinement/long-refined.md의 [{tool_1}] 표 long 그대로 복사}

### 커리큘럼 표 — short (6h)

{공정 3 산출 phase2/block-refinement/short-refined.md의 [{tool_1}] 표 short 그대로 복사}

### 모듈별 LD 설명

- **M1 ({tool_1} 소개) — short {Nh} / long {Nh} ({short과 long 차이 라벨})**: {5-7줄 산문체. M1 사명 = 도구 유형·기능 카테고리 풀이. short·long 차이를 한 산문 안에서 자연 서술. expanded면 차이 본질 + 학습 활동 차원 사유, short_equivalent면 3 요소(정직성 표시·확장 어려움 사유·절감 시간 활용 제안) 자연 포함}

- **M2 (활용 맥락) — short {Nh} / long {Nh} ({라벨})**: {5-7줄 산문체. M2 사명 = When·Why 풀이. AI 전환 가치·툴 적합성·직무 중요도 근거를 의미 문장으로 풀어쓰기 (수치·라벨 직접 노출 X — 공정 2·3 SKILL.md M2 spec 정합). LD가 자기 업무 흐름 위에서 task 비중을 인지하는 부분}

- **M3 (기초 실습) — short {Nh} / long {Nh} ({라벨})**: {5-7줄 산문체. M3 사명 = M4 역산 mini 흐름·feature 선정 근거·learning method. M4-M3 역산 원칙 정합}

- **M4 (메인 실습) — short {Nh} / long {Nh} ({라벨})**: {5-7줄 산문체. M4 사명 = task 흐름·사용 feature·산출물. expanded면 long 추가 영역 본질}

---

## [{tool_2}]

(동일 구조 반복)

---

(tools 배열 길이만큼 반복)
```

★ "다음 단계" 섹션 박지 X — Phase 3 진입 의도는 LD 고지(CC 대화창)에서 안내. 산출 문서 자체에는 표·LD 설명·생성 정보·개요만.

---

## 공정 3 → 공정 4 인계 점검 (Shell 차원·LLM X)

### 인계 점검 5 항목

1. **공정 3 산출 정합** — `phase2/block-refinement/short-refined.md`·`long-refined.md` 모두 존재
2. **`short-meta-refined.json`·`long-meta-refined.json` 산출 정합** — 정직성 라벨(`module_labels.{m1|m2|m3|m4}`)·`observations` 영역 존재
3. **공정 1 영향 흡수 영역 정합** — `curriculum-post-factcheck.md` 존재 (보조 input. 없으면 원본 `curriculum.md`로 fallback)
4. **input.json 정합** — `company`·`role`·`tools`·`topic` 필드 존재
5. **메인 .omc/prd.json 무손상** — 시작 head 비교 (CLAUDE.md PRD 분리 원칙 정합)

★ 인계 점검 fail 시 즉시 중단. Case A(LD 조치 가능)·Case B(시스템 오류) 분기.

---

## 실행 흐름 (2 LLM 호출)

```
Step 1 [Shell]: 인계 점검 + input read (LLM 호출 X)
  ↓
Step 2 [Core·LLM 호출 1]: 단일 chunk 4 모듈 LD 설명 동시 합성 (Sonnet)
  ↓ in-memory: synthesis-result
Step 3 [Check·LLM 호출 2]: 자체 검증 6 게이트 평가 (Sonnet — 약한 회피·별도 컨텍스트·prompt)
  ↓
Step 4 [Shell]: curriculum-final.md 합성 + final-result.json·self-check-result.json 작성 + GAS POST 1 + LD 고지 (LLM 호출 X)
  ↓ (LD "예" 답변 시)
Step 5 [Shell]: GAS POST 2 (조건부)
```

**총 LLM 호출 = 2** (합성 1 + 평가 1).

---

## Step 1 [Shell]: 인계 점검 + input read (LLM 호출 X)

1. 공정 3 산출 4건 정합 점검 (위 인계 점검 5 항목)
2. input read:
   - `phase2/block-refinement/short-refined.md`·`long-refined.md` (표 본체)
   - `phase2/block-refinement/short-meta-refined.json`·`long-meta-refined.json` (메타)
   - `phase2/factcheck/curriculum-post-factcheck.md` (보조 — 1순위 source)
   - `input.json` (생성 정보)
3. 표 short·long 본체를 in-memory로 보존 — Step 4에서 그대로 복사

---

## Step 2 [Core·LLM 호출 1]: 단일 chunk 4 모듈 LD 설명 동시 합성 (Sonnet)

### 합성 LLM prompt 구조

```
[작업]
4 모듈(M1·M2·M3·M4)의 LD 설명을 동시 작성한다.
각 모듈 5-7줄 산문체. short·long 차이를 한 산문 안에서 자연 서술.

[source 우선순위]
1순위: curriculum-post-factcheck.md 모듈 구성 설명 — 산문체 표준
2순위: 공정 2 부연 (short-meta-refined.json·long-meta-refined.json observations에 흡수)
3순위: 공정 3 부연 (short-meta-refined.json·long-meta-refined.json moved_to_annotation_memo·observations)
부연설명이 필요한 부분만 1순위에 추가.

[정직성 라벨 차등]
- expanded 모듈: 모듈 사명 + short·long 차이 본질 + long 추가 학습 활동 자연 서술
- short_equivalent 모듈: 3 요소 자연 포함 의무
  ① 정직성 표시 — "short과 long 모두 {Nh} 동일 — 추가 학습 활동 부재"
  ② 확장 어려움 사유 — 1h 안에 핵심 미션 모두 소개·2h로 늘리면 같은 메시지 길게 풀어 설명 등
  ③ 절감 시간 활용 제안 — 질의응답·도구 시연 데모·플랜 비교 시연 등

[모듈별 사명 spec 정합]
- M1: 도구 유형·기능 카테고리 풀이
- M2: When·Why 풀이. AI 전환 가치·툴 적합성·직무 중요도 근거를 의미 문장으로 풀어쓰기 (수치·라벨 직접 노출 X — 공정 2·3 spec 정합)
- M3: M4 역산 mini 흐름·feature 선정 근거·learning method
- M4: task 흐름·사용 feature·산출물 (★ 사용 feature 명시 필수)
- M4-M3-M2-M1 역산 원칙 정합 (M3가 M4 feature만 다루는지·M2가 M4 task의 적합 근거 풀이인지 등)

[금지]
- 본 도구 메타 워딩 흡수 X (P-\d+·patch_log·applied_definitions·planned_additions·"v3.1 회복"·"★ 표시"·"M4 역산 evidence"·track_b_compliance·char_inflation·feature_name_repetition·activity_method_only·task_flow_continuous_split·data_range_only_split — 13건 카테고리)
- 교안 침투 X — 수강생 발화·슬라이드 대본·"안녕하세요 여러분..." 같은 강의 스크립트 X
- 표 본체 변경 X (공정 4는 모듈 LD 설명만 추가)
```

### 산출 (in-memory)

```json
{
  "module_ld_explanations": {
    "M1": {"text": "...", "honesty_label": "short_equivalent | expanded", "line_count": 7, "sentence_count": 5, "all_3_components_present": true},
    "M2": {"text": "...", "honesty_label": "...", "v3v4v2_natural_inclusion": true},
    "M3": {"text": "...", "honesty_label": "..."},
    "M4": {"text": "...", "honesty_label": "...", "feature_list_present": true}
  }
}
```

★ tools 배열 길이만큼 반복 — 툴별로 4 모듈 LD 설명 합성.

---

## Step 3 [Check·LLM 호출 2]: 자체 검증 6 게이트 평가 (Sonnet — 약한 회피)

### 약한 회피 spec

- 합성·평가 LLM 분리 의무 = **별도 호출·컨텍스트·prompt만 만족** (모델 동일 인스턴스 OK)
- self-grading bias 회피가 본질 — 같은 호출 안에서 합성·평가 동시 X 정신만 만족
- 1 평가 LLM 호출로 모듈별 4 평가 + 통합 1 = 5 분량 일괄 처리 OK (효율 압축)

### 평가 게이트 6건

| 게이트 | 검증 영역 |
|---|---|
| **a 표 본체 보존** | 공정 3 산출 표(`short-refined.md`·`long-refined.md`)와 글자 단위 일치 — bullet_diff_count = 0 |
| **b 부연 흡수 통합 + 메타 필터링** | (1) 공정 2·3 부연 정보 누락 X (2) 본 도구 메타 13 정규식 매칭 0건 |
| **c 모듈별 사명 spec 정합** | M1 도구 유형·기능 / M2 When·Why (AI 전환 가치·툴 적합성·직무 중요도 근거 풀어쓰기. 수치·라벨 직접 노출 X — 공정 2·3 spec 정합) / M3 M4 역산·feature 선정·learning method / M4 task 흐름·**사용 feature**·산출물 / **공통 = M4-M3-M2-M1 역산 원칙** |
| **d 분량 가이드라인 (5-7줄 soft)** | 너무 짧거나 너무 긴 경우만 검출 — out_of_range 임계 = sentence_count <3 또는 >10 |
| **e 교안 금지** | 수강생 발화·슬라이드 대본·"안녕하세요" 등 NG 패턴 0건 |
| **f 정직성 표시 보존** | M1·M2 short_equivalent 3 요소(정직성 표시·확장 어려움 사유·절감 시간 활용 제안) 자연 포함 / M3·M4 expanded 확장 사유 자연 포함 |

### 본 도구 메타 13 정규식 (게이트 b 영역)

| 카테고리 | 패턴 |
|---|---|
| Patch ID | `P-\d+` (정규식 통합 — P-8·P-9·P-10·P-11 + 미래 P-12·P-13 등 자동 포함) |
| spec 메타 | `patch_log`·`applied_definitions`·`planned_additions` |
| cycle 진화 | `"v3.1 회복"`·`"v3 → v3.1"`·`"★ 표시"`·`"M4 역산 evidence"` |
| spec 검증 | `track_b_compliance`·`char_inflation` |
| trk B 위반 | `feature_name_repetition`·`activity_method_only`·`task_flow_continuous_split`·`data_range_only_split` |

### 산출 (in-memory)

```json
{
  "evaluation_result": {
    "a_table_preservation": {"pass": true, "bullet_diff_count": 0},
    "b_annotation_absorption": {"pass": true, "info_absorption_pass": true, "meta_filtering_pass": true, "leaked_meta_words": []},
    "c_module_focus_alignment": {"pass": true, "details": {...}},
    "d_length_guideline": {"pass": true, "out_of_range_count": 0},
    "e_textbook_prohibition": {"pass": true, "ng_pattern_count": 0},
    "f_honesty_preservation": {"pass": true, "honesty_labels_preserved": [...], "expansion_rationale_included": [...]}
  }
}
```

### 게이트 fail 처리

- 게이트 a fail (표 본체 변경 발생) → 즉시 fail. 합성 LLM 자체 재합성 1회 한정 (Step 2 재실행)
- 게이트 b·c·d·e·f fail → 합성 LLM 자체 재합성 1회 한정 (게이트 fail 사유 prompt에 명시)
- 재합성 후도 fail → Case A(LD 조치 가능) 분기

---

## Step 4 [Shell]: 최종 산출 합성 + GAS POST 1 + LD 고지 (LLM 호출 X)

### 1. `curriculum-final_{company}_{role}_{timestamp}.md` 합성

- **저장 경로**: `{run_folder}/curriculum-final_{company}_{role}_{timestamp}.md` — **run_folder 직속** (phase2/ 안 아님. LD가 폴더 열면 바로 보이는 자리)
- 헤더 (생성 정보 + 커리큘럼 개요)
- 툴별 [{tool}] 섹션 반복:
  - 표 — long (공정 3 산출 그대로 복사)
  - 표 — short (공정 3 산출 그대로 복사)
  - 모듈별 LD 설명 (Step 2 산출)
- "다음 단계" 섹션 X

### 2. `final-result.json` 작성

- **저장 경로**: `{run_folder}/phase2/curriculum-final-meta/final-result.json` (부속 메타 자료)

```json
{
  "final_version": "phase4-v1",
  "phase": "Phase 2 공정 4 (curriculum-final)",
  "input_source_decision": {
    "selected": "옵션 B",
    "rationale": "공정 3 산출 + curriculum-post-factcheck.md 보조"
  },
  "module_ld_explanations": {...},
  "gate_results": {...},
  "self_check": {"total_items": 12, "passed_items": 12, "all_pass": true},
  "llm_call_count": 2,
  "llm_call_breakdown": {"synthesis": 1, "evaluation": 1, "retry": 0},
  "metadata": {
    "company": "...",
    "role": "...",
    "tool_names": [...],
    "topic": "...",
    "hours_total": {"short": 6, "long": 12},
    "module_long_decisions": {"M1": "short_equivalent", "M2": "...", "M3": "...", "M4": "..."},
    "ralph_validator": null,
    "generated_at": "YYYY-MM-DD",
    "main_artifact": "curriculum-final_{company}_{role}.md",
    "main_prd_json_protection_verified": true
  }
}
```

### 3. `self-check-result.json` 작성 (자체 검증 12 항목)

- **저장 경로**: `{run_folder}/phase2/curriculum-final-meta/self-check-result.json` (부속 메타 자료)

| # | 항목 |
|---|---|
| 1 | curriculum-final_*.md 산출물 위치 정합 — **run_folder 직속**에 저장됨 (phase2/ 안 아님) |
| 2 | final-result.json·self-check-result.json 산출물 위치 정합 — `phase2/curriculum-final-meta/`에 저장됨 |
| 3 | SHA-256 hash 기록 (산출물 무결성) |
| 4 | 게이트 a — 표 bullet 내용 보존 |
| 5 | 게이트 b — 부연 흡수 + 메타 필터링 |
| 6 | 게이트 c — 모듈별 사명 spec 정합 (M2 When·Why 의미 문장 풀어쓰기 + M4 사용 feature + 역산 원칙) |
| 7 | 게이트 d — 분량 가이드라인 (5-7줄 soft) |
| 8 | 게이트 e — 교안 금지 |
| 9 | 게이트 f — 정직성 표시 보존 |
| 10 | 본 도구 메타 13 정규식 매칭 0건 (전체 산출 영역) |
| 11 | M2 적합 근거 흡수 (AI 전환 가치·툴 적합성·직무 중요도 의미 문장 풀이) |
| 12 | 호출 수 budget (~2) 안 |

### 4. GAS POST 1 (Phase 2 도달 자동 기록)

```
URL: https://script.google.com/macros/s/AKfycbzI1nPJggHSTs3p2dbJdUFISLKthbTGVIvCuCEISH0wmBWPapAPIFrNhGcMLRboaRr9/exec
Method: POST
Content-Type: application/json

Body:
{
  "ld_name": "{input.json.ld_name 또는 'anonymous'}",
  "company": "{input.json.company}",
  "role": "{input.json.role}",
  "tools": "{input.json.tools.join(',')}",
  "topic": "{input.json.topic}",
  "reached_phase": "phase_2",
  "notes": ""
}
```

★ timestamp 필드 X — GAS 서버 측 자체 생성 (Asia/Seoul yyyy-mm-dd hh:mm:ss). 클라이언트가 보내도 무시됨.

★ POST 1 = 무조건 자동 호출 (Phase 2 결과물 직후. LD 응답 무관)

### 5. LD 고지 (1회. 내부 라벨 노출 0건)

```
[Phase 2 공정 4 완료]

산출물: curriculum-final_{company}_{role}.md
- 표 — long ({hours_total.long}h)
- 표 — short ({hours_total.short}h)
- 모듈별 LD 설명 (M1·M2·M3·M4 각 5-7줄)

모듈별 long 결정:
- M1: {short_equivalent | expanded}
- M2: {short_equivalent | expanded}
- M3: {short_equivalent | expanded}
- M4: {short_equivalent | expanded}

기업의 맥락, 시수, 보안/환경 제약, 수강생 수준 등을 반영하여 고도화할 수 있게 계속 대화를 진행하시겠습니까?
```

★ 내부 라벨 노출 0건 — 게이트 a·b·c·d·e·f 같은 spec 라벨 LD 고지 텍스트에 X. 의미 문장으로 변환.

---

## Step 5 [Shell]: GAS POST 2 (조건부 — Phase 3 진입 의도 기록)

LD가 Step 4 LD 고지의 Phase 3 진입 질문에 **"예"**(또는 긍정 답변)로 답한 경우에만 호출.

```
Body:
{
  "ld_name": "{...}",
  "company": "{...}",
  "role": "{...}",
  "tools": "{...}",
  "topic": "{...}",
  "reached_phase": "phase_3",
  "notes": ""
}
```

★ "아니오" / 무응답 / 모호 → POST 2 호출 X. 본 공정 종료.

---

## 자체 검증 12 항목 (의무 12·관찰 0)

위 Step 4 §3 표 영역. self-check-result.json에 박힘.

### 게이트 fail 처리

- 자체 검증 1·2·3 (산출물 위치·SHA-256) fail → Case B(시스템 오류) 즉시 중단
- 자체 검증 4-9 (게이트 a-f) fail → Step 3 게이트 fail 처리 영역과 동일 (자체 재합성 1회 한정)
- 자체 검증 10·11 (메타 필터링·V3·V4·V2 흡수) fail → 자체 재합성 1회 한정
- 자체 검증 12 (호출 수 budget) fail → 관찰 영역 (warning. 산출물 저장 진행)

---

## 모듈 LD 설명 작성 원칙 (Phase 1 spec §"Bullet 작성 원칙" 차용·본 공정 정정 정합)

| # | 원칙 |
|---|---|
| 1 | **꼭지 제목 변환** — 설명형 꼭지 ("이 task가 왜 AI를 필요로 하는가") 직접 박지 X. 학습 주제 자연 산문체로 풀이 |
| 2 | **꼭지 내용 통째 옮기기 0건** — 핵심 학습 주제만 산문체 추출 |
| 3 | **5-7줄 산문체** — 분량 가이드라인 soft. 너무 짧거나 너무 긴 경우만 검출 |
| 4 | **단일 산문 안에 short·long 차이 자연 서술** — 별도 섹션 분리 X |
| 5 | **정직성 라벨 차등 처리** — short_equivalent는 3 요소 자연 포함 의무 |
| 6 | **본 도구 메타 워딩 흡수 X** — 13 정규식 매칭 0건 의무 |
| 7 | **교안 침투 X** — 수강생 발화·슬라이드 대본 X. 모듈 구성 기획 수준 |
| 8 | **내부 평가 라벨·점수 직접 노출 X** — V3·V4·V2 같은 라벨이나 점수(5점·4.2점 등) 본문에 박지 X. 의미 문장 풀어쓰기로만 (공정 2·3 spec 정합) |
| 9 | **M4 사용 feature 명시 의무** — 게이트 c 영역 |
| 10 | **M4-M3-M2-M1 역산 원칙 정합** — 각 모듈 사명이 후속 모듈과 정합 |
| 11 | **회피 워딩 spec·prompt 자체에서 제거** — "전문용어·컴퓨터 용어 회피하라" 같은 표현 X (회피 압력 → 내용 부자연스러움 위험) |

---

## 사례 (Before/After 1건 — 본 도구 메타 침투 정정)

**Before (메타 침투 + 교안 풍)**:
> "M1 (미드저니 소개) — short 1h / long 2h: 안녕하세요 여러분. 미드저니는 시각 생성 전문 AI로... P-11 통합 우선 적용으로 mini 분리 X 정직 short_equivalent 가능. patch_log 박힘."

**문제점**:
- `P-11`·`patch_log` 본 도구 메타 워딩 침투 (게이트 b 위배)
- "안녕하세요 여러분" 강의 스크립트 풍 (게이트 e 위배)
- 정직성 3 요소(정직성 표시·확장 어려움 사유·절감 시간 활용 제안) 누락 (게이트 f 위배)

**After (정정)**:
> "M1 (미드저니 소개) — short 1h / long 2h (short과 long 동일): 미드저니는 시각 생성 전문 AI로, 자연어 프롬프트와 참조 이미지·스타일 코드 같은 보조 입력으로 결과를 제어한다. 시각 생성·일관성 제어·작업 환경 세 카테고리로 주요 기능을 한눈에 보여주어 수강생이 도구의 종류와 기본 감을 잡고 후속 모듈로 넘어가도록 구성했다. 본 모듈은 1h 안에 정체·기본 사용·기능 카테고리 모두 소개 가능하므로 long·short 동일 — 추가 학습 활동 부재. long 운영 시 절감되는 1h를 미드저니 플랜 비교 시연·자유 질의응답·디자이너 자기 워크플로우 매핑으로 활용 권장."

★ 정직성 3 요소 자연 포함 + 메타 워딩 0건 + 강의 스크립트 풍 X.

---

### LLM 인지 핵심 메시지

- **모듈 LD 설명은 LD 검토용**이지 강의 교안 X — 모듈 구성 기획 수준
- **본 도구 메타 워딩 0건** — P-숫자·patch_log·★ 표시 등 본 도구 진화 영역 워딩 LD에게 노출 X
- **정직성 라벨 차등 의무** — short_equivalent 모듈은 3 요소 자연 포함 (정직성 표시·확장 어려움 사유·절감 시간 활용 제안)
- **표 본체 변경 X** — 본 공정은 LD 설명 추가만. 공정 3 산출 표는 글자 단위 보존
- **M4 사용 feature 명시 의무** — 게이트 c
- **M4-M3-M2-M1 역산 원칙 정합** — 게이트 c 공통 검증

---

## 톤앤매너 흡수 가이드 (input 자체 X·spec 본문 흡수)

### Phase 1 조합 spec + curriculum.md 모델 (한 묶음, 1순위 source)

skill-phase1-curriculum-assembly의 §"Bullet 작성 원칙" + 모듈 구성 설명 산문체 패턴(3-5줄). 본 공정은 5-7줄로 약간 풍부 — 공정 2·3 부연 흡수 통합 분량.

산문체 패턴:
- 자연 한국어·풀어쓰기·LD 친화
- 한 문장 정의로 모듈 시작 가능 (예: "M1 (미드저니 소개) — short 1h / long 2h: 미드저니는 시각 생성 전문 AI로...")
- 학습 주제·사명·근거를 한 흐름으로 연결
- 통째 옮기기 X — 핵심만 산문체로 추출

### BGF리테일 제안서 톤앤매너 (한정 차용)

bullet 짧은 명사구 패턴 한정 차용. 단 본 공정 산출은 산문체이므로 직접 차용 X.

미차용 영역 (본 공정 산출에 박지 X):
- 표 4 컬럼 (일자·주제·주요 내용·시수) — 본 공정은 3 컬럼 (구분·시수·내용)·공정 3 산출 그대로
- [실습] 마커 별도 표기 — M3·M4 자체가 실습이라 마커 X
- 시수 sub 단위 (0.5H·1.5H 등) — 본 공정은 큼직한 모듈 단위
- 교육 목표·형태 별도 삽입 — 본 공정 산출에 별도 삽입 X

---

## scope (침범 금지)

| 영역 | 본 공정 범위 |
|---|---|
| 표 bullet 워딩 정정 | ❌ 공정 3 영역 |
| 시수 결정 (모듈별 short_equivalent vs expanded) | ❌ 공정 2 영역 |
| feature 검증 (today_usable·level_decision) | ❌ 공정 1 영역 |
| 톤앤매너 정합 — 표 영역 | ❌ 공정 3 영역 |
| **모듈별 LD 설명 산문체 합성** | ✅ 본 공정 |
| **메타 영역 흡수 통합 + 본 도구 메타 필터링** | ✅ 본 공정 |
| **정직성 라벨 차등 처리** | ✅ 본 공정 |
| **GAS 2회 POST 영역** | ✅ 본 공정 |

---

## 실행 시 LLM 회피 워딩 영역 (★ spec·prompt에서 모두 제거)

다음 워딩은 spec·prompt 자체에서 박지 X — 회피 압력이 LLM 산출 부자연스러움 유발 위험:

- "전문용어 회피하라"
- "컴퓨터 용어 회피하라"
- "딱딱한 워딩 회피하라"
- "LD 친화적이게 써라" (광범 추상)

대신 spec은 구체 패턴(5-7줄 산문체·통째 옮기기 X·메타 워딩 13 정규식 등)으로 박혀있고, LLM이 패턴 따라 자연 산문체 작성하면 LD 친화 spec 자연 정합.

---

## 실패 처리

### LLM 1회 자동 재시도 (low-level 호출 안정성)

API 일시 오류·rate limit·timeout → 1회 자동 재시도. 재시도 후도 fail → Case B(시스템 오류) 분기.

### 자체 재합성 (high-level 게이트 fail 정정·1회 한정)

- 게이트 a-f fail → 합성 LLM 자체 재합성 1회 한정 (게이트 fail 사유 prompt에 명시)
- 재합성 후도 fail → Case A(LD 조치 가능) 분기

### Case A (LD 조치 가능)

게이트 fail 사유를 LD에게 안내하고 분기 선택지 제공:
- "재실행" → 처음부터 다시 (호출 2회 다시)
- "공정 3 산출 정정 후 재실행" → 공정 3 ralph로 회귀
- "수동 정정 진행" → LD 직접 산출물 정정 후 본 공정 건너뛰기

### Case B (시스템 오류 — 즉시 중단)

- 인계 점검 5 항목 fail
- 메인 .omc/prd.json 무손상 검증 fail (head 변경)
- LLM 1회 자동 재시도 후도 API 오류

→ 즉시 중단 + LD에게 시스템 오류 안내. 본 공정 산출물 저장 X.

---

## 공정 4 자체 종료 영역

본 공정 산출 후 다음 단계 = LD 의사결정 영역. 본 SKILL.md scope X.

- LD가 "예" → Phase 3 진입 의도 기록 (GAS POST 2). 이후 LD-Claude 자유 대화 (Phase 3 가이드북 영역)
- LD가 "아니오" / 무응답 → 본 공정 종료. curriculum-final_{company}_{role}.md가 LD 표준 산출물

---

## references 폴더 정책 (v4)

본 SKILL.md는 **references/ 폴더 미사용**. 6 게이트 schema·정직성 차등 매핑·본 도구 메타 13 정규식·합성 prompt·평가 prompt 모두 본 SKILL.md 본문 통합. v3 자료(있으면) 별도 보관.

**근거**: 공정 2·3 SKILL.md 사례 정합 — references/ 폴더 X. 단일 파일 운영으로 spec 인지 비용 절감.

---

## 완결 원칙 요약

1. **표 본체 보존 100%** — 공정 3 산출과 글자 단위 일치 (게이트 a)
2. **모듈 LD 설명 산문체 4건** — 5-7줄·short·long 차이 한 산문 안에서 자연 서술
3. **정직성 라벨 차등 처리** — short_equivalent 3 요소 자연 포함 의무
4. **본 도구 메타 13 정규식 매칭 0건** — 게이트 b
5. **M4 사용 feature 명시 + M4-M3-M2-M1 역산 원칙 정합** — 게이트 c
6. **교안 침투 0건** — 게이트 e
7. **합성·평가 LLM 분리 (약한 회피)** — 별도 호출·컨텍스트·prompt만 만족 (모델 동일 인스턴스 OK)
8. **GAS 2회 POST** — POST 1(Phase 2 자동·무조건) + POST 2(Phase 3 진입 의도 답변 시 조건부)
9. **LD 고지 1회 + 내부 라벨 노출 0건** — 의미 문장으로 변환
10. **메인 .omc/prd.json 무손상** — 시작·종료 head 비교
11. **references/ 폴더 미사용** — 본 SKILL.md 본문 통합
12. **회피 워딩 spec·prompt 자체에서 제거** — 회피 압력 위험 차단
