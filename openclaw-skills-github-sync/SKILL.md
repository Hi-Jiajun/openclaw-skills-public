---
name: openclaw-skills-github-sync
description: |
  将 OpenClaw skills 同步到 GitHub（非实时，需手动确认）。
  使用场景：skill 创建或修改完成后同步到 GitHub
---

# OpenClaw Skills GitHub Sync Skill

将你的 OpenClaw skills 同步到 GitHub 仓库。

## 功能

- 支持私有仓库同步
- 支持公开仓库同步
- 每次同步需要手动确认（非实时）
- 自动检测变更并提交推送

## 配置项

使用前请根据需要修改脚本中的配置：

```powershell
# 私有 skills 路径
$privatePath = "C:\Users\hiliang\Documents\openclaw-skills-private"

# 公开 skills 路径
$publicPath = "C:\Users\hiliang\Documents\openclaw-skills-public"
```

## 使用方法

### 1. 首次设置

```powershell
# 安装 GitHub CLI
winget install GitHub.cli

# 登录 GitHub
gh auth login

# 创建私有仓库（用于私有 skills）
gh repo create your-private-skills --private

# 创建公开仓库（用于公开 skills）
gh repo create your-public-skills --public
```

### 2. 初始化本地仓库

```powershell
cd C:\PATH\TO\your-skills-folder
git init
git config user.email "your@email.com"
git config user.name "Your Name"
git remote add origin https://github.com/YOUR_USERNAME/your-repo.git
git push -u origin main
```

### 3. 同步 skills

运行脚本：
```powershell
powershell -ExecutionPolicy Bypass -File "openclaw-skills-github-sync\sync.ps1"
```

## 同步流程

1. 你创建或修改 skill 后
2. 提醒你是否同步到 GitHub
3. 你确认后执行同步脚本
4. 脚本会自动检测变更、提交并推送到对应仓库

## 注意事项

- 公开仓库建议设置为私有，除非你愿意分享代码
- 同步前确保本地仓库已初始化
- credentials/ 目录不会被同步（仅同步 skills 代码）
