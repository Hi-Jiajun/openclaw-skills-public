---
name: openclaw-backup
description: |
  自动备份 OpenClaw 本地存储配置文件到。
  使用场景：(1) 定期备份配置 (2) 迁移配置 (3) 恢复配置
---

# OpenClaw Backup Skill

自动备份 OpenClaw 的所有配置文件到本地存储。

## 功能

- 每日自动备份（可配置时间）
- 保留最近 N 个备份
- 旧备份自动转移到备份目录
- 按容量自动清理旧备份

## 配置项

使用前请根据需要修改以下配置：

```powershell
# ==== 必填配置 ====
$backupRoot = "Z:\backup\openclaw_backup"      # 备份根目录，请修改为你的路径
$oldBackupRoot = "Z:\backup\openclaw_backup_old"  # 旧备份目录
$openclawHome = "$env:USERPROFILE\.openclaw"    # OpenClaw 主目录

# ==== 可选配置 ====
$keepCount = 3        # 主备份保留数量，默认3个
$maxOldSizeGB = 10   # 旧备份超过此容量时清理
$targetOldSizeGB = 5  # 清理后的目标容量
```

## 使用方法

### 1. 手动执行备份
```powershell
powershell -ExecutionPolicy Bypass -File "openclaw-backup\backup.ps1"
```

### 2. 设置定时自动备份
使用 Windows 任务计划程序或 OpenClaw cron：

```bash
# 每天凌晨3点执行
openclaw cron add --name "openclaw-backup" --schedule "0 3 * * *" --command "powershell -ExecutionPolicy Bypass -File C:\PATH\TO\openclaw-backup\backup.ps1"
```

## 备份内容

| 目录/文件 | 说明 |
|-----------|------|
| openclaw.json | 主配置文件 |
| agents/ | Agent 配置 |
| credentials/ | 凭证文件（含 API 密钥） |
| cron/ | 定时任务 |
| devices/ | 配对设备 |
| identity/ | 身份配置 |
| skills/ | 全局技能 |

## 恢复指南

详见备份目录中的 `RESTORE.md`

### 恢复配置
1. 停止 OpenClaw Gateway
2. 复制备份文件到 `$env:USERPROFILE\.openclaw\`
3. 重启 Gateway

## 注意事项

1. **credentials/ 包含敏感信息** - 妥善保管备份
2. 首次使用请务必修改配置中的路径
3. 建议设置自动备份任务防止数据丢失
