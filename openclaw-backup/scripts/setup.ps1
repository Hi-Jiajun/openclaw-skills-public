# OpenClaw Backup - Interactive Setup
# 运行此脚本进行交互式配置

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "OpenClaw Backup - 交互式配置向导" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 获取 OpenClaw 主目录
$openclawHome = "$env:USERPROFILE\.openclaw"
if (Test-Path $openclawHome) {
    $defaultBackupRoot = "Z:\backup\openclaw_backup"
    $defaultOldBackup = "Z:\backup\openclaw_backup_old"
} else {
    # Linux/Mac 默认路径
    $defaultBackupRoot = "$HOME/openclaw_backup"
    $defaultOldBackup = "$HOME/openclaw_backup_old"
}

Write-Host "1. 设置备份根目录" -ForegroundColor Yellow
Write-Host "   默认: $defaultBackupRoot"
$backupRoot = Read-Host "   输入新路径（直接回车使用默认值）"
if ([string]::IsNullOrWhiteSpace($backupRoot)) {
    $backupRoot = $defaultBackupRoot
}

Write-Host ""
Write-Host "2. 设置旧备份目录" -ForegroundColor Yellow
Write-Host "   默认: $defaultOldBackup"
$oldBackupRoot = Read-Host "   输入新路径（直接回车使用默认值）"
if ([string]::IsNullOrWhiteSpace($oldBackupRoot)) {
    $oldBackupRoot = $defaultOldBackup
}

Write-Host ""
Write-Host "3. 设置保留备份数量" -ForegroundColor Yellow
Write-Host "   默认: 3"
$keepCountInput = Read-Host "   输入数字（直接回车使用默认值）"
$keepCount = if ([string]::IsNullOrWhiteSpace($keepCountInput)) { 3 } else { $keepCountInput }

Write-Host ""
Write-Host "4. 设置旧备份容量限制 (GB)" -ForegroundColor Yellow
Write-Host "   默认: 10 (超过10GB后清理到5GB)"
$maxSizeInput = Read-Host "   输入数字（直接回车使用默认值）"
$maxOldSizeGB = if ([string]::IsNullOrWhiteSpace($maxSizeInput)) { 10 } else { $maxSizeInput }

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "配置完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "备份根目录: $backupRoot" -ForegroundColor White
Write-Host "旧备份目录: $oldBackupRoot" -ForegroundColor White
Write-Host "保留数量: $keepCount" -ForegroundColor White
Write-Host "容量限制: ${maxOldSizeGB}GB" -ForegroundColor White
Write-Host ""

# 保存配置到文件
$config = @"
# OpenClaw Backup 配置
# 由 setup.ps1 自动生成

`$backupRoot = "$backupRoot"
`$oldBackupRoot = "$oldBackupRoot"
`$openclawHome = "$env:USERPROFILE\.openclaw"
`$keepCount = $keepCount
`$maxOldSizeGB = $maxOldSizeGB
`$targetOldSizeGB = 5
"@

# 创建 config 目录
$configDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configFile = Join-Path $configDir "config.ps1"

$config | Out-File -FilePath $configFile -Encoding UTF8

Write-Host "配置已保存到: $configFile" -ForegroundColor Green
Write-Host ""
Write-Host "运行备份: powershell -ExecutionPolicy Bypass -File `"$configDir\backup.ps1`"" -ForegroundColor Cyan
