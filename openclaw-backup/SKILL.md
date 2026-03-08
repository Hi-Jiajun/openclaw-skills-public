---
name: openclaw-backup
description: |
  自动备份 OpenClaw 本地存储配置文件。支持 Windows/Linux/Mac。
  使用场景：(1) 定期备份配置 (2) 迁移配置 (3) 恢复配置
  
  这是一个 OpenClaw 备份工具 skill，提供交互式配置向导。
---

# OpenClaw Backup Skill

> 自动备份 OpenClaw 配置，让数据永不丢失

## 功能

- ✅ 交互式配置向导（首次使用简单上手）
- ✅ 每日自动备份（可配置时间）
- ✅ 保留最近 N 个备份
- ✅ 旧备份自动转移和清理
- ✅ 按容量自动清理旧备份
- ✅ 支持 Windows / Linux / Mac

## 安装方式

### 方式一：从 ClawHub 安装（推荐）

1. 打开 https://clawhub.ai/search?q=openclaw-backup
2. 点击安装即可

### 方式二：手动安装

```bash
# 克隆到你的 OpenClaw skills 目录
cd ~/.openclaw/skills
git clone https://github.com/Hi-Jiajun/openclaw-backup.git
```

## 快速开始

### 首次使用（交互式配置）

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File "~/.openclaw/skills/openclaw-backup/scripts/setup.ps1"
```

```bash
# Linux/Mac
chmod +x ~/.openclaw/skills/openclaw-backup/scripts/setup.sh
~/.openclaw/skills/openclaw-backup/scripts/setup.sh
```

交互式配置会引导你设置：
- 备份根目录
- 旧备份目录
- 保留备份数量
- 容量限制

### 执行备份

```powershell
# Windows - 使用交互式配置后
powershell -ExecutionPolicy Bypass -File "~/.openclaw/skills/openclaw-backup/scripts/backup.ps1"
```

```bash
# Linux/Mac
chmod +x ~/.openclaw/skills/openclaw-backup/scripts/backup.sh
~/.openclaw/skills/openclaw-backup/scripts/backup.sh
```

### 设置定时自动备份

在 OpenClaw 中添加 cron 任务：
```bash
openclaw cron add --name "openclaw-backup" --schedule "0 3 * * *" --command "powershell -ExecutionPolicy Bypass -File C:\PATH\TO\skills\openclaw-backup\scripts\backup.ps1"
```

## 配置说明

如果想手动配置，可以修改 `scripts/config.ps1` 或 `scripts/config.sh`：

### Windows
```powershell
$backupRoot = "Z:\backup\openclaw_backup"
$oldBackupRoot = "Z:\backup\openclaw_backup_old"
$openclawHome = "$env:USERPROFILE\.openclaw"
$keepCount = 3
$maxOldSizeGB = 10
$targetOldSizeGB = 5
```

### Linux/Mac
```bash
BACKUP_ROOT="$HOME/openclaw_backup"
OLD_BACKUP_ROOT="$HOME/openclaw_backup_old"
OPENCLAW_HOME="$HOME/.openclaw"
KEEP_COUNT=3
MAX_OLD_SIZE_GB=10
TARGET_OLD_SIZE_GB=5
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
2. 复制备份文件到 `$HOME/.openclaw/`（Linux/Mac）或 `$env:USERPROFILE\.openclaw\`（Windows）
3. 重启 Gateway

## 注意事项

1. **credentials/ 包含敏感信息** - 妥善保管备份
2. 首次使用强烈建议运行交互式配置
3. 建议设置自动备份任务防止数据丢失
4. 备份文件定期检查完整性

## 支持

- GitHub: https://github.com/Hi-Jiajun/openclaw-backup
- 问题反馈: https://github.com/Hi-Jiajun/openclaw-backup/issues
