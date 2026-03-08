# OpenClaw Backup

OpenClaw 配置自动备份工具。

## 功能

- 自动备份 OpenClaw 本地配置文件
- 保留最近 N 个备份版本
- 旧备份自动转移和清理
- 支持 Windows / Linux / Mac

## 使用说明

这是一个 OpenClaw skill，结构如下：

```
openclaw-backup/
├── SKILL.md           # Skill 定义和使用说明
├── README.md           # 本文件
└── scripts/
    ├── backup.ps1     # Windows 脚本
    └── backup.sh      # Linux/Mac 脚本
```

详细使用说明请查看 [SKILL.md](SKILL.md)

## 快速开始

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File "scripts/backup.ps1"
```

### Linux / Mac

```bash
chmod +x scripts/backup.sh
./scripts/backup.sh
```

## GitHub

https://github.com/Hi-Jiajun/openclaw-backup
