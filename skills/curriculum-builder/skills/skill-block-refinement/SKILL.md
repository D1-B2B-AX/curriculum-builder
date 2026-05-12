---
name: block-refinement
description: curriculum-builder Phase 2 공정 3 (v4). 공정 2 산출 4건(phase2/blocks/{short.md·long.md·short-meta.json·long-meta.json})을 받아 커리큘럼 표 bullet 워딩·표현만 LD 친화 spec 정합으로 정밀 보강. 모듈 구성 설명 산문체는 손대지 X (공정 4 영역). 산출 4건 (phase2/block-refinement/{short-refined.md·long-refined.md·short-meta-refined.json·long-meta-refined.json}) = 공정 2 산출 복사 + 변경 부분만 정정 + observations 메모 통합. Shell 차원 인계 점검 (파일 존재 + gate_results PASS) · 자체 검증 5 게이트 (의무 5·관찰 0) · 호출 budget 3회 (Step 2 short-refined·Step 3 long-refined·Step 4 점검) · long fallback 6회.
---

# Phase 2 공정 3: Block-Refinement (v4)

curriculum-builder Phase 2의 세 번째 공정. 공정 2 산출(시수별 두 세트 — short 6h·long 12h)을 받아, **커리큘럼 표 영역의 bullet 워딩·표현만** LD 친화 spec 정합으로 정밀 보강한다. 모듈 구성 설명(산문체 3~5줄)과 메타 영역은 손대지 않는다 — 이 두 영역은 공정 4가 처리한다.

---

## 본 공정의 위치

```
공정 1 (factcheck)
  → 공정 1 후속 (curriculum-rebuild)        [curriculum-post-factcheck.md 산출]
  → 공정 2 (hours-blocks)                   [short·long 두 세트 4건 산출]
  → 본 공정 (block-refinement)              [표 bullet 워딩 정정·-refined 4건 산출]
  → 공정 4 (final-curriculum)               [모듈 구성 설명 보완 + 통합 final 산출]
```

| 항목 | 내용 |
|---|---|
| 1차 input source | `phase2/blocks/{short.md, long.md, short-meta.json, long-meta.json}` 4건 (공정 2 산출) |
| 보조 input | `phase2/factcheck/curriculum-post-factcheck.md` (meta 변경 표시 시) · `input.json` (회사·직무·도구·주제 4건만) |
| Output | `phase2/block-refinement/{short-refined.md, long-refined.md, short-meta-refined.json, long-meta-refined.json}` 4건 |
| 인계 점검 | Shell 차원 — (a) 산출 4건 파일 존재 + (b) meta.json gate_results PASS 키 확인. LLM 점검 X |
| LLM 호출 | 총 3회 (short-refined 1 + long-refined 1 + 자체 점검 1) — Shell 영역 0회 |
| Long fallback | long 토큰 한계 시 long만 모듈 단위 분리 (총 6회·매우 드문 시나리오) |

---

## 본 공정의 사명

curriculum-builder Phase 2 사명 4 영역 중 **(3) 톤앤매너 source 정합** + **(4) LD 친화 설명** 영역 담당. 단 본 공정은 **표 bullet 영역만** 정정한다 — 모듈 구성 설명(산문체)·메타 영역은 공정 4 책임.

### 톤앤매너 source 2건 (모두 정합 의무)

| # | source | 본문 |
|---|---|---|
| (a) | Phase 1 조합 spec + `curriculum.md` 모델 (한 묶음) | skill-phase1-curriculum-assembly의 §"Bullet 작성 원칙" spec과 그 산출물(`curriculum.md`)이 한 출처. spec 본문이 LD 친화 영역을 정의하고 산출물이 사례 — 본 SKILL.md §"Bullet 작성 원칙 5건"으로 차용·정정 |
| (b) | BGF리테일 제안서 톤앤매너 (사용자 초기 제공·외부 표준) | bullet 짧은 명사구 패턴·실습 내용 구조 한정 차용. 미차용 영역(4 컬럼·실습 마커·sub 시수·교육 목표)은 본 도구 산출 박지 X |

★ 위 (a)·(b) 모두 정합해야 표준 톤앤매너 (단순 게이트 추상 X·두 source 본문 모두 인지 의무).

### 핵심 의도

- LD 검토용 표준 spec 정합 — 한눈에 보는 표 영역의 워딩이 자연 한국어·짧은 명사구·LD 친화
- 본 도구 내부 메타·식별자·patch cycle 워딩이 표에 노출 0건
- 교안 풍·구술 표현·학습 깊이·학습 흐름 안내가 표 bullet에 박힘 0건
- 공정 2 산출의 학습 내용·구조·feature는 그대로 보존 — 워딩 정정만

★ "공정 3 = 표 워딩 영역 / 공정 4 = 모듈 구성 설명 + 통합" — 두 공정의 책임이 명확히 분리됨.

---

## Input

| 파일 | 필수 여부 | 용도 |
|---|---|---|
| `phase2/blocks/short.md` | ★ 필수 | 1차 source. 표 bullet 정정 base |
| `phase2/blocks/long.md` | ★ 필수 | 1차 source. 표 bullet 정정 base |
| `phase2/blocks/short-meta.json` | ★ 필수 | gate_results PASS 인계 점검·observations 메모 통합 base |
| `phase2/blocks/long-meta.json` | ★ 필수 | gate_results PASS 인계 점검·observations·catalog_patterns 메모 통합 base |
| `phase2/factcheck/curriculum-post-factcheck.md` | 조건부 참고 | meta.json observations에 변경 표시 있을 때만 read·산문체 패턴 인지용 |
| `input.json` | 조건부 참고 | 회사·직무·도구·주제 4건만 사용 (`company`·`role`·`tools[]`·`topic`). 시수·수준·보안은 미참조 |

**저장 위치**: 모두 `{run_folder}/` 하위. `run_folder`는 `input.json.run_folder` 값.

**미참조 영역** (본 공정에서 절대 읽지 않음):
- `m1~m4` 모듈 파일 (공정 2 산출에 이미 통합됨)
- `factcheck-result.json` · `tool-features.json` (공정 1·2 영역)
- `input.json.security` · `hours` · `level` (Phase 3 영역)

**spec 본문 흡수 가이드** (input 자체 X — 본 SKILL.md 본문에 자연 흡수된 가이드):
- BGF리테일 제안서 톤앤매너 (짧은 명사구 패턴·실습 구조 한정 차용. 4 컬럼·실습 마커·sub 시수·교육 목표는 미차용)
- `curriculum.md` 모듈 구성 설명 산문체 패턴 (Phase 1 조합 산출의 LD 친화 spec)

---

## Output (산출 4건 통합)

```
{run_folder}/phase2/block-refinement/
  ├── short-refined.md            (공정 2 short.md 복사 + 표 bullet 워딩 정정)
  ├── long-refined.md             (공정 2 long.md 복사 + 표 bullet 워딩 정정)
  ├── short-meta-refined.json     (공정 2 short-meta.json 복사 + observations 변경 메모 통합)
  └── long-meta-refined.json      (공정 2 long-meta.json 복사 + observations 변경 메모 통합)
```

★ **갈래 (γ) 채택** — 공정 2 산출을 그대로 복사한 뒤 **변경 부분만 정정**하고 변경 메모를 observations에 통합. 공정 2 원본(`phase2/blocks/`)은 보존되어 비교 가능.

**산출 파일명 정합**:
- `-refined` 접미사 — 공정 2 산출(`short.md`·`long.md` 등)과 비교 가능한 형태로 명시
- 폴더명 `phase2/block-refinement/` — skill 폴더명(`skill-block-refinement`) 정합

**공정 2 영역 보존**:
- `phase2/blocks/short.md`·`long.md`·`short-meta.json`·`long-meta.json` 4건 모두 그대로 보존 (본 공정 변경 X)
- 비교 검토용 — LD가 두 폴더 비교 시 공정 3 정정 영역 추적 가능

### 변경 메모 통합 (observations 영역)

`*-meta-refined.json`의 `observations` 영역에 본 공정의 변경 내역을 통합 박는다. 형식:

```json
"observations": [
  ...공정 2 기존 observations...,
  {
    "type": "block_refinement",
    "module": "m4",
    "tool": "ChatGPT",
    "before": "Canvas 기초 — 데이터를 정리한 다음 차트를 만들어서 인사이트를 도출하고 보고서로 정리해본다 (M4 Step 5 보고서 선행 학습)",
    "after": "Canvas로 데이터 분석 결과 시각화 및 보고서 작성",
    "rationale": "내부 메타·교안 풍·bullet 길이·통째 옮기기 4건 정정"
  }
]
```

★ **변경 추적 가능성 보장** — 공정 4가 본 메모를 read하여 정정 맥락 인지 가능. 공정 4 점검 영역 X·작업 자료.

---

## 공정 2 → 공정 3 인계 점검 (Shell 차원·LLM X)

본 공정 진입 시 Shell 차원 점검 2건만 수행한다. LLM 점검은 공정 2 ralph 2회 + 사용자 인계 흐름이 보장하므로 본 공정에서는 재검증하지 않는다.

| # | 점검 | 차원 | 처리 |
|---|---|---|---|
| (a) | `phase2/blocks/{short.md, long.md, short-meta.json, long-meta.json}` 4건 파일 존재 | Shell (파일 시스템) | 부재 시 Case B 시스템 오류 — 공정 2 선행 요구 |
| (b) | `short-meta.json` · `long-meta.json` 의 `gate_results.obligatory_8` 키 모두 `PASS` (또는 의무 게이트 결과 통과) | Shell (JSON 파싱) | fail 키 발견 시 Case B — 공정 2 영역에서 차단 의무·본 공정 진입 X |

**점검 코드 의향**:
```python
import json, os

phase2_dir = f"{run_folder}/phase2/blocks"
required_files = ["short.md", "long.md", "short-meta.json", "long-meta.json"]

# (a) 파일 존재
for f in required_files:
    if not os.path.exists(f"{phase2_dir}/{f}"):
        raise CaseBError(f"공정 2 산출 부재: {f}. 공정 2 선행 의무")

# (b) gate_results PASS
for meta_file in ["short-meta.json", "long-meta.json"]:
    with open(f"{phase2_dir}/{meta_file}", encoding="utf-8") as fp:
        meta = json.load(fp)
    obligatory = meta.get("gate_results", {}).get("obligatory_8", {})
    fails = [k for k, v in obligatory.items() if v not in ("PASS", "N/A_short")]
    if fails:
        raise CaseBError(f"{meta_file} obligatory 게이트 fail: {fails}. 공정 2 재실행 의무")
```

★ **공정 2 fail 시 처리** — 공정 2 영역에서 사용자 인계로 차단된다. 본 공정 영역에서 자동 정정·재진입 처리 X. meta.json `observations` 메모는 본 공정 작업 시 LLM 참고 자료로 활용 (점검 영역 X).

---

## 실행 흐름 (3 LLM 호출)

```
Step 1 [Shell]: 인계 점검 (a)·(b) + 공정 2 산출 4건 phase2/block-refinement/ 폴더에 -refined 접미사로 복사
  ↓
Step 2 [Core·LLM 호출 1]: short-refined.md 표 bullet 워딩 정정 (m1~m4 통합 1 호출)
  ↓
Step 3 [Core·LLM 호출 2]: long-refined.md 표 bullet 워딩 정정 (m1~m4 통합 1 호출)
  ↓
Step 4 [Check·LLM 호출 3]: 자체 검증 5 게이트 + observations 변경 메모 통합 + meta-refined.json 산출
```

호출 분포: Shell 1 (Step 1) · Core 2 (Step 2·3) · Check 1 (Step 4). 합계 = **3회**.

**Long fallback** (매우 드문 시나리오): Step 3 long-refined.md 1 호출이 토큰 한계로 진입 어려운 경우, long만 모듈 단위 분리 (m4·m3·m2·m1 각 1 호출 = 4회) → 총 합계 6회. 본 fallback은 long.md가 매우 두꺼운 케이스에 한해 발동.

---

## Step 1 [Shell]: 인계 점검 + 산출 4건 복사 (LLM 호출 X)

**입력**: `phase2/blocks/{short.md, long.md, short-meta.json, long-meta.json}` 4건.

**작업**:
1. 인계 점검 (a)·(b) 수행 (위 §"공정 2 → 공정 3 인계 점검" 코드 의향 정합)
2. 점검 통과 시 `phase2/block-refinement/` 폴더 생성
3. 공정 2 산출 4건을 `-refined` 접미사로 복사:
   - `short.md` → `short-refined.md`
   - `long.md` → `long-refined.md`
   - `short-meta.json` → `short-meta-refined.json`
   - `long-meta.json` → `long-meta-refined.json`
4. 헤더 blockquote 갱신 (생성 정보·공정 3 표시·1차 source 명시)
5. `input.json` 로드 (회사·직무·도구·주제 4건만 in-memory 보관)

**산출**:
- `phase2/block-refinement/{short-refined.md, long-refined.md, short-meta-refined.json, long-meta-refined.json}` 4건 (초안 — Step 2~4에서 본문·메타 정정)

**수락 기준**:
- 인계 점검 (a)·(b) 모두 통과 (4건 파일 존재 + obligatory 게이트 PASS)
- `phase2/block-refinement/` 폴더 생성 + 4건 복사 완료
- 헤더 blockquote 갱신 (공정 3 산출 명시·공정 2 1차 source 명시)
- 공정 2 원본(`phase2/blocks/`) 변경 0건

---

## Step 2 [Core·LLM 호출 1]: short-refined.md 표 bullet 워딩 정정

**입력**: Step 1의 `short-refined.md` (복사본·공정 2 short.md 내용 그대로) + `input.json` (회사·직무·도구·주제) + 본 SKILL.md §"자체 검증 5 게이트" + §"Bullet 작성 원칙 5건" + §"사례 (Before/After)" 본문.

**LLM 프롬프트 의향**:

```
당신은 curriculum-builder Phase 2 공정 3의 short-refined.md 표 bullet 정정 작업자입니다.

[목표]
short-refined.md 도구별 커리큘럼 표(M1~M4) 영역의 bullet 워딩·표현만 LD 친화 spec 정합으로 정정합니다.
모듈 구성 설명(산문체 3~5줄) 영역은 절대 손대지 않습니다 (공정 4 영역).

[입력]
- short-refined.md 본문 (공정 2 short.md 내용 — 정정 base)
- input.json (회사·직무·도구·주제 4건만)
- 본 cycle 워딩 정정 spec (게이트 5건·Bullet 작성 원칙 5건·Before/After 사례 1건)

[작업 영역]
- 도구별 § "커리큘럼 표 (한눈에 보기 — short, 합 6h)" 표 본문 — bullet 정정 영역 ★
- 모듈 구성 설명 (산문체) — 손대지 X (공정 4 영역)
- 헤더·메타·생성 정보 blockquote — 손대지 X

[정정 의무 — 5 영역]
1. bullet 길이 정합 — 짧은 명사구 형태. 한 bullet에 산출물·feature·방법이 같이 자연 박힘은 OK·**단 방법을 너무 자세히 세세한 step 나열로 풀어쓰는 패턴 X** (통째 옮기기·교안 풍 차단)
2. 교안 풍·구술 표현 차단 — "— 다음으로"·"여기서 ~을 통해"·"~서·~해본다"·"다음·여기서·그 다음" 같은 시간 흐름 워딩 0건
3. 커리큘럼 표 워딩 정합 — 모듈·step 식별자(M4 Step 5 등)·patch cycle 메타·"기초·심화" 같은 학습 깊이·"선행 학습"·"이후 단계 준비" 같은 학습 흐름 안내가 bullet 본문에 박힘 X
4. 같은 feature 단순 반복 X — 동일 feature가 같은 활용 방식·같은 분야로 반복 등장하는 패턴 X (다른 활용·다른 분야·다른 깊이는 OK·anti-pattern D 정합)
5. 동일 실습 통합 우선 — 활동 본질이 자연 통합되면 1 bullet. 진짜 독립 학습 활동일 때만 분리

[보존 의무 — 공정 2 산출 본질]
- 학습 내용·구조·feature 보존 (워딩 정정만)
- 도구 정합·M1~M4 모듈 본질 흐름 정합 (공정 2가 보장한 영역 유지)
- 시수 라벨·표 구조 4 컬럼·도구별 섹션 구조 변경 X

[표 bullet 박을 형태]
- 도구 + 활동 + (필요 시) 산출물 자연 박음
- 짧은 명사구 형태
- step 자연 통합 (활동 본질에 따라)·강제 분리 X

[금지]
- 모듈 구성 설명 산문체 영역 정정 X (공정 4 영역)
- 본 도구 내부 워딩 (P-11·factcheck pass·patch cycle·m{N}-{tool}.v2.md·★ 표시·patch_log·applied_definitions 등) 표 bullet 노출 X
- 학습 깊이 워딩 ("기초·심화") 표 bullet 노출 X
- 강의 풍 워딩 ("다음·여기서·그 다음·~해본다·~서·~고 나서") 표 bullet 노출 X
- 학습 흐름 안내 ("선행 학습"·"이후 단계 준비") 표 bullet 노출 X
- 한 bullet에 여러 step 통째 박음 X

[출력 형식]
JSON으로 다음 구조 산출:
{
  "short_refined_text": "{전체 short-refined.md 본문 — 표 bullet 정정 반영}",
  "changes": [
    {
      "module": "m4",
      "tool": "ChatGPT",
      "before": "{원 bullet}",
      "after": "{정정 bullet}",
      "rationale": "{정정 사유 — 5 영역 중 어느 영역 위반}"
    }
  ]
}
```

**LLM 파라미터**: `temperature=0` + `response_format=json_schema` 권장.

**산출**:
- `short_refined_text` (전체 short-refined.md 본문 — 표 bullet 정정 반영)
- `changes` (정정 내역 리스트 — Step 4 observations 통합 source)

**수락 기준**:
- 전체 short-refined.md 본문 산출 (도구별 표 + 모듈 구성 설명 + 메타 영역 모두)
- 모듈 구성 설명 산문체 영역 변경 0건 (공정 2 본문과 정확 일치)
- 표 bullet 영역 정정 사례 모두 `changes` 리스트에 기록
- 헤더·생성 정보 blockquote 변경 X (Step 1에서 갱신된 형태 유지)

---

## Step 3 [Core·LLM 호출 2]: long-refined.md 표 bullet 워딩 정정

**입력**: Step 1의 `long-refined.md` + `input.json` + 본 SKILL.md spec 본문 + Step 2 산출 (`changes` — long·short 정합 인지용).

**LLM 프롬프트 의향**: Step 2와 동일한 구조·작업. 단 long.md 영역 특수성 인지:
- long M3·M4 = expanded 모듈 (공정 2 카탈로그 6 자연 흡수). 표 bullet 영역 정정 시 catalog_patterns 라벨이 본문에 노출되지 않게 점검
- long M2·M1 = `short_equivalent` 모듈일 수 있음. 정직 표기 본문 (`"본 시수에서는 short(1h)과 동일한 학습 활동을 진행합니다..."`)은 모듈 구성 설명 영역이라 변경 X
- short-refined의 `changes`와 long-refined의 `changes`가 동일 패턴이면 정합 — long·short 표 bullet 워딩 일관

**산출**: `long_refined_text` + `changes` 리스트.

**수락 기준**: Step 2와 동일. 추가로 `short_equivalent` 모듈의 정직 표기 본문 변경 0건.

**Long fallback** (토큰 한계 시):
- m4 long 표 정정 → m3 → m2 → m1 각 1 호출 = 4 호출
- 모듈별 정정 후 통합 long-refined.md 합본 산출
- 총 호출 = 6회 (Step 1 Shell + Step 2 + Step 3-m4 + Step 3-m3 + Step 3-m2 + Step 3-m1 + Step 4)
- 매우 드문 시나리오. 일반 케이스는 Step 3 = 1 호출로 충분

---

## Step 4 [Check·LLM 호출 3]: 자체 검증 5 게이트 + observations 변경 메모 통합

**입력**: Step 2·3 산출(`short_refined_text`·`long_refined_text`·`changes` 통합) + 공정 2 산출 4건(정합 source) + 본 SKILL.md §"자체 검증 5 게이트" + §"사례".

**작업**:
1. short-refined.md·long-refined.md 합본 산출 (Step 2·3 본문 통합)
2. 자체 검증 5 게이트 LLM 호출 (의무 5건만 점검)
3. observations 변경 메모 통합 (Step 2·3 `changes` 리스트를 `*-meta-refined.json` observations 영역에 박음)
4. `short-meta-refined.json`·`long-meta-refined.json` 산출 (gate_results·observations 채움)

**LLM 프롬프트 의향**:

```
당신은 curriculum-builder Phase 2 공정 3 자체 점검 작업자입니다.
산출된 short-refined.md·long-refined.md를 5 의무 게이트 기준으로 점검합니다.

[입력]
- short-refined.md·long-refined.md (Step 2·3 산출 합본)
- 공정 2 short.md·long.md (정합 source)
- 정정 내역 리스트 (Step 2·3 changes 통합)

[5 의무 게이트 — 1건이라도 fail 시 사용자 인계]
1. bullet 길이 정합 — 표 bullet이 짧은 명사구 형태·통째 옮기기 패턴 0건·**방법을 시시콜콜 세세한 step 나열로 풀어쓰는 패턴 0건** (산출물·feature·방법 같이 자연 박힘은 OK)
2. 교안 풍 설명·구술 표현 차단 — "— 다음으로"·"여기서 ~을 통해"·"~서·~해본다"·시간 흐름 워딩(다음·여기서·그 다음) 표 bullet 노출 0건
3. 커리큘럼 표 워딩 정합 — 짧은 명사구·LD 인지 가능 워딩·내부 메타·식별자(M4 Step 5 등)·학습 깊이(기초·심화)·학습 흐름 안내(선행 학습) 표 bullet 노출 0건. 같은 feature 단순 반복 0건 (다른 활용·다른 분야·다른 깊이는 OK)
5. 변경 메모 통합 — Step 2·3 정정 내역이 *-meta-refined.json observations 영역에 박힘·변경 추적 가능성 보장 (격상 의무)
6. 공정 2 산출 본질 보존 — 워딩 정정만·내용·구조·feature 변경 0건. 모듈 구성 설명 산문체 영역 변경 0건. 헤더·메타·시수 라벨 변경 0건

★ 게이트 4 (모듈 구성 설명 LD 인지 정합) = 공정 4 영역. 본 점검 X.

[출력 형식]
{
  "obligatory_5": {
    "bullet_length": "PASS | FAIL",
    "lecture_style_block": "PASS | FAIL",
    "table_wording": "PASS | FAIL",
    "change_memo_integration": "PASS | FAIL",
    "phase2_essence_preservation": "PASS | FAIL"
  },
  "violations": [
    { "gate": "...", "module": "...", "evidence": "..." }
  ],
  "user_handoff_required": [
    { "gate": "...", "reason": "..." }
  ],
  "observations_to_integrate": [
    { "type": "block_refinement", "module": "...", "tool": "...", "before": "...", "after": "...", "rationale": "..." }
  ]
}
```

**산출 후 처리**:
- 의무 5 모두 PASS·violations 빈 배열 → 산출 통과·다음 공정 자동 호출
- 의무 1·2·3 fail → ralph 자동 정정 (Step 2·3 재호출·정정 사유 명시)
- 의무 5 fail → ralph 자동 정정 (observations 메모 보강)
- 의무 6 fail → **사용자 인계** (공정 2 산출 본질 손상 위험 영역·자동 정정 위험)

**산출**:
- `phase2/block-refinement/short-refined.md` (Step 2 본문 + 헤더 정합)
- `phase2/block-refinement/long-refined.md` (Step 3 본문 + 헤더 정합)
- `phase2/block-refinement/short-meta-refined.json` (gate_results·observations 채움)
- `phase2/block-refinement/long-meta-refined.json` (gate_results·observations·catalog_patterns 보존)
- LD 고지 1회 (산출 요약)

**수락 기준**:
- 5 의무 게이트 결과 모두 PASS
- `*-meta-refined.json`의 `observations` 영역에 Step 2·3 정정 내역 통합 박힘
- 공정 2 원본(`phase2/blocks/`) 변경 0건 (비교 검토용 보존)

---

## 자체 검증 5 게이트 (의무 5·관찰 0)

| # | 게이트 | 분류 | 점검 |
|---|---|---|---|
| 1 | bullet 길이 정합 | 의무 | 짧은 명사구 형태 + **방법 단계를 시시콜콜 세세하게 나열하는 패턴 X**. 단 한 bullet에 산출물·feature·방법이 같이 자연 박힘은 OK (방법이 너무 자세히 풀어진 통째 옮기기·교안 풍이 아닌 한). 핵심 기준 = "방법이 시시콜콜한 step 나열로 빠지냐" |
| 2 | 교안 풍·구술 표현 차단 | 의무 | "— 다음으로"·"여기서 ~을 통해"·"~서·~해본다"·시간 흐름 워딩(다음·여기서·그 다음·~고 나서) 표 bullet 노출 0건 |
| 3 | 커리큘럼 표 워딩 정합 | 의무 | 짧은 명사구·LD 인지 가능. 내부 메타·식별자(M4 Step 5·P-11 등)·학습 깊이(기초·심화)·학습 흐름 안내(선행 학습·이후 단계 준비) 표 bullet 노출 0건. 같은 feature 단순 반복 0건 (다른 활용·다른 분야·다른 깊이는 OK·anti-pattern D 정합) |
| 5 | 변경 메모 통합 (★ 격상) | 의무 | Step 2·3 정정 내역이 *-meta-refined.json observations 영역에 박힘·정정 추적 가능성 보장 |
| 6 | 공정 2 산출 본질 보존 | 의무 | 워딩 정정만 박힘·내용·구조·feature 변경 0건. 모듈 구성 설명 산문체 영역 변경 0건. 공정 2 영역 침범 0건 |

★ **게이트 4 (모듈 구성 설명 LD 인지 정합) = 공정 4 이동** (역할 분리). 본 공정 = 표 영역만 / 공정 4 = 모듈 구성 설명 보완 + 통합 final.

★ **관찰 게이트 = 0건** — 본 공정은 표 워딩 정정 영역으로 한정되어 있어 warning 메모로 통과시킬 영역 X. 모두 의무 게이트.

### 게이트 6 (본질 보존) 정합 본문

| 손대지 X 영역 | 사유 |
|---|---|
| 모듈 구성 설명 (산문체 3~5줄) | 공정 4 영역 |
| 헤더·생성 정보 blockquote | Step 1에서 정합 갱신·이후 변경 X |
| 메타 json의 `module_labels`·`hours`·`gate_results`·`catalog_patterns`·`honest_marking` | 공정 2 산출 그대로·observations만 통합 박음 |
| short_equivalent 정직 표기 본문 | 모듈 구성 설명 영역 (공정 4 영역) |
| 도구 정합·M1~M4 모듈 본질 흐름 | 공정 2가 보장한 영역 유지 |
| 시수 라벨 (1·1·2·2h / 2·2·4·4h) | 공정 2 산출 그대로 |

### 게이트 fail 처리

| 게이트 | 처리 | 자체 재합성 한도 |
|---|---|---|
| 1·2·3 (워딩 영역) | 자동 정정 — Step 2·3 재호출·정정 사유 명시 | 2회 |
| 5 (변경 메모) | 자동 정정 — observations 메모 보강 | 2회 |
| 6 (본질 보존) | **사용자 인계** (공정 2 산출 본질 손상 위험·자동 정정 위험) | 0회 (즉시 인계) |

→ **자동 정정 영역 4건** (의무 1·2·3·5) + **즉시 사용자 인계 영역 1건** (의무 6).

---

## Bullet 작성 원칙 5건 (Phase 1 §Bullet 차용·본 cycle 정정 정합)

본 5건은 Phase 1 조합 산출(skill-phase1-curriculum-assembly)의 §"Bullet 작성 원칙"에서 5건만 살리고, 본 cycle 결정 정합으로 정정한 영역. 표 bullet 정정 시 LLM 자체 인지 source.

| # | 원칙 | 본문 |
|---|---|---|
| 1 | 짧은 명사구 형태 | 표 bullet은 학습 주제·실습 단위 한 줄·짧은 명사구. 풀어 서술·교안 멘트 X |
| 2 | 도구 + 활동 자연 박음 | 도구 + 활동 + (필요 시) 산출물 자연 박음. 도구·feature 명시 의무·산출물 명시 강제 X |
| 3 | 같은 feature 단순 반복 X (★ 공정 2 anti-pattern D 정정 정합) | 동일 feature가 같은 활용 방식·같은 분야로 반복 등장 X. **단 다른 활용 방식·다른 분야·다른 깊이는 허용** (예: ChatGPT ADA mini 1 "기본 차트 생성" / mini 2 "다중 데이터셋 비교 분석" / mini 3 "이상치 탐지 시나리오"는 허용) |
| 4 | step 자연 통합 우선 | 활동 본질이 자연 통합되면 1 bullet. 4 step "정리·차트·인사이트·보고서"가 4 step 분리 의무 X — 활동 본질에 따라 시각화·보고서 통합 OK. 진짜 독립 학습 활동일 때만 분리 |
| 5 | 본 도구 내부 워딩·메타 노출 X | 모듈·step 식별자(M4 Step 5)·patch cycle 메타(P-11)·내부 spec 워딩·"★ 표시"·patch_log·applied_definitions 같은 내부 메타 표 bullet 노출 0건. "(LD 리뷰용)·(LD 검토용)" 같은 회사 내부 호칭 표 bullet 노출 0건 |

★ **anti-pattern 4건 + 게이트 j 4영역 자연 흡수** — Phase 1 §Bullet 5건 본문이 위 영역을 모두 포괄. 별도 anti-pattern 섹션 X·게이트 1·2·3 본문에서 점검.

---

## 사례 (Before/After + 문제점 5건 + 핵심 메시지)

★ 본 사례는 본 cycle에서 사용자 정합 판단을 거쳐 채택된 가상 통합 사례. 표 bullet 정정 시 LLM 인지 source.

### Before/After 사례 — 내부 메타·교안 풍·bullet 길이·통째 옮기기 결함 통합 영역

**Before (잘못된 형태)**:

```
"Canvas 기초 — 데이터를 정리한 다음 차트를 만들어서 인사이트를 도출하고 보고서로 정리해본다 (M4 Step 5 보고서 선행 학습)"
```

**문제점 5건**:

1. **"(M4 Step 5 보고서 선행 학습)"** = 모듈 식별자 + 학습 흐름 안내 침투. 본 도구 내부 영역이 LD 본문에 직접 노출됨. 본 영역은 모듈 구성 설명 (3~5줄 산문체)에 자연 풀이로 박힐 영역 (공정 4 처리)
2. **"Canvas 기초"** = 학습 깊이 노출. "기초·심화" 같은 학습 깊이는 시수·운영 조건 영역에서 결정될 영역. bullet 본문 X
3. **"—" 다음 풀어 서술 + "다음·~서·~해본다"** = 교안 풍·강의 멘트·구술 표현. 시간 흐름 단어 ("다음·여기서·그 다음")는 강의 본문 영역. bullet 본문 X
4. **한 bullet에 4 step 다 박힘** = bullet 길이 ↑↑·통째 옮기기 영역. bullet은 짧은 명사구로 박음 의무
5. **4 step 강제 분리 vs 자연 통합 미고려** = "정리·차트·인사이트·보고서"가 4 step 분리 의무 X. 활동 본질에 따라 자연 통합 (예: 시각화·보고서 통합 OK)

**After (LD 친화 정정 — 자연 통합 영역)**:

```
"Canvas로 데이터 분석 결과 시각화 및 보고서 작성"
```

**또는 활동 본질에 따라 step 분리도 가능**:

```
- "데이터 정리"
- "차트 생성·인사이트 도출"
- "보고서 작성"
```

### LLM 인지 핵심 메시지

**bullet 본문에 박지 말 영역**:
1. 본 도구 내부 워딩 — 모듈·step 식별자 (M4 Step 5)·"P-11·factcheck pass" 내부 spec·patch cycle 메타
2. 학습 깊이 — "기초·심화" 같은 운영 조건 영역
3. 강의 풍 워딩 — "다음·여기서·그 다음·~해본다·~서·~고 나서"
4. 학습 흐름 안내 — "선행 학습"·"이후 단계 준비" 같은 영역
5. 한 bullet에 여러 step 통째 박음

**bullet 본문에 박을 영역**:
- 도구 + 활동 + (필요 시) 산출물 자연 박음
- 짧은 명사구 형태
- step 자연 통합 (활동 본질에 따라)·강제 분리 X

---

## 톤앤매너 흡수 가이드 (input 자체 X·spec 본문 흡수)

### BGF리테일 제안서 톤앤매너 (한정 차용)

**원본**: 사용자 초기 제공 외부 자료 (PDF — 35~41p 영역).

**차용 영역**:
- bullet 짧은 명사구 패턴 — 학습 주제·기법 중심·짧은 명사구 형태
- 실습 내용 구조 — M3·M4 실습 영역 구성 패턴 참고

**미차용 영역** (★ 정합 의무 — 본 도구 산출에 박지 X):
- 표 구조 4 컬럼 (일자·주제·주요 내용·시수) — 본 도구는 3 컬럼 (구분·내용·시수)
- [실습] 마커 별도 표기 — M3·M4 자체가 실습이라 마커 X
- 시수 단위 (0.5H·1.5H 등 sub-bullet) — 본 도구는 모듈 단위만
- 교육 목표·형태 (이론 20% + 실습 80% 등) 별도 삽입 — 이미 다른 문서·메모리에 박힘

### curriculum.md 모듈 구성 설명 산문체 패턴 (Phase 1 조합 LD 친화 spec)

**원본**: skill-phase1-curriculum-assembly 산출 `curriculum.md`의 §"모듈 구성 설명" 영역.

**차용 영역**:
- 자연 산문체 3~5줄 패턴 (단 본 공정은 모듈 구성 설명 영역에 손대지 X — 공정 4 영역. 본 차용은 표 bullet 정정 시 LLM이 산문체 톤앤매너 인지 source로만 활용)


---

## scope (침범 금지)

| 영역 | 사유 |
|---|---|
| 모듈 구성 설명 (산문체 3~5줄) | **공정 4 영역** ★ |
| 통합본 `final-curriculum.md` | 공정 4 영역 |
| 공정 2 산출 본문 (구조·내용·feature) | 공정 2가 보장한 영역·본 공정 변경 X |
| 메타 json의 `module_labels`·`hours`·`gate_results`·`catalog_patterns`·`honest_marking` | 공정 2 산출 그대로·observations만 통합 박음 |
| Phase 3 (LD-Claude 대화 조정) | AX팀 구현 영역 밖 |
| Skill 5~8 (Phase 1) | 본 공정 재호출 X |
| `input.json.security`·`hours`·`level` | Phase 3 영역 |

**원본 불침해**:
- 공정 2 산출(`phase2/blocks/`) 4건 모두 변경 X (읽기만)
- `input.json` 변경 X (회사·직무·도구·주제 4건만 read)
- `phase2/factcheck/curriculum-post-factcheck.md` 변경 X (조건부 read)

---

## 실행 시 LLM 회피 워딩 영역 (★ spec·prompt에서 모두 제거)

본 공정 spec·prompt 어디에도 "딱딱한 LLM 용어 회피"·"전문용어·컴퓨터 용어 회피" 같은 회피 워딩 게이트를 박지 않는다. 회피 압력이 LLM에게 같은 위험(회피하다가 내용 이상해짐)을 유발하므로 spec·prompt 워딩 자체에서 제거.

★ Phase 1 spec과 정합 — Phase 1에서도 제한 안 두고 퀄리티 나오는 영역. 본 공정 LD 친화 정정 작업도 회피 게이트 없이 자연 한국어 워딩으로 수렴.

---

## 실패 처리

### LLM 1회 자동 재시도 (low-level 호출 안정성)
- LLM 호출 (Step 2·3·4)이 호출 자체로 실패 (타임아웃·JSON 파싱 실패·rate limit 등) 시 같은 step 안에서 1회 자동 재시도
- 게이트 검증 fail은 본 영역 X — ralph 루프가 처리
- 2회 호출 실패 시 ralph iteration fail로 보고

### 자체 재합성 (high-level 게이트 fail 정정·2회 한정)

ralph 루프가 iteration 반복하지만, 본 공정 자체에서는 게이트 fail 시 자동 재합성을 2회로 한정한다 (LLM 호출 낭비·자동 정정 어려움 영역에서 호출 폭주 차단).

| 게이트 | 처리 | 자체 재합성 한도 |
|---|---|---|
| 의무 1 (bullet 길이) | 자동 정정 — Step 2·3 재호출·정정 사유 명시 | 2회 |
| 의무 2 (교안 풍 차단) | 자동 정정 — Step 2·3 재호출·정정 사유 명시 | 2회 |
| 의무 3 (표 워딩) | 자동 정정 — Step 2·3 재호출·정정 사유 명시 | 2회 |
| 의무 5 (변경 메모) | 자동 정정 — Step 4 observations 보강 | 2회 |
| 의무 6 (본질 보존) | **사용자 인계** (자동 정정 X — 공정 2 산출 본질 손상 위험) | 0회 (즉시 인계) |

→ 2회 자체 재합성 후도 fail = Case A 사용자 인계.

### Case A (LD 조치 가능)
- 의무 게이트 1·2·3·5 fail → ralph 재시도 자동 정정
- 의무 게이트 6 fail → 사용자 검토 인계 (자동 정정 X·본질 손상 위험)

### Case B (시스템 오류 — 즉시 중단)
- 공정 2 산출 4건 부재 → 공정 2(`skill-hours-blocks`) 선행 요구 안내
- `*-meta.json` `gate_results` obligatory fail → 공정 2 영역에서 차단 의무·본 공정 진입 X
- `input.json` 파싱 실패 → 원인 명시 후 중단

---

## LD 고지 (1회 · Step 4 후)

```
[표 bullet 워딩 정밀 보강 완료]

대상: {tools 목록} × M1~M4 × short(6h)·long(12h) 두 세트

작업 영역: 커리큘럼 표 bullet 워딩만 LD 친화 spec 정합으로 정정
- 모듈 구성 설명 산문체 영역 = 손대지 X (공정 4 영역)
- 공정 2 산출 본질(내용·구조·feature) = 그대로 보존

결과 요약:
- short-refined.md: 표 bullet 정정 N건
- long-refined.md: 표 bullet 정정 M건
- 정정 사유 5 영역: bullet 길이 / 교안 풍 / 표 워딩 / 같은 feature 반복 / step 강제 분리

자체 점검:
- 의무 게이트 5건: {모두 PASS / 일부 사용자 인계 N건}

산출:
- phase2/block-refinement/short-refined.md
- phase2/block-refinement/long-refined.md
- phase2/block-refinement/short-meta-refined.json
- phase2/block-refinement/long-meta-refined.json

공정 2 원본(phase2/blocks/) 보존 — 비교 검토 가능

다음 공정 (모듈 구성 설명 보완 + 통합 final)이 본 산출을 자동 input으로 사용합니다.
```

**LD 고지 원칙**:
- 게이트 ID(의무 1·5·6 등) 노출 X — 의미 문장으로 변환
- 본 도구 내부 워딩(P-11·patch cycle 등) 노출 X
- 정정 영역 카운트만 명시 (구체 정정 본문은 observations 영역 참조 안내)

---

## 공정 4 인계 영역

**공정 4 input** (본 공정 산출 4건만):
- `phase2/block-refinement/short-refined.md`
- `phase2/block-refinement/long-refined.md`
- `phase2/block-refinement/short-meta-refined.json`
- `phase2/block-refinement/long-meta-refined.json`

**observations 메모**:
- 공정 4 LLM read 영역 — **참고 자료** (점검 영역 X·작업 자료)
- 본 공정의 정정 내역 인지 → 공정 4가 모듈 구성 설명 보완 시 정정 맥락 활용

**공정 2 산출 추가 input X**:
- 공정 4는 본 공정 산출(`phase2/block-refinement/`)만 input으로 받음
- 공정 2 산출(`phase2/blocks/`) 추가 read X — LLM 혼선 위험 차단·공정 3 산출이 1차 source

**공정 4 진입 점검** (Shell 차원 — 공정 2 → 공정 3 사례 정합):
- (a) 공정 3 산출 4건 파일 존재 확인 (Shell 파일 시스템)
- (b) `*-meta-refined.json` `gate_results.obligatory_5` 모두 PASS 확인 (Shell JSON 파싱)
- LLM 점검 X (본 공정 ralph + 사용자 인계 흐름이 보장)

★ 공정 4 자체 결정 영역 (산출 형태·작업 흐름·자체 검증 게이트 등) = 공정 4 skill 신설 시 별도 트랙. 본 공정에서는 인계 영역만 명시.

---

## references 폴더 정책 (v4)

본 SKILL.md는 **references/ 폴더 미사용**. 자체 검증 5 게이트·Bullet 작성 원칙 5건·사례 1건·톤앤매너 흡수 가이드 모두 본 SKILL.md 본문에 통합. 단일 파일 운영으로 spec 인지 비용 절감.

**근거**: 공정 2 SKILL.md 사례 정합 — 결정 영역도 SKILL.md 본문 통합. references/ 폴더 X (또는 빈 영역).

---

## 완결 원칙 요약

1. **공정 3 = 표 bullet 영역만 워딩 정밀 보강** — 모듈 구성 설명 산문체 영역은 공정 4 (역할 분리)
2. **input = 공정 2 산출 4건 필수** — post-factcheck·input.json은 조건부 참고
3. **output = (γ) 공정 2 산출 복사 + 변경 부분만 정정 + observations 메모 통합** — 공정 2 원본 보존
4. **인계 점검 = Shell 차원 (a) 파일 존재 + (b) gate_results PASS** — LLM 점검 X
5. **자체 검증 5 의무 게이트 + 관찰 0건** — bullet 길이·교안 풍·표 워딩·변경 메모·본질 보존
6. **호출 budget 3회** (Step 2 short-refined + Step 3 long-refined + Step 4 점검) · long fallback 6회 매우 드문 시나리오
7. **Bullet 작성 원칙 5건** — 짧은 명사구·도구+활동·feature 반복 X (공정 2 anti-pattern D 정정 정합)·step 자연 통합·내부 메타 노출 X
8. **사례 1건** (Before/After + 문제점 5 + 핵심 메시지) 본문 통합 — 표 bullet 정정 시 LLM 인지 source
9. **톤앤매너 흡수** — BGF 한정 차용·curriculum.md 산문체 패턴 (input 자체 X·spec 본문 흡수)
10. **회피 워딩 spec·prompt에서 제거** — Phase 1 정합·"딱딱한 LLM 용어 회피" 게이트 박지 X
11. **공정 4 인계 = 공정 3 산출 4건만** — observations = 참고 자료·Shell 진입 점검
12. **references/ 폴더 미사용** — 본 SKILL.md 본문 통합
