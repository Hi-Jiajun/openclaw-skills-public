---
name: openclaw-skills-github-sync
description: |
  将 OpenClaw skills 同步到 GitHub。非实时，需手动确认。
  支持 Windows/Linux/Mac。
  使用场景：skill 创建或修改完成后同步到 GitHub
  
  这是一个 OpenClaw GitHub 同步工具 skill，提供交互式配置向导。
---

# OpenClaw Skills GitHub Sync Skill

> 将你的 skills 同步到 GitHub，方便备份和分享

## 功能

- ✅ 交互式配置向导（首次使用简单上手）
- ✅ 支持私有仓库同步
- ✅ 支持公开仓库同步
- ✅ 每次同步需要手动确认（非实时，更安全）
- ✅ 自动检测变更并提交推送
- ✅ 支持 Windows / Linux / Mac

## 安装方式

### 方式一：从 ClawHub 安装（推荐）

1. 打开 https://clawhub.ai/search?q=openclaw-skills-github-sync
2. 点击安装即可

### 方式二：手动安装

```bash
# 克隆到你的 OpenClaw skills 目录
cd ~/.openclaw/skills
git clone https://github.com/Hi-Jiajun/openclaw-skills-github-sync.git
```

## 快速开始

### 首次使用（交互式配置）

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File "~/.openclaw/skills/openclaw-skills-github-sync/scripts/setup.ps1"
```

```bash
# Linux/Mac
chmod +x ~/.openclaw/skills/openclaw-skills-github-sync/scripts/setup.sh
~/.openclaw/skills/openclaw-skills-github-sync/scripts/setup.sh
```

交互式配置会引导你：
- 检查 GitHub 登录状态
- 设置私有 Skills 路径
- 设置公开 Skills 路径
- 自动初始化 Git 仓库

### 执行同步

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File "~/.openclaw/skills/openclaw-skills-github-sync/scripts/sync.ps1"
```

```bash
# Linux/Mac
chmod +x ~/.openclaw/skills/openclaw-skills-github-sync/scripts/sync.sh
~/.openclaw/skills/openclaw-skills-github-sync/scripts/sync.sh
```

## 工作流程

1. 你在 OpenClaw 中创建或修改了一个 skill
2. 我提醒你是否同步到 GitHub
3. 你确认后，我执行同步脚本
4. 脚本会自动：
   - 检测变更
   - 提交到 Git
   - 推送到远程仓库

## 手动配置（可选）

如果想手动配置，可以修改 `scripts/config.ps1` 或 `scripts/config.sh`：

### Windows
```powershell
$privatePath = "C:\Users\YourName\openclaw-skills-private"
$publicPath = "C:\Users\YourName\openclaw-skills-public"
```

### Linux/Mac
```bash
PRIVATE_PATH="$HOME/openclaw-skills-private"
PUBLIC_PATH="$HOME/openclaw-skills-public"
```

## 首次设置 GitHub

如果你还没有 GitHub 仓库：

```bash
# 安装 GitHub CLI
# Linux
sudo apt install gh

# Mac
brew install gh

# Windows
winget install GitHub.cli

# 登录
gh auth login

# 创建仓库
gh repo create my-openclaw-skills --private
gh repo create my-openclaw-skills-public --public
```

## 目录结构建议

```
~/openclaw-skills-private/     # 私有 skills
├── skill-1/
│   └── SKILL.md
├── skill-2/
│   └── SKILL.md
└── ...

~/openclaw-skills-public/      # 公开 skills
├── skill-a/
│   └── SKILL.md
└── ...
```

## 注意事项

- 公开仓库建议设置为私有，除非你愿意分享代码
- 同步前确保本地仓库已初始化
- credentials/ 目录不会被同步（仅同步 skills 代码）
- 这个 skill 本身也可以被同步到 GitHub

## 支持

- GitHub: https://github.com/Hi-Jiajun/openclaw-skills-github-sync
- 问题反馈: https://github.com/Hi-Jiajun/openclaw-skills-github-sync/issues
