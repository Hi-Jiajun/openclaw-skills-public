---
name: openclaw-backup
description: |
  自动备份 OpenClaw 配置文件。设置每日自动备份。
  使用场景：(1) 定期备份配置 (2) 迁移配置 (3) 恢复配置
---

# OpenClaw 备份技能

自动备份 OpenClaw 的所有配置文件到本地存储。

## 备份位置

- 本地备份：`Z:\backup\openclaw_backup`
- 自定义技能：`Z:\backup\openclaw_backup\my-own-skills`

## 自动备份（每日凌晨3点）

已设置定时任务自动执行：
- 备份时间：每天凌晨 3:00
- 保留最近 7 个备份

### 手动执行备份
```powershell
powershell -ExecutionPolicy Bypass -File "{USER_PATH}\.openclaw\workspace\skills\openclaw-backup\backup.ps1"
```

## 备份内容

| 目录/文件 | 说明 | 重要性 |
|-----------|------|--------|
| openclaw.json | 主配置文件 | ⭐⭐⭐ |
| agents/ | Agent 配置 | ⭐⭐⭐ |
| credentials/ | 凭证文件（含 API 密钥） | ⭐⭐⭐⭐ |
| cron/ | 定时任务 | ⭐⭐ |
| devices/ | 配对设备 | ⭐⭐ |
| identity/ | 身份配置 | ⭐⭐⭐ |
| skills/ | 全局技能 | ⭐⭐ |
| workspace/ | 工作区（含自定义技能） | ⭐⭐⭐⭐ |

## GitHub 同步

GitHub 同步功能已独立出来：

- **技能名称**：openclaw-github-sync
- **同步方式**：手动确认（不是实时）
- **使用场景**：skill 修改完成后同步到 GitHub

详见 [openclaw-github-sync](openclaw-github-sync/SKILL.md)

## 恢复指南

详见备份目录中的 `RESTORE.md`

### 方法1：完整恢复
1. 停止 OpenClaw Gateway
2. 备份当前配置（以防万一）
3. 复制备份文件到 `{USER_PATH}\.openclaw\`
4. 重启 Gateway

### 方法2：从 GitHub 恢复
```powershell
# 如果有 GitHub 仓库
git clone https://github.com/YOUR_USERNAME/openclaw-backup.git
# 然后复制到对应位置
```

### 方法3：选择性恢复
```powershell
# 只恢复配置
Copy-Item "Z:\backup\openclaw_backup\2026-03-08*\openclaw.json" "$env:USERPROFILE\.openclaw\"

# 只恢复自定义技能
Copy-Item "Z:\backup\openclaw_backup\my-own-skills\*" "$env:USERPROFILE\.openclaw\workspace\skills\" -Recurse
```

## 备份目录结构

```
Z:\backup\openclaw_backup\
├── 2026-03-08_03-00-00\      # 每日备份
│   ├── openclaw.json
│   ├── agents\
│   ├── credentials\
│   ├── cron\
│   ├── devices\
│   ├── identity\
│   ├── skills\
│   ├── workspace\
│   └── RESTORE.md
├── 2026-03-07_03-00-00\
├── ...
└── my-own-skills\            # 用户自定义技能
    └── workspace-skills\
```

## 注意事项

1. **credentials/ 包含敏感信息** - 妥善保管备份，不要公开分享
2. **定时备份每天凌晨3点自动执行** - 无需手动操作
3. **GitHub 同步是手动的** - 只有在你确认后才同步

