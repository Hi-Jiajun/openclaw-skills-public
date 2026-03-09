---
name: openclaw-backup
description: |
  自动备份 OpenClaw 配置文件。自建 skills 单独备份。
  使用场景：(1) 定期备份配置 (2) 迁移配置 (3) 恢复配置
---

# OpenClaw 备份技能

自动备份 OpenClaw 的所有配置文件到本地存储。

## 备份位置

| 类型 | 路径 |
|------|------|
| 主备份 | `Z:\backup\openclaw_backup\{hostname}\{日期}\` |
| 自建 skills | `Z:\backup\openclaw_backup\custom-skills\{日期}\` |
| 旧备份 | `Z:\backup\openclaw_backup_old\{hostname or custom-skills}\{日期}\` |

## 自动备份（每日凌晨3点）

已设置定时任务自动执行：
- 备份时间：每天凌晨 3:00
- 保留最近 3 个备份

### 手动执行备份
```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\hiliang\.openclaw\workspace\skills\openclaw-backup\backup.ps1"
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
| workspace/ | 工作区（含自定义技能） |

## 自建 Skills 备份

自建 skills 单独备份到 `custom-skills` 目录：

```
custom-skills\
└── 2026-03-09_15-51-08\
    ├── mweb-automation\
    ├── mweb-download\
    ├── mweb-get-task\
    ├── mweb-publish\
    ├── mweb-seed\
    ├── openclaw-backup\
    └── openclaw-skills-github-sync\
```

## 备份规则

- **主备份**：保留最新 3 个
- **自建 skills**：保留最新 3 个
- **旧备份**：移到 `openclaw_backup_old` 目录

## 恢复指南

详见备份目录中的 `RESTORE.md`

### 恢复全部
```powershell
# 停止 OpenClaw Gateway
Copy-Item "Z:\backup\openclaw_backup\{hostname}\{日期}\*" "$env:USERPROFILE\.openclaw\" -Recurse
```

### 仅恢复自建 skills
```powershell
Copy-Item "Z:\backup\openclaw_backup\custom-skills\{日期}\*" "$env:USERPROFILE\.openclaw\workspace\skills\" -Recurse
```

## 注意事项

1. **credentials/ 包含敏感信息** - 妥善保管备份，不要公开分享
2. **定时备份每天凌晨3点自动执行** - 无需手动操作
