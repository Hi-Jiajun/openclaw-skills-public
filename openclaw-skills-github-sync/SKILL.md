---
name: openclaw-skills-github-sync
description: |
  将 OpenClaw skills 同步到 GitHub（非实时，需手动确认）。
  支持 Linux/Mac。
  使用场景：skill 创建或修改完成后同步到 GitHub
---

# OpenClaw Skills GitHub Sync Skill

> 将你的 OpenClaw skills 同步到 GitHub

⚠️ **注意**：当前版本仅支持 **Linux/Mac**。Windows 版本正在开发中。

## 功能

- ✅ 交互式配置向导
- ✅ 支持私有仓库同步
- ✅ 支持公开仓库同步
- ✅ 手动确认同步（非实时，更安全）
- ✅ 自动检测变更并提交推送
- ⚠️ Linux / Mac 支持

## 支持平台

| 平台 | 脚本 | 状态 |
|------|------|------|
| Linux | scripts/sync.sh | ✅ 可用 |
| Mac | scripts/sync.sh | ✅ 可用 |
| Windows | scripts/sync.ps1 | ⏳ 开发中 |

## 使用方法

### 首次设置

```bash
# 安装 GitHub CLI
# Linux
sudo apt install gh

# Mac
brew install gh

# 登录
gh auth login

# 创建仓库
gh repo create my-skills --private
gh repo create my-skills-public --public
```

### 初始化本地仓库

```bash
cd ~/my-skills-folder
git init
git config user.email "your@email.com"
git config user.name "Your Name"
git remote add origin https://github.com/YOUR_USERNAME/your-repo.git

# 确保创建 .gitignore 文件排除敏感目录
echo "credentials/" >> .gitignore
echo "*.key" >> .gitignore

git add .gitignore
git commit -m "Add .gitignore"
git push -u origin main
```

### 同步 skills

#### Linux / Mac
```bash
chmod +x scripts/sync.sh
./scripts/sync.sh
```

## 安全说明

### 重要：排除敏感目录

本工具会自动创建 .gitignore 文件，包含以下排除项：

```
credentials/
*.key
*.pem
.DS_Store
*.log
```

**使用前请确保**：
1. 仓库中已包含 .gitignore 文件
2. 敏感目录（如 credentials/）已被排除
3. 推送前运行 `git status` 确认要推送的内容

### 同步前确认

脚本会：
1. 检查 .gitignore 是否存在，如不存在则自动创建
2. 显示将要推送的文件列表
3. 询问确认后才执行推送

## 注意事项

- ⚠️ Windows 版本正在开发中
- 公开仓库建议设置为私有
- 同步前务必检查 .gitignore 配置
- credentials/ 目录请确保已排除
