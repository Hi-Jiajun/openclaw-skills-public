---
name: openclaw-skills-github-sync
description: |
  将 OpenClaw skills 同步到 GitHub（非实时，需手动确认）。
  支持 Windows/Linux/Mac。
  使用场景：skill 创建或修改完成后同步到 GitHub
---

# OpenClaw Skills GitHub Sync Skill

将你的 OpenClaw skills 同步到 GitHub 仓库。

## 功能

- 支持私有仓库同步
- 支持公开仓库同步
- 每次同步需要手动确认（非实时）
- 自动检测变更并提交推送
- 支持 Windows / Linux / Mac

## 支持平台

| 平台 | 脚本 |
|------|------|
| Windows | scripts/sync.ps1 |
| Linux | scripts/sync.sh |
| Mac | scripts/sync.sh |

## 配置项

### Windows (scripts/sync.ps1)
```powershell
$privatePath = "C:\Users\YourName\openclaw-skills-private"
$publicPath = "C:\Users\YourName\openclaw-skills-public"
```

### Linux/Mac (scripts/sync.sh)
```bash
PRIVATE_PATH="$HOME/openclaw-skills-private"
PUBLIC_PATH="$HOME/openclaw-skills-public"
```

## 使用方法

### 首次设置

安装 GitHub CLI：
```bash
# Linux
sudo apt install gh

# Mac
brew install gh

# Windows
winget install GitHub.cli
```

登录 GitHub：
```bash
gh auth login
```

创建仓库：
```bash
gh repo create my-skills --private
gh repo create my-skills-public --public
```

初始化本地仓库：
```bash
cd ~/my-skills-folder
git init
git config user.email "your@email.com"
git config user.name "Your Name"
git remote add origin https://github.com/YOUR_USERNAME/your-repo.git
git push -u origin main
```

### 同步 skills

#### Windows
```powershell
powershell -ExecutionPolicy Bypass -File "scripts/sync.ps1"
```

#### Linux / Mac
```bash
chmod +x scripts/sync.sh
./scripts/sync.sh
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
