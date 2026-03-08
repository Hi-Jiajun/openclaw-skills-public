# OpenClaw Public Skills

这里存放我愿意公开分享的 OpenClaw skills。

## 公开 Skills

### [openclaw-backup](https://github.com/Hi-Jiajun/openclaw-backup)

> 自动备份 OpenClaw 配置，让数据永不丢失

一个 OpenClaw skill，提供交互式配置向导，自动备份你的 OpenClaw 配置。

**特性：**
- 🎯 交互式配置向导，5分钟快速上手
- 🔄 自动备份，保留多个版本
- 🧹 智能清理，自动转移和删除旧备份
- 🌐 支持 Windows / Linux / Mac

**安装：**

```bash
# Windows
cd $env:USERPROFILE\.openclaw\skills
git clone https://github.com/Hi-Jiajun/openclaw-backup.git

# Linux / Mac
cd ~/.openclaw/skills
git clone https://github.com/Hi-Jiajun/openclaw-backup.git
```

或从 ClawHub 安装：https://clawhub.ai/skills/openclaw-backup

---

### [openclaw-skills-github-sync](https://github.com/Hi-Jiajun/openclaw-skills-github-sync)

> 将你的 OpenClaw skills 同步到 GitHub

一个 OpenClaw skill，提供交互式配置向导，将你的 skills 同步到 GitHub 仓库。

**特性：**
- 🎯 交互式配置向导，5分钟快速上手
- 🔒 手动确认同步，安全可控
- 🌐 私有/公开双仓库支持
- 🌍 支持 Windows / Linux / Mac

**安装：**

```bash
# Windows
cd $env:USERPROFILE\.openclaw\skills
git clone https://github.com/Hi-Jiajun/openclaw-skills-github-sync.git

# Linux / Mac
cd ~/.openclaw/skills
git clone https://github.com/Hi-Jiajun/openclaw-skills-github-sync.git
```

或从 ClawHub 安装：https://clawhub.ai/skills/openclaw-skills-github-sync

---

## 快速开始

每个 skill 都提供交互式配置向导，首次使用只需运行：

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File "scripts/setup.ps1"

# Linux / Mac
chmod +x scripts/setup.sh
./scripts/setup.sh
```

详细使用说明请查看各 skill 的 SKILL.md。

---

## Star ⭐

如果对你有帮助，欢迎 Star！

- https://github.com/Hi-Jiajun/openclaw-backup
- https://github.com/Hi-Jiajun/openclaw-skills-github-sync
