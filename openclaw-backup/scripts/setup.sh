#!/bin/bash

# OpenClaw Backup - Interactive Setup for Linux/Mac

echo "=========================================="
echo "OpenClaw Backup - 交互式配置向导"
echo "=========================================="
echo ""

# Default paths
default_backup_root="$HOME/openclaw_backup"
default_old_backup="$HOME/openclaw_backup_old"

echo "1. 设置备份根目录"
echo "   默认: $default_backup_root"
read -p "   输入新路径（直接回车使用默认值）: " backup_root
backup_root=${backup_root:-$default_backup_root}

echo ""
echo "2. 设置旧备份目录"
echo "   默认: $default_old_backup"
read -p "   输入新路径（直接回车使用默认值）: " old_backup_root
old_backup_root=${old_backup_root:-$default_old_backup}

echo ""
echo "3. 设置保留备份数量"
echo "   默认: 3"
read -p "   输入数字（直接回车使用默认值）: " keep_count
keep_count=${keep_count:-3}

echo ""
echo "4. 设置旧备份容量限制 (GB)"
echo "   默认: 10 (超过10GB后清理到5GB)"
read -p "   输入数字（直接回车使用默认值）: " max_size
max_old_size_gb=${max_size:-10}

echo ""
echo "=========================================="
echo "配置完成！"
echo "=========================================="
echo ""
echo "备份根目录: $backup_root"
echo "旧备份目录: $old_backup_root"
echo "保留数量: $keep_count"
echo "容量限制: ${max_old_size_gb}GB"
echo ""

# Save config
config_file="$(dirname "$0")/config.sh"

cat > "$config_file" << EOF
# OpenClaw Backup 配置
# 由 setup.sh 自动生成

BACKUP_ROOT="$backup_root"
OLD_BACKUP_ROOT="$old_backup_root"
OPENCLAW_HOME="$HOME/.openclaw"
KEEP_COUNT=$keep_count
MAX_OLD_SIZE_GB=$max_old_size_gb
TARGET_OLD_SIZE_GB=5
EOF

echo "配置已保存到: $config_file"
echo ""
echo "运行备份: bash $(dirname "$0")/backup.sh"
