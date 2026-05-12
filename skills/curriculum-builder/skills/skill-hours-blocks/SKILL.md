---
name: hours-module-blocks
description: curriculum-builder Phase 2 공정 2 (v4). 공정 1 후속 산출(curriculum-post-factcheck.md)을 받아 두 시수 세트로 산출. short(합 6h) = 재단·LLM 호출 X·복사 + 시수 라벨 / long(합 12h) = 옵션 c 모듈별 차등 — M3·M4 적극 재생성, M2·M1 추가 거리 있으면 합성·없으면 "short과 동일·시간 활용 제안" 정직 표기. 카탈로그 6 카테고리 자연 흡수·anti-patterns MECE 6 [거절] 위반 0건·자체 검증 11 게이트(의무 8 + 관찰 3). 산출 4건 통합 (short.md·long.md·short-meta.json·long-meta.json). 호출 5회 (long 합성 M4·M3·M2·M1 4 + 자체 점검 1). 옵션 B (skill 5~8 재호출 X)·역산 순서 M4→M3→M2→M1.
---

# Phase 2 공정 2: Hours-Blocks (v4)

curriculum-builder Phase 2의 두 번째 공정. 공정 1 후속 산출인 `curriculum-post-factcheck.md`를 1차 source로 받아, 모듈별로 두 시수 세트(short 합 6h·long 합 12h)를 만든다. **short은 재단**(curriculum-post-factcheck 본문 그대로 복사 + 시수 라벨), **long은 옵션 c 모듈별 차등 합성**(M3·M4 적극 재생성·M2·M1 추가 거리 있으면 합성·없으면 정직 표기) 흐름이다.

## 본 공정의 위치

```
공정 1 (factcheck)
  → 공정 1 후속 (curriculum-rebuild)  [curriculum-post-factcheck.md 산출]
  → 본 공정 (hours-blocks)             [short·long 두 세트 산출]
  → 공정 3 (block-refinement)          [워딩·톤앤매너 정정]
  → 공정 4 (final-curriculum)          [통합 final 산출]
```

| 항목 | 내용 |
|---|---|
| 1차 input source | `curriculum-post-factcheck.md` (공정 1 후속 산출) |
| 보조 input | `factcheck-result.json` · `input.json` · `m{N}-{tool}.v2.md` (영향 모듈) · `top-tasks.json` |
| Output | `phase2/blocks/{short.md, long.md, short-meta.json, long-meta.json}` 4건 |
| LLM 호출 | 총 5회 (long 합성 4 + 자체 점검 1) — short은 호출 X |
| 합성 흐름 | 옵션 B (공정 2 자체 처리·skill 5~8 재호출 X) |
| 합성 순서 | 역산 — M4 → M3 → M2 → M1 |

## 본 공정의 사명

curriculum-builder 사명 4 영역 중 **(2) 시수별 구성 보이기** 담당. Phase 1 산출이 모듈별 시수(M1·M2 short 1h/long 2h, M3·M4 short 2h/long 4h)로 어떻게 풀리는지를 LD 검토용 표준 형태로 정리한다.

핵심 의도:
- **시수 차이가 학습 활동 차원에서 의미 있게 드러나야 함** — 글자 부풀리기 금지, 정직 표기로 차단
- "표준 커리큘럼" 산출 — Phase 3까지 안 가고 Phase 2 종료 시점에 LD에게 넘김
- LD가 "이 커리큘럼은 표준으로 잘 작동하는 정합도 높은 커리큘럼이다"라고 설득되는 결과물

## 재단 vs 재생성 — 두 모드 분리

| 모드 | 의미 | 적용 |
|---|---|---|
| **재단** | Phase 1 산출의 학습 내용·task 흐름·핵심 feature 보존. LD 이해 정합 영역에서 풀이 정정 OK (풀어서 설명·딱딱한 워딩 정정·자연 한국어 정정). 단 의미 없는 분량 채움 X (anti-pattern E) | short 전체 |
| **재생성** | Phase 1 산출 유지 + 새 학습 활동·새 mini·새 시나리오 추가. **단순 bullet 길이 늘림은 확장 X** (anti-pattern E). 기존 폐기 X | long의 합성 모듈 (M3·M4 + 추가 거리 있는 M2·M1) |

★ short은 LLM 호출 X — `curriculum-post-factcheck.md` 본문을 그대로 옮기고 시수 라벨 추가. 단 워딩 정정·풀이 정정이 LD 이해 정합 영역이면 자연 OK.

**핵심 구분 — "재단" vs "확장" 의미**:
- 재단의 "분량 변형" ≠ 압축 강제. 풀어서 설명·LD 이해 정합 정정·딱딱한 워딩 정정 모두 OK
- 확장의 "분량 늘림" ≠ bullet 길이 늘림. 새 학습 활동·새 시나리오·새 mini 추가만이 진짜 확장
- 같은 내용 풀이로만 부풀리는 영역은 둘 다 차단 (anti-pattern E)

## 옵션 c — 모듈별 차등 합성 (long 흐름)

| 모듈 | long(2h 또는 4h) 처리 |
|---|---|
| M4 | 적극 재생성. 카탈로그 6 카테고리 자연 흡수 |
| M3 | 적극 재생성. M4 변화 따라감 (카탈로그 직접 적용 X) |
| M2 | 추가 거리 있으면 합성, 없으면 정직 표기 |
| M1 | 추가 거리 있으면 합성, 없으면 정직 표기 |

**역산 순서**: M4 → M3 → M2 → M1. 앞 모듈 결과를 뒤 모듈 합성에서 인지하여 모듈 간 정합 유지.

**정직 표기 본문 형태**:
```
본 시수에서는 short(1h)과 동일한 학습 활동을 진행합니다.
추가 시간(1h)은 LD가 톤앤매너·주제 깊이·실습 추가 등 영역에서 자유롭게 활용하시도록 제안합니다.
```
+ `module_labels.{m1|m2}: "short_equivalent"` 메타 기재.

## Input

| 파일 | 필수 여부 | 용도 |
|---|---|---|
| `curriculum-post-factcheck.md` (`{run_folder}/phase2/factcheck/`) | ★ 필수 | 1차 source. short 재단·long 합성 base |
| `factcheck-result.json` (`{run_folder}/phase2/factcheck/`) | ★ 필수 | 통과 feature 목록 (의무 게이트 1)·영향 모듈 식별 |
| `input.json` (`{run_folder}/` 직속) | ★ 필수 | run_folder·company·role·tools·topic·시수(메타 일치 점검용·본문 합성에는 미사용) |
| `m{N}-{tool}.v2.md` (`{run_folder}/phase2/factcheck/`) | 영향 모듈만 | factcheck-result.results[].reconstruction.file_after가 가리키는 파일 |
| `m{N}-{tool}.md` (`{run_folder}/phase1/`) | 영향 X 모듈 | 변경 0건 모듈의 원본 |
| `top-tasks.json` (`{run_folder}/` 직속) | optional | M4 task 인지 보강 |

**저장 위치**: 산출 4건은 모두 `{run_folder}/phase2/blocks/` 하위. `{run_folder}`는 `input.json.run_folder` 값(절대 경로).

**미참조 영역** (본 공정에서 읽지 않음):
- `input.json.security` — Phase 3 영역
- `input.json.hours` — 표준 grid 고정 사용 (1·1·2·2 / 2·2·4·4)
- `input.json.level` — Phase 3 영역

## Output (산출 4건 통합)

```
{run_folder}/phase2/blocks/
  ├── short.md          (m1~m4 통합·1·1·2·2h·재단)
  ├── long.md           (m1~m4 통합·2·2·4·4h·재단 또는 재생성)
  ├── short-meta.json   (라벨·시수·점검·observations·honest_marking 통합)
  └── long-meta.json    (라벨·시수·catalog_patterns·점검·observations·honest_marking 통합)
```

★ **점진 진화 흐름** — 운영 후 observations 분리 니즈 발생 시 별도 파일(`observations.md` 등) 5건 분리로 정정.

### short.md 구조

```markdown
# {company} {role} — AI 교육 커리큘럼 (시수 구성 — short, 합 6h)

> 생성 정보
> - Phase 2 공정 2 산출 — short 세트 (재단)
> - 시수 grid: M1 1h · M2 1h · M3 2h · M4 2h (합 6h)
> - 1차 source: curriculum-post-factcheck.md
> - 본 산출 = 공정 3 input

## 커리큘럼 개요
{curriculum-post-factcheck 개요 그대로 복사}

---

## [{tool_name_1}]

### 커리큘럼 표 (한눈에 보기 — short, 합 6h)

| 구분 | 내용 | 시수 |
|------|------|------|
| M1 ({tool_name} 소개) | • {bullet 1}<br>• {bullet 2}<br>• ... | 1h |
| M2 (활용 맥락) | • ... | 1h |
| M3 (기초 실습) | • ... | 2h |
| M4 (메인 실습) | • ... | 2h |

### 모듈 구성 설명

- **M1 ({tool_name} 소개)**: 자연 산문체 3~4줄 (curriculum-post-factcheck의 M1 모듈 구성 설명 그대로·LD 이해 정합 영역에서 풀이 정정 OK)
- **M2 (활용 맥락)**: 자연 산문체 3~4줄
- **M3 (기초 실습)**: 자연 산문체 3~4줄
- **M4 (메인 실습)**: 자연 산문체 3~4줄

{복수 툴이면 다음 툴 섹션 반복}
```

★ short.md = 도구별로 (커리큘럼 표 + 모듈 구성 설명) 한눈에 보기. curriculum-post-factcheck.md의 본문 구조를 그대로 따라간다.

### long.md 구조

```markdown
# {company} {role} — AI 교육 커리큘럼 (시수 구성 — long, 합 12h)

> 생성 정보
> - Phase 2 공정 2 산출 — long 세트 (옵션 c 모듈별 차등)
> - 시수 grid: M1 2h · M2 2h · M3 4h · M4 4h (합 12h)
> - 모듈별 라벨: M1 {expanded|short_equivalent} · M2 {...} · M3 {...} · M4 {...}
> - 1차 source: curriculum-post-factcheck.md
> - 본 산출 = 공정 3 input

## 커리큘럼 개요
{curriculum-post-factcheck 개요 그대로}

---

## [{tool_name_1}]

### 커리큘럼 표 (한눈에 보기 — long, 합 12h)

| 구분 | 내용 | 시수 |
|------|------|------|
| M1 ({tool_name} 소개) | • {bullet 1}<br>• ... (expanded 경우 추가 학습 활동·short_equivalent 경우 short과 동일 표기) | 2h |
| M2 (활용 맥락) | • ... | 2h |
| M3 (기초 실습) | • ... (M4 변화 자연 따라간 확장 영역) | 4h |
| M4 (메인 실습) | • ... (카탈로그 6 자연 흡수·LD 라벨 노출 X) | 4h |

### 모듈 구성 설명

- **M1 ({tool_name} 소개)**:
  - expanded 시 — 자연 산문체 5~8줄 (short 3~4줄 그대로 + 추가 학습 활동 풀이 자연 추가)
  - short_equivalent 시 — short M1 모듈 구성 설명 그대로 + 다음 정직 표기 한 줄 추가:
    > "본 시수에서는 short(1h)과 동일한 학습 활동을 진행합니다. 추가 시간(1h)은 LD가 톤앤매너·주제 깊이·실습 추가 등 영역에서 자유롭게 활용하시도록 제안합니다."
- **M2 (활용 맥락)**: 동일 분기 (expanded 5~8줄 / short_equivalent 정직 표기)
- **M3 (기초 실습)**: 산문체 5~8줄 (재생성·M4 변화 따라감·추가 학습 활동 풀이)
- **M4 (메인 실습)**: 산문체 5~8줄 (재생성·카탈로그 6 자연 흡수·추가 학습 활동 풀이·top 1~2 catalog_patterns 메타 기재)
```

★ long.md도 short.md와 동일한 (커리큘럼 표 + 모듈 구성 설명) 형태. 한눈에 시수 구성·학습 내용·정직 표기(있으면) 모두 인지 가능.

**분량 가이드 — expanded vs short_equivalent**:
- short 모듈 구성 설명 = 산문체 3~4줄 (curriculum-post-factcheck 표준 정합)
- long expanded 모듈 구성 설명 = 산문체 5~8줄 (short 3~4줄 보존 + 추가 학습 활동 풀이 자연 늘어남)
- long short_equivalent 모듈 구성 설명 = short 그대로 + 정직 표기 한 줄
- ★ 의미 없는 분량 채움 차단 (anti-pattern E) — 새 학습 활동이 진짜 추가될 때만 풀이 늘림

### meta json 구조

`short-meta.json`:
```json
{
  "set_type": "short",
  "module_labels": {
    "m1": "short_equivalent",
    "m2": "short_equivalent",
    "m3": "short_equivalent",
    "m4": "short_equivalent"
  },
  "hours": { "m1": 1, "m2": 1, "m3": 2, "m4": 2, "total": 6 },
  "honest_marking": {
    "m1_short_equivalent_text_present": null,
    "m2_short_equivalent_text_present": null
  },
  "gate_results": {
    "obligatory_8": { "feature_preservation": "PASS", "tool_alignment": "PASS", "task_skeleton": "PASS", "anti_patterns_zero": "PASS", "honest_marking": "N/A_short", "catalog_tracking": "N/A_short", "module_essence": "PASS", "hours_meta": "PASS" },
    "observation_3": { "long_short_consistency": "OK", "module_label_alignment": "OK", "content_volume_vs_hours": "OK" }
  },
  "observations": []
}
```

`long-meta.json`:
```json
{
  "set_type": "long",
  "module_labels": {
    "m1": "short_equivalent | expanded",
    "m2": "short_equivalent | expanded",
    "m3": "expanded",
    "m4": "expanded"
  },
  "hours": { "m1": 2, "m2": 2, "m3": 4, "m4": 4, "total": 12 },
  "catalog_patterns": {
    "m4": [
      { "category": "심화 케이스 추가", "rationale": "이 모듈에 영향 큼 top 1" },
      { "category": "복잡도 1단계 상승", "rationale": "이 모듈에 영향 top 2" }
    ],
    "m3": [
      { "category": "M4 변화 따라감", "rationale": "M4 카탈로그 적용 결과 자연 반영" }
    ]
  },
  "p3_pending_candidates": [
    {
      "module": "m4",
      "candidate": "{6 catch X but 3 영역(task 흐름·실습 본질·LD 납득) 모두 OK 발견 영역}",
      "rationale": "{근거}",
      "ld_decision": "pending"
    }
  ],
  "honest_marking": {
    "m1_short_equivalent_text_present": true,
    "m2_short_equivalent_text_present": true
  },
  "gate_results": {
    "obligatory_8": { "feature_preservation": "PASS", "tool_alignment": "PASS", "task_skeleton": "PASS", "anti_patterns_zero": "PASS", "honest_marking": "PASS", "catalog_tracking": "PASS", "module_essence": "PASS", "hours_meta": "PASS" },
    "observation_3": { "long_short_consistency": "OK", "module_label_alignment": "OK", "content_volume_vs_hours": "OK" }
  },
  "observations": []
}
```

## 실행 흐름 (5 LLM 호출)

```
Step 1 [Shell]: 입력 로드 + 영향 모듈 식별
  ↓
Step 2 [Shell]: short.md 재단 (LLM 호출 X · 복사 + 시수 라벨) + short-meta.json 초안
  ↓
Step 3 [Core·LLM 호출 1]: M4 long 합성 (카탈로그 6 자연 흡수 · top 1~2 식별)
  ↓
Step 4 [Core·LLM 호출 2]: M3 long 합성 (M4 변화 따라감 · 역산 정합)
  ↓
Step 5 [Core·LLM 호출 3]: M2 long 합성 또는 정직 표기 (자체 추가 거리 판정)
  ↓
Step 6 [Core·LLM 호출 4]: M1 long 합성 또는 정직 표기 (자체 추가 거리 판정)
  ↓
Step 7 [Check·LLM 호출 5]: 11 게이트 자체 점검 + meta 통합 산출 + 의미 보존 4 영역 점검
```

호출 분포: Shell 2 (Step 1·2) · Core 4 (Step 3~6) · Check 1 (Step 7).

---

## Step 1 [Shell]: 입력 로드 + 영향 모듈 식별

**입력**: `curriculum-post-factcheck.md`, `factcheck-result.json`, `input.json`, `m{N}-{tool}.v2.md` (영향 모듈), `m{N}-{tool}.md` (영향 X 모듈), `top-tasks.json` (optional).

**작업**:
1. `input.json` 로드 → `run_folder`·`tools[]`·`topic`·`company`·`role` 인지
2. `curriculum-post-factcheck.md` 로드 → 도구별 모듈 본문 파싱 (M1·M2·M3·M4 섹션)
3. `factcheck-result.json` 로드 → 통과 feature 집합 in-memory 보관 (의무 게이트 1 source)
4. 영향 모듈 식별:
   - `factcheck-result.json.results[].reconstruction.file_after`가 가리키는 모듈 → `.v2.md` 본문 read
   - 그 외 → `.md` 본문 read
   - 영향 모듈 list와 본문 in-memory 보관

**산출** (in-memory):
```
context = {
  run_folder, tools, topic, company, role,
  curriculum_post_factcheck_text,
  module_bodies: { (tool, m1|m2|m3|m4): "본문 텍스트" },
  factcheck_features: { tool: ["feature_name", ...] },
  affected_modules: [(tool, module_id)]
}
```

**수락 기준**:
- 모든 입력 파일 정상 로드 (필수 파일 부재 시 Case B 시스템 오류 — 공정 1 후속 선행 요구 안내)
- 도구별 M1~M4 본문 모두 in-memory 확보
- factcheck 통과 feature 집합 확보

---

## Step 2 [Shell]: short.md 재단 + short-meta.json 초안 (LLM 호출 X)

**입력**: Step 1의 `context`.

**작업**:
1. `short.md` 합성 — `curriculum-post-factcheck.md` 모듈 본문을 그대로 옮기고 시수 라벨(M1 1h·M2 1h·M3 2h·M4 2h) 추가
   - 헤더 blockquote 갱신 (생성 정보·시수 grid·1차 source 명시)
   - 도구별 섹션 반복 (복수 툴 시)
   - **분량 늘리기 X·압축·풀이 줄임은 그대로** (재단 원칙)
2. `short-meta.json` 초안 작성:
   - `module_labels`: 모두 `"short_equivalent"` (재단이라 자동)
   - `hours`: { m1: 1, m2: 1, m3: 2, m4: 2, total: 6 }
   - `gate_results`: 빈 구조 (Step 7에서 채움)
   - `observations`: []

**산출**:
- `phase2/blocks/short.md` (저장)
- `phase2/blocks/short-meta.json` (초안 — Step 7에서 gate_results 채움)

**수락 기준**:
- short.md 본문이 `curriculum-post-factcheck.md` 모듈 본문과 정합 (분량 늘림 0건)
- 시수 라벨 (1·1·2·2h) 4 모듈 모두 명시
- short-meta.json 구조 정합 (module_labels·hours·gate_results·observations 4 key)

---

## Step 3 [Core·LLM 호출 1]: M4 long 합성

**입력**: `context` + 본 SKILL.md §"카탈로그 6 카테고리" 본문 + §"anti-patterns MECE 6 카테고리 [거절]" 본문 + §"의미 보존 점검 4 영역" 본문.

**LLM 프롬프트 핵심**:

```
당신은 curriculum-builder Phase 2 공정 2의 M4 long(4h) 합성 작업자입니다.

[목표]
short M4 (2h)의 task 흐름·핵심 feature·학습 목표 의미를 보존하고, long(4h) 분량의 추가 학습 활동을 합성합니다.

- 보존 영역: short의 task 흐름·핵심 feature·학습 목표 의미
- 정정 OK 영역: 미세 워딩·앞뒤 step 정정·세부 step 자연 추가·LD 이해 풀이 정정·딱딱한 워딩 정정
- 차단 영역: task 큰 틀 통째 폐기·순서 통째 정정 (β 옵션 — 발견 시 산출 메타에 기록 + 사용자 인계, 자동 정정 X)

[입력]
- short M4 본문 (재단된 형태)
- curriculum-post-factcheck.md M4 모듈 (1차 source)
- factcheck 통과 feature 집합
- top-tasks.json (M4 task 인지)
- input.json (company·role·topic·tools)

[적용 — 카탈로그 6 카테고리 자연 흡수]
다음 6 카테고리 중 본 task에 자연스러운 영역만 자연 흡수합니다.
"몇 건 적용" 강제 X · 자연 적용만.

기본 권장 (가장 자연스러운 확장):
- 심화 케이스 추가: 같은 task의 데이터·도메인 복잡도 한 단계 위에서 다시 풀어보기
- 복잡도 1단계 상승: 수강생 인지·경험 수준이 한 단계 높다고 가정한 실습
- 미사용 feature 추가: factcheck 통과 feature 중 task에 적합한데 안 사용된 것 추가

Case 적합 시 OK:
- 비교·평가 단계: 같은 결과물을 다른 방식·다른 도구로 만들고 비교 평가
- 실패 케이스 회고: task 실습 흐름 중 실패 케이스 발생 시점 해결 과정 자체를 실습으로 추가
- 협업·검증 단계: 수강생끼리 협업해서 만들거나, 마친 후 서로 피드백·검증

[6 catch X 발견 시 처리]
- 6 카테고리 매칭 = 자연 적용
- 6 catch X but 3 영역(task 흐름 정합·실습 본질·LD 납득) 모두 OK 영역 발견 시
  = 본문 적용 X · long-meta.json p3_pending_candidates에 후보 메모 + 사용자 인계
- 6 catch X + 3 영역 중 1건이라도 X = 폐기·메모 X

[차단 — anti-patterns MECE 6 카테고리 [거절]]
다음 6 카테고리 위반 0건:
- A. task 흐름 억지 분리 (같은 task 흐름 단계 별개 mini로 잘게 쪼개기)
- B. 데이터 범위·예시만 다르게 분리 (본질 동일·숫자만 변경)
- C. 활동 방식만 다르게 분리 (정리한다·분류한다·검토한다 동사만 바꿈)
- D. 같은 feature 단순 반복 (같은 feature가 같은 활용 방식·같은 분야로 mini 여러 곳 반복 등장 — 같은 feature의 다른 활용 방식·다른 분야·다른 깊이는 허용)
- E. 설명·말만 길게 부풀리기 (한 mini 안에서 풀이로 분량만 늘림)
- F. 무관 feature 포함 (task 흐름과 안 맞는 feature 끼워넣기)

[보존 — 의미 보존 4 영역]
- feature 보존: factcheck 통과 feature 누락 X · 도구별 적용 feature 명 그대로 유지
- 도구 정합: M4 도구 영역 안 섞임 (예: m4-chatgpt에 m4-gemini 도구 등장 X)
- task 큰 틀 보존: M4 시작·중간·끝 큰 단계 유지 · feature 추가 시 세부 step 자연 추가 OK · step 통째 폐기·순서 통째 정정 X
- 모듈 본질 흐름: M4 = task 통합 모듈 (M1=기능 카테고리·M2=도구 깊이·M3=feature 익힘과 안 섞임)

워딩 정정 OK 영역 = 자연 한국어 풀이·분량 압축·딱딱한 워딩 정정·새 추가 영역(재생성).
핵심 명사 (도구·feature·task 명)는 그대로 유지.

[출력 형식]
JSON으로 다음 구조 산출:
{
  "m4_long_text": "{long.md M4 섹션에 들어갈 본문}",
  "catalog_patterns_used": [
    { "category": "{6 카테고리 중 매칭}", "rationale": "{본 모듈에 영향 큼 근거}" }
  ],
  "p3_pending_candidates": [
    { "candidate": "{6 catch X but 3 영역 모두 OK 발견 영역}", "rationale": "{근거}" }
  ],
  "preserved_features": ["feature_name 목록"]
}

[금지]
- 카탈로그 라벨(심화 케이스·복잡도 등) 본문에 노출 X · LD 친화 자연 워딩만
- step·bullet 수 강제 X · 본문 분량은 시수에 맞춰 자연 박힘
- input.json.security·hours·level 본문 반영 X (Phase 3 영역)
```

**LLM 파라미터**: `temperature=0` + `response_format=json_schema` 권장.

**산출**:
- `m4_long_text` (long.md M4 섹션에 들어갈 본문)
- `catalog_patterns_used` (long-meta.json catalog_patterns.m4)
- `p3_pending_candidates` (long-meta.json p3_pending_candidates 후보)
- `preserved_features` (의무 게이트 1 source)

**수락 기준**:
- M4 long 본문 산출 완료
- short M4 본문이 long 본문 안에 보존 (재생성이지 폐기 X)
- catalog_patterns_used top 1~2 식별
- 카탈로그 라벨이 본문에 노출 0건

---

## Step 4 [Core·LLM 호출 2]: M3 long 합성

**입력**: `context` + Step 3 산출 (`m4_long_text` · `catalog_patterns_used`).

**LLM 프롬프트 핵심**:

```
당신은 curriculum-builder Phase 2 공정 2의 M3 long(4h) 합성 작업자입니다.

[목표]
short M3 (2h)의 task 흐름·핵심 feature·학습 목표 의미를 보존하고, long(4h) 분량의 추가 학습 활동을 합성합니다.
M3 = 기초 실습 모듈 (feature 익힘 단계). M4 변화를 따라가서 정합 유지.

- 보존 영역: short의 학습 흐름·핵심 feature·학습 목표 의미
- 정정 OK 영역: 미세 워딩·앞뒤 step 정정·세부 step 자연 추가·LD 이해 풀이 정정
- 차단 영역: M3 본질(feature 익힘) 통째 폐기·M4 task 통합과 본문 영역 섞임

[입력]
- short M3 본문
- curriculum-post-factcheck.md M3 모듈
- M4 long 합성 결과 (Step 3 산출)
- factcheck 통과 feature 집합

[원칙]
- 카탈로그 직접 적용 X — M4 변화 자연 따라감
- M3 = feature 익힘이라 카탈로그 6 카테고리 직접 적용보다 M4 expanded 영역의 feature 기초 학습 자연 박힘
- short M3 본문 보존 + 확장 합성

[보존·차단]
- 의미 보존 4 영역 (feature·도구·task 큰 틀·모듈 본질) 정합
- anti-patterns MECE 6 위반 0건
- 모듈 본질: M3 = feature 익힘. M4 task 통합과 안 섞임 (M3에 task 큰 흐름 박힘 X)

[출력 형식]
{
  "m3_long_text": "{long.md M3 섹션 본문}",
  "m4_alignment_notes": "{M4 변화 따라간 영역 요약}",
  "preserved_features": ["..."]
}
```

**산출**: `m3_long_text` + alignment 메모.

---

## Step 5 [Core·LLM 호출 3]: M2 long 합성 또는 정직 표기

**입력**: `context` + Step 3·4 산출.

**LLM 프롬프트 핵심**:

```
당신은 curriculum-builder Phase 2 공정 2의 M2 long(2h) 합성 작업자입니다.

[목표]
short M2 (1h) 본문을 받아 long(2h) 합성. 단 추가 거리 자체 판정 후 분기:
- 추가 거리 있음 → 새 학습 활동 합성 (확장 영역만)
- 추가 거리 없음 → "short과 동일·시간 활용 제안" 정직 표기

M2 = 활용 맥락(When/Why) 모듈. 도구 깊이 단계.

[자체 판정 기준]
다음 중 1건이라도 "있음"으로 판정되면 expanded 합성:
- short M2에 미포함된 활용 맥락 시나리오가 본 task에 적합
- short M2 본문이 1h 분량 대비 압축적이라 풀어 설명할 자연 거리 있음
- factcheck 통과 feature 중 M2 활용 맥락에 적합한데 안 다뤄진 영역

다음에 해당하면 short_equivalent 정직 표기:
- short M2가 이미 충분히 풀어져 있고 새 시나리오 거리 약함
- 분량 늘리려면 같은 내용 반복·풀이 부풀리기만 가능 (anti-pattern E)

[정직 표기 본문 형태]
short_equivalent 결정 시 long M2 섹션 본문:

  본 시수에서는 short(1h)과 동일한 학습 활동을 진행합니다.
  추가 시간(1h)은 LD가 톤앤매너·주제 깊이·실습 추가 등 영역에서 자유롭게 활용하시도록 제안합니다.

(short M2 본문 그대로 + 위 정직 표기 추가)

[출력 형식]
{
  "label": "expanded | short_equivalent",
  "m2_long_text": "{long.md M2 섹션 본문}",
  "rationale": "{판정 근거 — expanded이면 추가 거리 영역, short_equivalent이면 부풀리기 회피 근거}",
  "honest_marking_text_present": true | false
}

[금지]
- 의미 없는 분량 채움 X (anti-pattern E 위반)
- "있음" 판정 시도 강제 X — 자연 평가
```

**산출**: `m2_long_text` + label + rationale.

---

## Step 6 [Core·LLM 호출 4]: M1 long 합성 또는 정직 표기

**입력**: `context` + Step 3~5 산출.

**LLM 프롬프트 핵심**: Step 5와 같은 흐름. M1 = 도구 소개(기능 카테고리) 모듈. M1은 도구 소개라 추가 거리 적은 경향이 자연 — short_equivalent 결과가 자연스러운 빈도 ↑.

```
[자체 판정 기준 — M1 특화]
expanded 결정 가능 영역:
- factcheck 통과 feature 중 short M1에 안 다뤄진 기능 카테고리 추가 거리 있음
- 도구 카테고리(생성형 LLM·이미지·코드 등)별 비교 도입 거리 있음 (단 anti-pattern A 회피 — task 흐름 분리 아닌 카테고리 비교)

short_equivalent 결정 영역:
- short M1이 이미 도구 핵심 기능 카테고리 충분 소개
- 1h 추가 시간이 같은 도구 더 깊은 소개로는 의미 없음

[모듈 본질]
M1 = 기능 카테고리. M2(활용 맥락)·M3(feature 익힘)·M4(task 통합)와 안 섞임.
M1 long에 task 통합 시나리오 박힘 X.

[출력 형식]
{
  "label": "expanded | short_equivalent",
  "m1_long_text": "...",
  "rationale": "...",
  "honest_marking_text_present": true | false
}
```

**산출**: `m1_long_text` + label + rationale.

---

## Step 7 [Check·LLM 호출 5]: 자체 점검 11 게이트 + meta 통합

**입력**: short.md·long.md (Step 2~6 합본) + curriculum-post-factcheck.md (정합 source) + factcheck-result.json (feature 보존 source) + Step 3~6 산출 메타.

**작업**:
1. short.md·long.md 합본 산출 (도구별 섹션 + 모듈 합본)
2. 11 게이트 자체 점검 LLM 호출
3. meta 통합 산출 (short-meta.json·long-meta.json gate_results·observations·catalog_patterns·honest_marking 채움)

**LLM 프롬프트 핵심**:

```
당신은 curriculum-builder Phase 2 공정 2 자체 점검 작업자입니다.
산출된 short.md·long.md를 11 게이트 기준으로 자체 점검합니다.

[입력]
- short.md 합본
- long.md 합본
- curriculum-post-factcheck.md (1차 source)
- factcheck 통과 feature 집합
- 모듈별 라벨 (Step 5·6 산출)
- catalog_patterns (Step 3 산출)
- p3_pending_candidates (Step 3 산출)

[의무 게이트 8건 — 1건이라도 fail 시 사용자 인계]
1. feature 보존 — factcheck 통과 feature 누락 0건. 도구별 적용 feature 명 그대로 박힘
2. 도구 정합 — M1·M2·M3·M4 각 도구 영역 안 섞임 (m1-chatgpt 안에 m1-gemini 등장 X)
3. task 큰 틀 보존 — M4 시작·중간·끝 3 큰 단계 유지·통째 폐기·순서 통째 정정 0건. 통째 정정 케이스 발견 시 사용자 인계 (자동 정정 X)
4. anti-patterns MECE 6 [거절] 위반 0건 (A·B·C·D·E·F)
5. 정직 표기 검증 — module_labels.{m1|m2}=short_equivalent인 모듈에 정직 표기 본문 박힘
6. 카탈로그 적용 추적 — M4 long catalog_patterns top 1~2 기재·본문 자연·LD 라벨 노출 X·step·bullet 수 강제 X
7. 모듈 본질 흐름 — M1=기능 카테고리·M2=도구 깊이·M3=feature 익힘·M4=task 통합. 큰 틀 통째 위반 시 사용자 인계·미세 침투는 관찰 메모
8. 시수 메타 일치 — input.json 시수 = 산출 메타 시수 일치 (short 1·1·2·2 / long 2·2·4·4)

[관찰 게이트 3건 — warning 메모·산출 통과]
9. long↔short 일관성 — curriculum-post-factcheck 기본 틀 자연 보존·강제 X·관찰만
10. 모듈별 라벨 정합 — module_labels(expanded·short_equivalent)가 본문 영역과 정합
11. 본문 분량 vs 시수 정합 — 본문 mini·step·bullet 분량이 시수 영역 자연 박힘·정확 매핑 X·관찰만

[출력 형식]
{
  "obligatory_8": {
    "feature_preservation": "PASS | FAIL",
    "tool_alignment": "PASS | FAIL",
    "task_skeleton": "PASS | FAIL | NEEDS_USER_REVIEW",
    "anti_patterns_zero": "PASS | FAIL",
    "honest_marking": "PASS | FAIL | N/A_short",
    "catalog_tracking": "PASS | FAIL | N/A_short",
    "module_essence": "PASS | FAIL | NEEDS_USER_REVIEW",
    "hours_meta": "PASS | FAIL"
  },
  "observation_3": {
    "long_short_consistency": "OK | WARNING",
    "module_label_alignment": "OK | WARNING",
    "content_volume_vs_hours": "OK | WARNING"
  },
  "violations": [
    { "gate": "anti_patterns_zero", "category": "A | B | C | D | E | F", "module": "m4 | ...", "evidence": "..." }
  ],
  "user_handoff_required": [
    { "gate": "task_skeleton | module_essence", "reason": "...", "module": "..." }
  ],
  "observations": [
    { "type": "warning | minor | info", "module": "...", "note": "..." }
  ]
}
```

**산출 후 처리**:
- 의무 8 모두 PASS·관찰 3 OK·violations 빈 배열 → 산출 통과·다음 공정 자동 호출
- 의무 8 중 1건 fail (NEEDS_USER_REVIEW 포함) → ralph fail·사용자 검토 인계 (task 큰 틀·모듈 본질 통째 위반은 자동 정정 X)
- 관찰 3 fail → warning 메모 + 산출 통과
- p3_pending_candidates 영역 → long-meta.json 기재 + 사용자 인계 (LLM 임의 적용 X)

**산출**:
- `phase2/blocks/short-meta.json` (gate_results·observations 채움)
- `phase2/blocks/long-meta.json` (gate_results·observations·catalog_patterns·p3_pending_candidates·honest_marking 채움)
- LD 고지 1회 (산출 요약)

**수락 기준**:
- 의무 8 게이트 결과 모두 PASS 또는 명시적 NEEDS_USER_REVIEW + 인계 메모
- 관찰 3 게이트 결과 OK 또는 WARNING + 메모
- meta json 4 key (module_labels·hours·gate_results·observations) 모두 채움
- long-meta.json catalog_patterns·honest_marking·p3_pending_candidates 추가 3 key 채움

---

## 카탈로그 6 카테고리 (긍정 — 추가 가능 패턴)

★ 기본 권장 (가장 자연스러운 확장)
- 심화 케이스 추가: 같은 task의 데이터·도메인 복잡도 한 단계 위에서 다시 풀어보기
- 복잡도 1단계 상승: 수강생 인지·경험 수준이 한 단계 높다고 가정한 실습
- 미사용 feature 추가: skill 3에서 뽑힌 feature 중 task에 적합한데 안 사용된 영역 추가

★ Case 적합 시 OK
- 비교·평가 단계: 같은 결과물을 다른 방식·다른 도구로 만들고 비교 평가
- 실패 케이스 회고: task 실습 흐름 중 실패 케이스 발생 시점에서 어떻게 해결해나가는지 자체를 실습 bullet으로 추가
- 협업·검증 단계: 실습 단계에서 수강생끼리 협업해서 만드는 내용 / 또는 실습 마친 후 서로 피드백·검증하는 단계 bullet 추가

### 적용 흐름

- M4 long 합성 시 카탈로그 영역 자연 흡수 — "몇 건 적용" 강제 X
- 합성 후 영향 큰 top 1~2 카테고리 식별 → `long-meta.json catalog_patterns.m4`에 기재
- 본문은 LD 친화 자연 워딩 — 카탈로그 라벨 노출 X
- M3·M2·M1 = M4 변화 따라감 (카탈로그 직접 적용 X)

### 6 catch X 발견 시 처리

```
6 카테고리 매칭 영역 = 자연 적용

6 catch X but 다음 3 영역 모두 OK 영역 발견 시 = 산출 메타 후보 메모 + 사용자 인계
  - task 흐름 정합 (M4 task 본질 흐름 시작·중간·끝에 자연 박힘)
  - 실습 본질 부합 (학습 활동 영역·이론·암기 X)
  - LD 납득 가능 (LD가 본 산출 받았을 때 어색 X)
  → long-meta.json p3_pending_candidates에 기재
  → LLM 임의 본문 적용 X·사용자 결정 후 적용 또는 폐기

6 catch X + 3 영역 중 1건이라도 X = 폐기·메모 X
```

---

## Anti-patterns MECE 6 카테고리 [거절]

3축 분류:

**분리 억지 (mini 쪼개기)**
- A. task 흐름 억지 분리 — 같은 task 흐름인데 단계 별개 mini로 잘게 쪼개기
- B. 데이터 범위·예시만 다르게 분리 — 본질 동일·데이터 범위·예시 숫자만 바꿔서 별개 mini 박음
- C. 활동 방식만 다르게 분리 — "정리한다"·"분류한다"·"검토한다" 동사만 바꿔서 별개 mini 박음

**반복 과잉 (한 mini 안)**
- D. 같은 feature 단순 반복 — 같은 feature가 **같은 활용 방식·같은 분야**로 mini 여러 곳 반복 등장
  - ★ 허용 영역: 같은 feature의 **다른 활용 방식·다른 분야·다른 깊이** (예: ChatGPT ADA mini 1 "기본 차트 생성" / mini 2 "다중 데이터셋 비교 분석" / mini 3 "이상치 탐지 시나리오"는 허용 — 카탈로그 "복잡도 1단계 상승"·"미사용 feature 추가" 영역과 정합)
  - ❌ 차단 영역: 같은 feature·같은 활용 방식·같은 분야 단순 반복 (예: mini 1·2·3 모두 "ADA로 매출 데이터 분석"이면 D 위반)
- E. 설명·말만 길게 부풀리기 — mini 1개 안에서 같은 내용을 풀이로 분량만 늘림

**task 부적합**
- F. 무관 feature 포함 — task 흐름과 안 맞는 feature 끼워넣기

★ **6 카테고리 위반 0건** = 의무 게이트 4. 통합 채택 우선 — 동일 실습 통합 우선·진짜 독립 학습 활동일 때만 분리.

---

## 의미 보존 점검 4 영역

| 영역 | 무엇 보존 |
|---|---|
| feature 보존 | factcheck 통과 feature 누락 X (도구별 적용 feature 명 그대로 박힘) |
| 도구 정합 | M1·M2·M3·M4 각 도구 영역 정합 (m1-chatgpt vs m1-gemini 도구 영역 안 섞임) |
| task 큰 틀 보존 | M4 시작 → 중간 → 끝 큰 단계 유지·feature 추가 시 세부 step 자연 추가·앞뒤 step 미세 정정 OK·step 통째 폐기·순서 통째 정정 X (β 옵션) |
| 모듈 본질 흐름 | M1·M2·M3·M4 본질 영역 안 섞임 |

**워딩 정정 OK 영역** = 자연 한국어 풀이·분량 압축·딱딱한 워딩 정정·새 추가 영역 (재생성). **핵심 명사**(도구·feature·task 명)는 그대로 유지.

★ SHA-256 pre/post 일치 강제 = **폐기** (재생성 흐름과 충돌). 의미 차원 점검으로 대체.

---

## 자체 검증 11 게이트

### 의무 게이트 (8건 · fail 시 사용자 인계)

| # | 게이트 | 점검 |
|---|---|---|
| 1 | feature 보존 | skill 3·factcheck 통과 feature 누락 X |
| 2 | 도구 정합 | M1·M2·M3·M4 각 도구 영역 안 섞임 |
| 3 | task 큰 틀 보존 | M4 시작·중간·끝 3 큰 단계 유지·통째 폐기·순서 통째 정정 X·통째 정정 케이스 = 사용자 인계 |
| 4 | 4 위반 패턴 [거절] | anti-patterns MECE 6 카테고리 (A·B·C·D·E·F) 위반 0건 |
| 5 | 정직 표기 검증 | 추가 거리 없을 때 "short과 동일·시간 활용 제안" 박힘 |
| 6 | 카탈로그 적용 추적 | M4 long 메타에 영향 큰 패턴 top 1~2건 명시·본문 자연·LD 노출 X·step·bullet 수 강제 X |
| 7 | 모듈 본질 흐름 | M1=기능 카테고리·M2=도구 깊이·M3=feature 익힘·M4=task 통합·큰 틀 통째 위반 시 사용자 인계·미세 침투는 관찰 메모 |
| 8 | 시수 메타 일치 | input.json 시수 = 산출 메타 시수 일치 (숫자 4개 — 1·1·2·2 / 2·2·4·4) |

### 관찰 게이트 (3건 · warning 메모 · 산출 통과)

| # | 게이트 | 점검 |
|---|---|---|
| 9 | long↔short 일관성 | curriculum-post-factcheck 기본 틀 자연 보존·강제 X·관찰만 |
| 10 | 모듈별 라벨 정합 | 각 모듈 자유 라벨 (expanded·short_equivalent)·라벨이 본문 영역과 정합 |
| 11 | 본문 분량 vs 시수 정합 | 본문 mini·step·bullet 분량이 시수 영역 자연 박힘·정확 매핑 X·관찰만 |

### task 큰 틀 통째 정정 케이스 처리

ralph fail 후 사용자 검토 인계·자동 정정 X (희박 케이스). 게이트 3·7 위반은 자동 fail이 아니라 `NEEDS_USER_REVIEW` 라벨 + 사용자 인계.

---

## scope (침범 금지)

- **통합본 `final-curriculum.md`** — 공정 4 영역 (본 공정 X)
- **공정 3 (block-refinement)** — 워딩·톤앤매너 정정 영역 (본 공정 X)
- **공정 4 (final-curriculum)** — 공정 1~3 산출 통합 final
- **Phase 3 (LD-Claude 대화 조정)** — AX팀 구현 영역 밖
- **Skill 5~8 (Phase 1)** — 본 공정에서 재호출 X (옵션 B)
- **Skill 8 원본 불침해** — M1 영역 처리는 본 공정의 LLM 프롬프트 안에서만

**input 값 직접 참조 금지**:
- `input.json.security` — Phase 3 영역
- `input.json.hours` — 표준 grid 고정 (1·1·2·2 / 2·2·4·4) 사용
- `input.json.level` — Phase 3 영역

**원본 불침해**:
- `curriculum-post-factcheck.md` 변경 X (읽기만)
- `factcheck-result.json` 변경 X (읽기만)
- `m{N}-{tool}.v2.md` · `m{N}-{tool}.md` 변경 X (읽기만)

---

## LD 고지 (1회 · Step 7 후)

```
[시수별 모듈 블록 생성 완료]

대상: {tools 목록} × M1~M4 × short(6h)·long(12h) 두 세트

표준 시수:
- short (합 6h): M1 1h · M2 1h · M3 2h · M4 2h
- long (합 12h): M1 2h · M2 2h · M3 4h · M4 4h

결과 요약:
- short: {tools 수}개 도구 × 4 모듈 — 1차 source 본문 그대로 재단
- long: 모듈별 차등
  · M3·M4: 적극 합성 (확장 학습 활동 추가)
  · M2·M1: {expanded N건 / short_equivalent M건 — 정직 표기로 시간 활용 제안}

자체 점검:
- 의무 게이트 8건: {모두 PASS / 일부 사용자 인계 N건}
- 관찰 게이트 3건: {OK / WARNING N건}

{p3_pending_candidates 있을 시:}
사용자 결정 필요 영역: {N}건 (long-meta.json p3_pending_candidates 참조)

산출:
- phase2/blocks/short.md
- phase2/blocks/long.md
- phase2/blocks/short-meta.json
- phase2/blocks/long-meta.json

다음 공정 (워딩·톤앤매너 정정)이 본 산출을 자동 input으로 사용합니다.
```

**LD 고지 원칙**:
- 카탈로그 라벨(심화 케이스·복잡도 등) 노출 X
- 게이트 ID(의무 1·관찰 9 등)는 사용자 인계용 표 한정 — LD 본문 노출 X
- 본문 분량 정확 수치 강제 X (자연 표현)

---

## 실패 처리

### LLM 1회 자동 재시도 (low-level 호출 안정성)
- LLM 호출 (Step 3~7)이 호출 자체로 실패 (타임아웃·JSON 파싱 실패·rate limit 등) 시 같은 step 안에서 1회 자동 재시도
- 게이트 검증 fail은 본 영역 X — ralph 루프가 처리
- 2회 호출 실패 시 ralph iteration fail로 보고

### 자체 재합성 시도 (high-level 게이트 fail 정정·2회 한정)

prd.json stories 모두 passes:true 될 때까지 ralph 루프가 iteration 반복하지만, 본 공정 2 자체에서는 **게이트 fail 시 자동 재합성 시도를 2회로 한정**한다 (LLM 호출 낭비·명백 자동 정정 어려움 영역에서 호출 폭주 차단). 의무 게이트 fail 시 자동 정정 영역과 사용자 인계 영역이 분리:

| 게이트 | 처리 방식 | 자체 재합성 한도 |
|---|---|---|
| 의무 1 (feature 보존) | 자동 정정 — 누락 feature 합성 | 2회 |
| 의무 2 (도구 정합) | 자동 정정 — 도구 영역 정합 강화 | 2회 |
| 의무 3 (task 큰 틀 보존) | **사용자 인계** (자동 정정 X) — task 통째 폐기·순서 통째 정정 위험 영역 | 0회 (즉시 인계) |
| 의무 4 (anti-patterns 0건) | 자동 정정 — 위반 mini 통합 또는 폐기 | 2회 |
| 의무 5 (정직 표기) | 자동 정정 — 정직 표기 본문 추가 | 2회 |
| 의무 6 (카탈로그 추적) | 자동 정정 — meta 기재 보강 | 2회 |
| 의무 7 (모듈 본질 흐름) | **사용자 인계** (자동 정정 X) — 본질 통째 위반 LLM 임의 정정 위험 | 0회 (즉시 인계) |
| 의무 8 (시수 메타 일치) | 자동 정정 — meta 시수 일치 | 2회 |

→ **자동 정정 영역 6건** (의무 1·2·4·5·6·8) + **즉시 사용자 인계 영역 2건** (의무 3·7).

→ **2회 한정 의미**: 자동 정정 영역 게이트 fail 시 같은 게이트 자체 재합성 최대 2회 시도. 2회 후도 fail = Case A 사용자 인계.

→ **LLM 1회 재시도 vs 자체 재합성 2회 구분**:
  - LLM 1회 재시도 = 호출 자체 실패 (타임아웃·JSON 파싱 등) → 같은 step 안에서 1회 (low-level 호출 안정성)
  - 자체 재합성 2회 = 게이트 검증 fail → 다음 iteration에서 정정 후 재산출 (high-level 품질 정정)
  - 두 영역은 별도 — LLM 재시도는 호출 안정성·자체 재합성은 task 완료 정정

### Case A (LD 조치 가능)
- 의무 게이트 1·2·4·5·6·8 fail → ralph 재시도 자동 정정
- 의무 게이트 3·7 fail → 사용자 검토 인계 (자동 정정 X·LLM 임의 정정 위험)
- 관찰 게이트 9·10·11 fail → warning 메모·산출 통과·ralph 재시도 X

### Case B (시스템 오류 — 즉시 중단)
- `curriculum-post-factcheck.md` 부재 → 공정 1 후속 (skill-curriculum-rebuild) 선행 요구
- `factcheck-result.json` 부재 → 공정 1 (skill-factcheck) 선행 요구
- `input.json` 파싱 실패 → 원인 명시 후 중단

---

## references 폴더 정책 (v4)

본 SKILL.md는 **references/ 폴더 미사용**. 카탈로그 6 카테고리·anti-patterns MECE 6·11 게이트·의미 보존 4 영역 모두 본 SKILL.md 본문에 통합. v3 자료(rubric.md·prompts_*.md·module-schema.md)는 `.omc/plans/curriculum-builder-hours-blocks-v4-spec/backup/references/`에 보관.

**근거**: 결정 12번 — 사례 박음 영역도 SKILL.md 본문 통합. references/ 폴더 X (또는 빈 영역). 단일 파일 운영으로 spec 인지 비용 절감.

---

## 사례 (1차 추출 후 사용자 정합 판단 영역)

★ 본 섹션은 사례 추출 작업 후 사용자 정합 판단을 거쳐 채택된 영역만 통합. 정확 매칭 의무 (4/30 LG생건 산출 자료 등 매칭 점검 source). 1차 추출 후 사용자 인계 → 채택 또는 폐기.

### 카탈로그 매칭 사례 (긍정 — 1~2건 영역)

[추출 작업 후 사용자 채택 영역만 박힘]

### Anti-patterns 매칭 사례 (결함 — 1~2건 영역)

[추출 작업 후 사용자 채택 영역만 박힘]

---

## 완결 원칙 요약

1. **short = 재단** (LLM 호출 X·복사 + 시수 라벨)·**long = 옵션 c 모듈별 차등** (M3·M4 적극 재생성·M2·M1 추가 거리 있으면 합성·없으면 정직 표기)
2. **산출 4건 통합** (short.md·long.md·short-meta.json·long-meta.json·meta 안 observations 통합)
3. **카탈로그 6 카테고리 자연 흡수** + anti-patterns **MECE 6 [거절] 위반 0건** + 자체 검증 **11 게이트** (의무 8 + 관찰 3)
4. **의미 보존 점검 4 영역** (feature·도구·task 큰 틀·모듈 본질) — SHA-256 강제 폐기
5. **호출 5회** (long 합성 4 + 자체 점검 1) — 옵션 B (skill 5~8 재호출 X)·역산 순서 M4→M3→M2→M1
6. **task 큰 틀 통째 정정 케이스 = 사용자 인계** (자동 정정 X)
7. **6 catch X but 3 영역(task 흐름·실습 본질·LD 납득) 모두 OK 발견 시 = p3_pending_candidates 메모 + 사용자 인계** (LLM 임의 적용 X)
8. **LD 친화 자연 워딩** — 카탈로그·게이트 라벨 본문 노출 0건
9. **원본 불침해** (curriculum-post-factcheck·factcheck-result·m{N}-{tool}.v2.md·.md 모두 읽기만)
10. **references/ 폴더 미사용** — 본 SKILL.md 본문 통합
