# OpenClaw Backup - Interactive Setup
# Run this script for interactive configuration

Write-Host "=========================================="
Write-Host "OpenClaw Backup - Setup Wizard"
Write-Host "=========================================="
Write-Host ""

$defaultBackupRoot = "Z:\backup\openclaw_backup"
$defaultOldBackup = "Z:\backup\openclaw_backup_old"

Write-Host "1. Set backup root directory"
Write-Host "   Default: $defaultBackupRoot"
$backupRoot = Read-Host "   Enter new path (press Enter for default)"
if ([string]::IsNullOrWhiteSpace($backupRoot)) {
    $backupRoot = $defaultBackupRoot
}

Write-Host ""
Write-Host "2. Set old backup directory"
Write-Host "   Default: $defaultOldBackup"
$oldBackupRoot = Read-Host "   Enter new path (press Enter for default)"
if ([string]::IsNullOrWhiteSpace($oldBackupRoot)) {
    $oldBackupRoot = $defaultOldBackup
}

Write-Host ""
Write-Host "3. Set number of backups to keep"
Write-Host "   Default: 3"
$keepCountInput = Read-Host "   Enter number (press Enter for default)"
$keepCount = if ([string]::IsNullOrWhiteSpace($keepCountInput)) { 3 } else { $keepCountInput }

Write-Host ""
Write-Host "4. Set old backup size limit (GB)"
Write-Host "   Default: 10 (cleanup to 5GB when exceeded)"
$maxSizeInput = Read-Host "   Enter number (press Enter for default)"
$maxOldSizeGB = if ([string]::IsNullOrWhiteSpace($maxSizeInput)) { 10 } else { $maxSizeInput }

Write-Host ""
Write-Host "=========================================="
Write-Host "Setup Complete!"
Write-Host "=========================================="
Write-Host ""
Write-Host "Backup root: $backupRoot"
Write-Host "Old backup: $oldBackupRoot"
Write-Host "Keep count: $keepCount"
Write-Host "Size limit: $maxOldSizeGB GB"
Write-Host ""

$config = @"
`$backupRoot = `"$backupRoot`"
`$oldBackupRoot = `"$oldBackupRoot`"
`$openclawHome = `"$env:USERPROFILE\.openclaw`"
`$keepCount = $keepCount
`$maxOldSizeGB = $maxOldSizeGB
`$targetOldSizeGB = 5
"@

$configDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configFile = Join-Path $configDir "config.ps1"

$config | Out-File -FilePath $configFile -Encoding UTF8

Write-Host "Config saved to: $configFile"
Write-Host ""
$backupScript = Join-Path $configDir "backup.ps1"
Write-Host "Run backup: powershell -ExecutionPolicy Bypass -File `"$backupScript`""
