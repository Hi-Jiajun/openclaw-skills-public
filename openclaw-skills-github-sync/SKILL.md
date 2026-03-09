---
name: project-maintainer
description: |
  自动维护项目的 GitHub 和 ClawHub 同步。检测本地修改 → 同步到 private/public 仓库 → 发布到 ClawHub → 自动修复问题。
  使用场景：(1) 本地 skill 修改后自动同步 (2) 定时检查并更新仓库
---

# 项目维护 (Project Maintainer)

自动维护 GitHub 仓库和 ClawHub 同步。

## 概述

监听本地 skills 修改，自动完成以下流程：

```
本地修改 → 检验 ClawHub → 同步 private → 同步 public → 发布 ClawHub → 自动修复
```

## 仓库对应

| 仓库 | 类型 | 用途 |
|------|------|------|
| openclaw-skills-private | 私有 | 你创建的自定义 skills |
| openclaw-skills-public | 公开 | 愿意公开的 skills |
| openclaw-backup-hiliang | 公开 | 备份相关 |
| openclaw-skills-github-sync-hiliang | 公开 | 同步工具 |

## 自动同步流程

### 1. 检测修改
- 扫描 workspace 中的自建 skills
- 检测 git 状态变化

### 2. ClawHub 检验
- 检查 SKILL.md 格式
- 验证描述是否完整
- 检查是否有敏感信息

### 3. 同步到 GitHub
- **private 仓库**：同步所有自建 skills
- **public 仓库**：同步脱敏后的 skills（移除个人配置、凭证路径等）

### 4. 发布到 ClawHub
- 自动发布/更新到 ClawHub
- 检测发布结果

### 5. 自动修复
- 如果 ClawHub 提示问题
- 自动分析问题并修复
- 重新发布验证

## 路径配置

- 自建 skills 目录：`{USER_PATH}\.openclaw\workspace\skills\`
- 私有仓库：`{USER_PATH}\.openclaw\workspace\openclaw-skills-private\`
- 公开仓库：`{USER_PATH}\.openclaw\workspace\openclaw-skills-public\`

## 常用命令

### 手动触发同步
```powershell
powershell -ExecutionPolicy Bypass -File "project-maintainer.ps1"
```

### 仅同步 private
```powershell
./project-maintainer.ps1 -Target private
```

### 仅同步 public
```powershell
./project-maintainer.ps1 -Target public
```

### 仅发布到 ClawHub
```powershell
./project-maintainer.ps1 -Target clawhub
```

## 自动触发

建议设置 cron 任务，每天定时检查并同步：

```
每天 3:00 自动备份 + 同步
```

## 敏感信息处理

同步到 public 仓库时会自动移除：
- 绝对路径（如 {USER_PATH}\...）
- 个人凭证信息
- API Keys
- 本地特定配置

## 注意事项

- 需要 Git CLI 和 GitHub CLI
- 需要先登录 GitHub：`gh auth login`
- 需要先登录 ClawHub：`clawdhub login`

