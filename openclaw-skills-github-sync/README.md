# OpenClaw Skills GitHub Sync

OpenClaw skills GitHub 同步工具。

## 功能

- 支持私有仓库同步
- 支持公开仓库同步
- 每次同步需要手动确认（非实时）
- 自动检测变更并提交推送
- 支持 Windows / Linux / Mac

## 使用说明

这是一个 OpenClaw skill，结构如下：

```
openclaw-skills-github-sync/
├── SKILL.md           # Skill 定义和使用说明
├── README.md           # 本文件
└── scripts/
    ├── sync.ps1       # Windows 脚本
    └── sync.sh        # Linux/Mac 脚本
```

详细使用说明请查看 [SKILL.md](SKILL.md)

## 快速开始

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File "scripts/sync.ps1"
```

### Linux / Mac

```bash
chmod +x scripts/sync.sh
./scripts/sync.sh
```

## GitHub

https://github.com/Hi-Jiajun/openclaw-skills-github-sync
