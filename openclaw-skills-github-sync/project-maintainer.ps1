# Project Maintainer - 自动维护 GitHub 和 ClawHub 同步

param(
    [string]$Target = "all"
)

# 配置
$workspacePath = "{USER_PATH}\.openclaw\workspace"
$skillsPath = "$workspacePath\skills"
$privateRepoPath = "$workspacePath\openclaw-skills-private"
$publicRepoPath = "$workspacePath\openclaw-skills-public"

$gitPath = "C:\Program Files\Git\cmd\git.exe"
$ghPath = "C:\Program Files\GitHub CLI\gh.exe"
$clawdhubPath = "clawdhub"

$customSkills = @(
    "mweb-automation",
    "mweb-get-task", 
    "mweb-download",
    "mweb-publish",
    "mweb-seed",
    "openclaw-backup",
    "openclaw-skills-github-sync"
)

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "OK" { "Green" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Test-GitAvailable {
    if (-not (Test-Path $gitPath)) {
        Write-Log "Git not found" "ERROR"
        return $false
    }
    return $true
}

function Test-GitHubAvailable {
    if (-not (Test-Path $ghPath)) {
        Write-Log "GitHub CLI not found" "ERROR"
        return $false
    }
    return $true
}

function Test-ClawHubLogin {
    $result = & $clawdhubPath whoami --workdir $workspacePath 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log "ClawHub not logged in" "ERROR"
        return $false
    }
    Write-Log "ClawHub logged in" "OK"
    return $true
}

function Remove-SensitiveInfo {
    param([string]$SkillPath)
    
    $sensitivePatterns = @(
        "{USER_PATH}",
        "{USER_PATH}",
        "{USER_PATH}",
        "{USER_PATH}"
    )
    
    Get-ChildItem -Path $SkillPath -Recurse -Include "*.md","*.ps1","*.json" | ForEach-Object {
        $content = Get-Content $_.FullName -Raw -Encoding UTF8
        $modified = $false
        
        foreach ($pattern in $sensitivePatterns) {
            if ($content -match [regex]::Escape($pattern)) {
                $content = $content -replace [regex]::Escape($pattern), "{USER_PATH}"
                $modified = $true
            }
        }
        
        if ($modified) {
            Set-Content -Path $_.FullName -Value $content -Encoding UTF8
        }
    }
}

function Sync-Repository {
    param(
        [string]$RepoPath,
        [string]$RepoName,
        [bool]$IsPublic = $false
    )
    
    if (-not (Test-Path $RepoPath)) {
        Write-Log "Cloning $RepoName..." "INFO"
        & $ghPath repo clone $RepoName $RepoPath 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Log "Failed to clone $RepoName" "ERROR"
            return $false
        }
    }
    
    Set-Location $RepoPath
    & $gitPath pull origin main 2>&1 | Out-Null
    
    Write-Log "Syncing skills to $RepoName..." "INFO"
    
    foreach ($skill in $customSkills) {
        $src = "$skillsPath\$skill"
        $dst = "$RepoPath\$skill"
        
        if (Test-Path $src) {
            if (Test-Path $dst) {
                Remove-Item -Path $dst -Recurse -Force
            }
            
            Copy-Item -Path $src -Destination $dst -Recurse -Force
            
            if ($IsPublic) {
                Remove-SensitiveInfo -SkillPath $dst
                Write-Log "  - $skill (public, sanitized)" "OK"
            } else {
                Write-Log "  - $skill (private)" "OK"
            }
        }
    }
    
    $status = & $gitPath status --porcelain
    if ($status) {
        Write-Log "Committing changes..." "INFO"
        & $gitPath add .
        $commitMsg = "Auto sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        & $gitPath commit -m $commitMsg
        
        Write-Log "Pushing to $RepoName..." "INFO"
        & $gitPath push origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "$RepoName sync completed!" "OK"
            return $true
        } else {
            Write-Log "$RepoName push failed!" "ERROR"
            return $false
        }
    } else {
        Write-Log "No changes in $RepoName" "OK"
        return $true
    }
}

function Publish-ToClawHub {
    param([string]$SkillName)
    
    Write-Log "Publishing $SkillName to ClawHub..." "INFO"
    
    Set-Location $publicRepoPath
    
    $result = & $clawdhubPath publish $SkillName --workdir $publicRepoPath 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "$SkillName published to ClawHub!" "OK"
        return $true
    } else {
        Write-Log "Failed to publish $SkillName" "ERROR"
        return $false
    }
}

function Test-SkillMetaData {
    param([string]$SkillPath)
    
    $skillMd = "$SkillPath\SKILL.md"
    if (-not (Test-Path $skillMd)) {
        Write-Log "Missing SKILL.md" "WARN"
        return $false
    }
    
    $content = Get-Content $skillMd -Raw
    $requiredFields = @("name:", "description:")
    $hasAllFields = $true
    
    foreach ($field in $requiredFields) {
        if ($content -notmatch $field) {
            Write-Log "Missing field: $field" "WARN"
            $hasAllFields = $false
        }
    }
    
    return $hasAllFields
}

# 主流程
Write-Log "==========================================" "INFO"
Write-Log "Project Maintainer - Auto Sync" "INFO"
Write-Log "==========================================" "INFO"

if (-not (Test-GitAvailable)) { exit 1 }
if (-not (Test-GitHubAvailable)) { exit 1 }

if ($Target -eq "all" -or $Target -eq "private") {
    Write-Log "=== Syncing Private Repository ===" "INFO"
    Sync-Repository -RepoPath $privateRepoPath -RepoName "openclaw-skills-private" -IsPublic $false
}

if ($Target -eq "all" -or $Target -eq "public") {
    Write-Log "=== Syncing Public Repository ===" "INFO"
    Sync-Repository -RepoPath $publicRepoPath -RepoName "openclaw-skills-public" -IsPublic $true
}

# 注意：ClawHub 发布需要先在网页上接受许可证条款
# 访问 https://clawhub.ai/publish 完成验证后再启用发布功能

if ($Target -eq "all" -or $Target -eq "clawhub") {
    if (-not (Test-ClawHubLogin)) { exit 1 }
    
    Write-Log "=== Publishing to ClawHub ===" "INFO"
    Write-Log "NOTE: If publish fails, please visit https://clawhub.ai and accept license terms first" "WARN"
    
    foreach ($skill in $customSkills) {
        $skillPublicPath = "$publicRepoPath\$skill"
        
        if (Test-Path $skillPublicPath) {
            $pass = Test-SkillMetaData -SkillPath $skillPublicPath
            if (-not $pass) {
                Write-Log "Skill $skill failed validation, skipping ClawHub publish" "WARN"
                continue
            }
            
            Publish-ToClawHub -SkillName $skill
        }
    }
}

Write-Log "==========================================" "INFO"
Write-Log "Sync Complete!" "OK"
Write-Log "==========================================" "INFO"

