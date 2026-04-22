# curriculum-builder 설치 스크립트 (Windows PowerShell)
#
# 사용법:
#   1. 이 레포를 git clone 또는 zip 다운로드
#   2. PowerShell에서 레포 루트로 이동
#   3. 실행: .\install.ps1
#
# 동작:
#   - skills/ 하위 6개 스킬 폴더를 ~/.claude/skills/로 복사
#   - commands/ 하위 파일을 ~/.claude/commands/로 복사
#   - 현재 git commit SHA를 ~/.claude/skills/curriculum-builder/INSTALLED_COMMIT 에 기록
#     (curriculum-builder STEP 0 업데이트 체크용 — GitHub 최신 SHA와 비교해 업데이트 여부 판정)
#   - 기존 동일 이름 폴더/파일은 덮어쓰기

$ErrorActionPreference = "Stop"

$REPO_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAUDE_SKILLS = "$env:USERPROFILE\.claude\skills"
$CLAUDE_COMMANDS = "$env:USERPROFILE\.claude\commands"

Write-Host ""
Write-Host "curriculum-builder 설치 시작" -ForegroundColor Cyan
Write-Host "레포 경로: $REPO_ROOT"
Write-Host "설치 대상:"
Write-Host "  - $CLAUDE_SKILLS"
Write-Host "  - $CLAUDE_COMMANDS"
Write-Host ""

# 디렉토리 생성
if (-not (Test-Path $CLAUDE_SKILLS)) {
    New-Item -ItemType Directory -Path $CLAUDE_SKILLS -Force | Out-Null
    Write-Host "생성: $CLAUDE_SKILLS"
}
if (-not (Test-Path $CLAUDE_COMMANDS)) {
    New-Item -ItemType Directory -Path $CLAUDE_COMMANDS -Force | Out-Null
    Write-Host "생성: $CLAUDE_COMMANDS"
}

# skills/ 복사
Write-Host ""
Write-Host "[1/2] 스킬 6개 복사 중..." -ForegroundColor Yellow
$skillDirs = @(
    "curriculum-builder",
    "company-role-task-research",
    "task-atomization",
    "task-dna-classification",
    "task-card-generation",
    "workflow-reconstruction"
)

foreach ($dir in $skillDirs) {
    $src = Join-Path $REPO_ROOT "skills\$dir"
    $dst = Join-Path $CLAUDE_SKILLS $dir

    if (-not (Test-Path $src)) {
        Write-Host "  [경고] 소스 없음: $src" -ForegroundColor Red
        continue
    }

    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
    }

    Copy-Item -Recurse -Path $src -Destination $dst
    Write-Host "  [완료] $dir"
}

# commands/ 복사
Write-Host ""
Write-Host "[2/2] 커맨드 복사 중..." -ForegroundColor Yellow
$commandFiles = Get-ChildItem -Path (Join-Path $REPO_ROOT "commands") -Filter "*.md"

foreach ($file in $commandFiles) {
    $dst = Join-Path $CLAUDE_COMMANDS $file.Name
    Copy-Item -Path $file.FullName -Destination $dst -Force
    Write-Host "  [완료] $($file.Name)"
}

# INSTALLED_COMMIT 기록 (curriculum-builder STEP 0 업데이트 체크용)
Write-Host ""
Write-Host "[+] 버전 마커 기록 중..." -ForegroundColor Yellow
try {
    $commit = (git -C $REPO_ROOT rev-parse HEAD 2>$null)
    if ($LASTEXITCODE -eq 0 -and $commit) {
        $markerPath = Join-Path $CLAUDE_SKILLS "curriculum-builder\INSTALLED_COMMIT"
        Set-Content -Path $markerPath -Value $commit -NoNewline
        Write-Host "  [완료] INSTALLED_COMMIT: $($commit.Substring(0,7))"
    } else {
        Write-Host "  [주의] git rev-parse 실패 - 업데이트 체크 비활성화됨" -ForegroundColor Yellow
        Write-Host "  (git이 설치되어 있지 않거나 레포가 아닌 곳에서 실행했을 수 있음)"
    }
} catch {
    Write-Host "  [주의] git 명령 실행 실패 - 업데이트 체크 비활성화됨" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "설치 완료!" -ForegroundColor Green
Write-Host ""
Write-Host "다음 단계:"
Write-Host "  1. Claude Code 재시작 (선택 — 재시작 없이도 인식될 수 있음)"
Write-Host "  2. 사용법 확인:  /curriculum-builder-guide"
Write-Host "  3. 실행:        /curriculum-builder"
Write-Host ""
