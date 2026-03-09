# OpenClaw Backup Script
# 备份规则：
# - 主备份：Z:\backup\openclaw_backup\{hostname}\{日期}\
# - 自建 skills：Z:\backup\openclaw_backup\custom-skills\{日期}\
# - 旧备份：Z:\backup\openclaw_backup_old\ 保持同样结构
# - 主备份保留最新3个

$backupDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$hostname = $env:COMPUTERNAME
$backupRoot = "Z:\backup\openclaw_backup"
$oldBackupRoot = "Z:\backup\openclaw_backup_old"
$openclawHome = "$env:USERPROFILE\.openclaw"
$keepCount = 3

# 自建 skills 列表
$customSkills = @(
    "mweb-automation",
    "mweb-get-task",
    "mweb-download",
    "mweb-publish",
    "mweb-seed",
    "openclaw-backup",
    "openclaw-skills-github-sync"
)

$workspaceSkillsPath = "$openclawHome\workspace\skills"

Write-Host "=========================================="
Write-Host "OpenClaw Backup Start - $backupDate"
Write-Host "=========================================="

# ===== 主备份：按 hostname/日期 分类 =====
$mainBackupPath = "$backupRoot\$hostname\$backupDate"
New-Item -ItemType Directory -Force -Path $mainBackupPath | Out-Null

$backupItems = @(
    @{src="$openclawHome\openclaw.json"; name="openclaw.json"},
    @{src="$openclawHome\agents"; name="agents"; isDir=$true},
    @{src="$openclawHome\credentials"; name="credentials"; isDir=$true},
    @{src="$openclawHome\cron"; name="cron"; isDir=$true},
    @{src="$openclawHome\devices"; name="devices"; isDir=$true},
    @{src="$openclawHome\identity"; name="identity"; isDir=$true},
    @{src="$openclawHome\skills"; name="skills"; isDir=$true},
    @{src="$openclawHome\workspace"; name="workspace"; isDir=$true}
)

$successCount = 0
$failCount = 0

foreach ($item in $backupItems) {
    $src = $item.src
    $name = $item.name
    
    if (Test-Path $src) {
        $dest = "$mainBackupPath\$name"
        try {
            if ($item.isDir) {
                Copy-Item -Path $src -Destination $dest -Recurse -Force -ErrorAction Stop
            } else {
                Copy-Item -Path $src -Destination $dest -Force -ErrorAction Stop
            }
            Write-Host "[OK] $name"
            $successCount++
        } catch {
            Write-Host "[FAIL] $name - $_"
            $failCount++
        }
    } else {
        Write-Host "[SKIP] $name (not found)"
    }
}

# ===== 自建 skills 单独备份：custom-skills/日期 =====
Write-Host ""
Write-Host "Backing up custom skills..."

$customSkillsBackupPath = "$backupRoot\custom-skills\$backupDate"

foreach ($skill in $customSkills) {
    $skillSrc = "$workspaceSkillsPath\$skill"
    
    if (Test-Path $skillSrc) {
        $destPath = "$customSkillsBackupPath\$skill"
        New-Item -ItemType Directory -Force -Path (Split-Path $destPath) | Out-Null
        Copy-Item -Path $skillSrc -Destination $destPath -Recurse -Force
        Write-Host "[OK] custom skill: $skill"
        $successCount++
    }
}

# Restore guide
$restoreGuide = @"
# OpenClaw Backup Restore Guide
# Backup Time: $backupDate

## Backup Locations
- Main backup: Z:\backup\openclaw_backup\$hostname\$backupDate\
- Custom skills: Z:\backup\openclaw_backup\custom-skills\$backupDate\
- Old backups: Z:\backup\openclaw_backup_old\

## Restore Methods
1. Stop OpenClaw Gateway
2. Copy files from backup to `$env:USERPROFILE\.openclaw\`
3. Restart Gateway
"@

$restoreGuide | Out-File -FilePath "$mainBackupPath\RESTORE.md" -Encoding UTF8

Write-Host ""
Write-Host "=========================================="
Write-Host "Backup Complete!"
Write-Host "Success: $successCount, Failed: $failCount"
Write-Host "=========================================="

# ===== 清理旧备份：主备份保留3个 =====
Write-Host ""
Write-Host "Cleaning old main backups..."

$hostnameBackupPath = "$backupRoot\$hostname"
if (Test-Path $hostnameBackupPath) {
    $allBackups = Get-ChildItem -Path $hostnameBackupPath -Directory | Sort-Object LastWriteTime -Descending
    
    if ($allBackups.Count -gt $keepCount) {
        $allBackups | Select-Object -Skip $keepCount | ForEach-Object {
            $oldDir = "$oldBackupRoot\$hostname\$($_.Name)"
            New-Item -ItemType Directory -Force -Path (Split-Path $oldDir) | Out-Null
            Move-Item $_.FullName $oldDir -Force
            Write-Host "[MOVED] $($_.Name) -> openclaw_backup_old/"
        }
    }
}

# ===== 清理旧备份：custom-skills 保留3个 =====
Write-Host ""
Write-Host "Cleaning old custom-skills backups..."

$customSkillsBackupRoot = "$backupRoot\custom-skills"
if (Test-Path $customSkillsBackupRoot) {
    $allCustomBackups = Get-ChildItem -Path $customSkillsBackupRoot -Directory | Sort-Object LastWriteTime -Descending
    
    if ($allCustomBackups.Count -gt $keepCount) {
        $allCustomBackups | Select-Object -Skip $keepCount | ForEach-Object {
            $oldDir = "$oldBackupRoot\custom-skills\$($_.Name)"
            New-Item -ItemType Directory -Force -Path (Split-Path $oldDir) | Out-Null
            Move-Item $_.FullName $oldDir -Force
            Write-Host "[MOVED] custom-skills/$($_.Name) -> openclaw_backup_old/"
        }
    }
}

Write-Host "Done!"
