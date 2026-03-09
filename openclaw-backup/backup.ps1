# OpenClaw Backup Script
# 备份规则：
# - 主备份文件夹：保留最新3个（主备份 + skills）
# - 超过的备份：移到 openclaw_backup_old
# - 旧备份按容量清理（超过10GB删到5GB）

$backupDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$hostname = $env:COMPUTERNAME
$backupRoot = "Z:\backup\openclaw_backup\$hostname"
$oldBackupRoot = "Z:\backup\openclaw_backup_old\$hostname"
$openclawHome = "$env:USERPROFILE\.openclaw"
$maxOldSizeGB = 10
$targetOldSizeGB = 5
$keepCount = 3  # 保留最新3个

Write-Host "=========================================="
Write-Host "OpenClaw Backup Start - $backupDate"
Write-Host "=========================================="

# Create backup directory
$backupDir = "$backupRoot\$backupDate"
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

# Backup items
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
        $dest = "$backupDir\$name"
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

# Create restore guide
$restoreGuide = @"
# OpenClaw Backup Restore Guide
# Backup Time: $backupDate

## Backup Locations
- Main backup (latest 3): Z:\backup\openclaw_backup\
- Old backups: Z:\backup\openclaw_backup_old\
- Custom skills (latest 3): Z:\backup\openclaw_backup\my-own-skills\
- Old skills: Z:\backup\openclaw_backup_old\my-own-skills\

## Restore Methods

### Method 1: Full Restore
1. Stop OpenClaw Gateway
2. Backup current config
3. Copy files from backup to `$env:USERPROFILE\.openclaw\`
4. Restart Gateway

### Method 2: Selective Restore
- Restore config: copy "$backupDir\openclaw.json" "$openclawHome\"
- Restore skills: xcopy /E /I "$backupDir\skills" "$openclawHome\skills\"
- Restore workspace: xcopy /E /I "$backupDir\workspace" "$openclawHome\workspace\"

## Backup Rules
- Keep latest $keepCount backups in main folder
- Older backups moved to openclaw_backup_old
- Old backups cleaned when size > $maxOldSizeGB (keep to $targetOldSizeGB)
"@

$restoreGuide | Out-File -FilePath "$backupDir\RESTORE.md" -Encoding UTF8

Write-Host ""
Write-Host "=========================================="
Write-Host "Backup Complete!"
Write-Host "Backup Location: $backupDir"
Write-Host "Success: $successCount, Failed: $failCount"
Write-Host "=========================================="

# ===== Cleanup: Keep latest $keepCount =====
Write-Host ""
Write-Host "Cleaning old backups (keep latest $keepCount)..."

# Get all backup folders (exclude my-own-skills)
$allBackups = Get-ChildItem -Path $backupRoot -Directory | Where-Object { 
    $_.Name -ne "my-own-skills" 
} | Sort-Object LastWriteTime -Descending

# Move old main backups to old folder
if ($allBackups.Count -gt $keepCount) {
    $allBackups | Select-Object -Skip $keepCount | ForEach-Object {
        $oldDir = "$oldBackupRoot\$($_.Name)"
        New-Item -ItemType Directory -Force -Path $oldDir | Out-Null
        Move-Item $_.FullName $oldDir -Force
        Write-Host "[MOVED] $($_.Name) -> openclaw_backup_old/"
    }
}

# Get all skills backups in my-own-skills
$mySkillsDir = "$backupRoot\my-own-skills"
$workspaceSkills = "$openclawHome\workspace\skills"

if (Test-Path $workspaceSkills) {
    Write-Host ""
    Write-Host "Backing up custom skills..."
    
    # Get existing skills backups
    if (Test-Path $mySkillsDir) {
        $existingSkills = Get-ChildItem $mySkillsDir -Directory | Sort-Object LastWriteTime -Descending
        
        # Move old skills to old folder
        if ($existingSkills.Count -ge $keepCount) {
            $existingSkills | Select-Object -Skip $keepCount | ForEach-Object {
                $oldSkillsDir = "$oldBackupRoot\my-own-skills"
                New-Item -ItemType Directory -Force -Path $oldSkillsDir | Out-Null
                Move-Item $_.FullName "$oldSkillsDir\" -Force
                Write-Host "[MOVED] $($_.Name) -> openclaw_backup_old/my-own-skills/"
            }
        }
    }
    
    # Copy latest skills
    New-Item -ItemType Directory -Force -Path $mySkillsDir | Out-Null
    $latestSkillsDir = "$mySkillsDir\$backupDate"
    Copy-Item -Path $workspaceSkills -Destination $latestSkillsDir -Recurse -Force
    Write-Host "[OK] custom skills -> my-own-skills/$backupDate"
}

# ===== Old Backup Size Cleanup =====
if (Test-Path $oldBackupRoot) {
    Write-Host ""
    Write-Host "Checking old backups size..."
    
    $oldFolders = Get-ChildItem -Path $oldBackupRoot -Directory -Recurse | Sort-Object LastWriteTime
    $totalSizeGB = 0
    
    foreach ($folder in $oldFolders) {
        $size = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB
        if ($size) { $totalSizeGB += $size }
    }
    
    Write-Host "Old backups total size: $([math]::Round($totalSizeGB, 2)) GB"
    
    if ($totalSizeGB -gt $maxOldSizeGB) {
        Write-Host "Size exceeds $maxOldSizeGB GB, cleaning to $targetOldSizeGB GB..."
        
        $oldFolders = Get-ChildItem -Path $oldBackupRoot -Directory -Recurse | Sort-Object LastWriteTime
        
        foreach ($folder in $oldFolders) {
            if ($totalSizeGB -le $targetOldSizeGB) {
                break
            }
            $size = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB
            if ($size) {
                Remove-Item $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue
                $totalSizeGB -= $size
                Write-Host "[DELETED] $($folder.Name) ($( [math]::Round($size, 2) )) GB"
            }
        }
        
        Write-Host "Old backups size after cleanup: $([math]::Round($totalSizeGB, 2)) GB"
    }
}

Write-Host ""
Write-Host "=========================================="
