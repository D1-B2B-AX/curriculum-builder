# curriculum-builder installer (Windows PowerShell)
#
# Usage:
#   1. Clone this repo (or download zip)
#   2. cd to the repo root in PowerShell
#   3. Run: .\install.ps1
#      (If blocked by ExecutionPolicy, use: PowerShell -ExecutionPolicy Bypass -File .\install.ps1)
#
# Behavior:
#   - Copies 6 skill folders under skills/ to ~/.claude/skills/
#   - Copies files under commands/ to ~/.claude/commands/
#   - Records current git commit SHA to ~/.claude/skills/curriculum-builder/INSTALLED_COMMIT
#     (used by curriculum-builder STEP 0 to compare with latest GitHub SHA for update detection)
#   - Records install path to ~/.curriculum-builder/install_path.txt
#     (used by STEP 0 for automatic git pull + install.ps1 execution next time)
#   - Overwrites existing folders/files with same name

$ErrorActionPreference = "Stop"

$REPO_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAUDE_SKILLS = "$env:USERPROFILE\.claude\skills"
$CLAUDE_COMMANDS = "$env:USERPROFILE\.claude\commands"

Write-Host ""
Write-Host "curriculum-builder install start" -ForegroundColor Cyan
Write-Host "Repo path: $REPO_ROOT"
Write-Host "Install targets:"
Write-Host "  - $CLAUDE_SKILLS"
Write-Host "  - $CLAUDE_COMMANDS"
Write-Host ""

# Create directories
if (-not (Test-Path $CLAUDE_SKILLS)) {
    New-Item -ItemType Directory -Path $CLAUDE_SKILLS -Force | Out-Null
    Write-Host "Created: $CLAUDE_SKILLS"
}
if (-not (Test-Path $CLAUDE_COMMANDS)) {
    New-Item -ItemType Directory -Path $CLAUDE_COMMANDS -Force | Out-Null
    Write-Host "Created: $CLAUDE_COMMANDS"
}

# Copy skills/
Write-Host ""
Write-Host "[1/2] Copying 6 skills..." -ForegroundColor Yellow
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
        Write-Host "  [Warning] Source not found: $src" -ForegroundColor Red
        continue
    }

    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
    }

    Copy-Item -Recurse -Path $src -Destination $dst
    Write-Host "  [Done] $dir"
}

# Copy commands/
Write-Host ""
Write-Host "[2/2] Copying commands..." -ForegroundColor Yellow
$commandFiles = Get-ChildItem -Path (Join-Path $REPO_ROOT "commands") -Filter "*.md"

foreach ($file in $commandFiles) {
    $dst = Join-Path $CLAUDE_COMMANDS $file.Name
    Copy-Item -Path $file.FullName -Destination $dst -Force
    Write-Host "  [Done] $($file.Name)"
}

# Record INSTALLED_COMMIT (for curriculum-builder STEP 0 update check)
Write-Host ""
Write-Host "[+] Recording version marker..." -ForegroundColor Yellow
try {
    $commit = (git -C $REPO_ROOT rev-parse HEAD 2>$null)
    if ($LASTEXITCODE -eq 0 -and $commit) {
        $markerPath = Join-Path $CLAUDE_SKILLS "curriculum-builder\INSTALLED_COMMIT"
        Set-Content -Path $markerPath -Value $commit -NoNewline
        Write-Host "  [Done] INSTALLED_COMMIT: $($commit.Substring(0,7))"
    } else {
        Write-Host "  [Warning] git rev-parse failed - update check disabled" -ForegroundColor Yellow
        Write-Host "  (git may not be installed, or this is not a git repo)"
    }
} catch {
    Write-Host "  [Warning] git command failed - update check disabled" -ForegroundColor Yellow
}

# Record install path (for curriculum-builder STEP 0 auto-update)
# Saves $REPO_ROOT (folder where this script lives) to ~/.curriculum-builder/install_path.txt.
# STEP 0 reads this file and automatically runs git pull + install.ps1, so LDs don't need
# to remember the clone folder or run install.ps1 manually next time.
Write-Host ""
Write-Host "[+] Recording install path..." -ForegroundColor Yellow
try {
    $cbDir = Join-Path $env:USERPROFILE ".curriculum-builder"
    if (-not (Test-Path $cbDir)) {
        New-Item -ItemType Directory -Path $cbDir -Force | Out-Null
    }
    $pathFile = Join-Path $cbDir "install_path.txt"
    Set-Content -Path $pathFile -Value $REPO_ROOT -Encoding utf8 -NoNewline
    Write-Host "  [Done] install_path.txt: $REPO_ROOT"
} catch {
    Write-Host "  [Warning] Failed to record install path - STEP 0 auto-update disabled (manual fallback)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Install complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Restart Claude Code (optional - may be picked up without restart)"
Write-Host "  2. Usage guide:  /curriculum-builder-guide"
Write-Host "  3. Run:          /curriculum-builder"
Write-Host ""
