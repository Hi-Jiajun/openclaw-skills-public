#!/bin/bash

# OpenClaw Backup Script for Linux/Mac
# ==== 请根据需要修改以下配置 ====
BACKUP_ROOT="/path/to/backup"        # 备份根目录，请修改为你的路径
OLD_BACKUP_ROOT="/path/to/backup_old" # 旧备份目录
OPENCLAW_HOME="$HOME/.openclaw"     # OpenCLAW 主目录
KEEP_COUNT=3                         # 保留最新3个
MAX_OLD_SIZE_GB=10                   # 超过10GB清理
TARGET_OLD_SIZE_GB=5                 # 清理到5GB

# ============================================
BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M-%S")

echo "=========================================="
echo "OpenClaw Backup Start - $BACKUP_DATE"
echo "=========================================="

# Create backup directory
BACKUP_DIR="$BACKUP_ROOT/$BACKUP_DATE"
mkdir -p "$BACKUP_DIR"

# Backup items
SUCCESS_COUNT=0
FAIL_COUNT=0

backup_item() {
    local src="$1"
    local name="$2"
    local isDir="$3"
    
    if [ -e "$src" ]; then
        if [ "$isDir" = "true" ]; then
            cp -r "$src" "$BACKUP_DIR/$name"
        else
            cp "$src" "$BACKUP_DIR/$name"
        fi
        if [ $? -eq 0 ]; then
            echo "[OK] $name"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        else
            echo "[FAIL] $name"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    else
        echo "[SKIP] $name (not found)"
    fi
}

backup_item "$OPENCLAW_HOME/openclaw.json" "openclaw.json" "false"
backup_item "$OPENCLAW_HOME/agents" "agents" "true"
backup_item "$OPENCLAW_HOME/credentials" "credentials" "true"
backup_item "$OPENCLAW_HOME/cron" "cron" "true"
backup_item "$OPENCLAW_HOME/devices" "devices" "true"
backup_item "$OPENCLAW_HOME/identity" "identity" "true"
backup_item "$OPENCLAW_HOME/skills" "skills" "true"

# Create restore guide
cat > "$BACKUP_DIR/RESTORE.md" << EOF
# OpenClaw Backup Restore Guide
# Backup Time: $BACKUP_DATE

## Restore Methods

### Method 1: Full Restore
1. Stop OpenClaw Gateway
2. Backup current config
3. Copy files from backup to $OPENCLAW_HOME
4. Restart Gateway

### Method 2: Selective Restore
- Restore config: cp "$BACKUP_DIR/openclaw.json" "$OPENCLAW_HOME/"
- Restore skills: cp -r "$BACKUP_DIR/skills" "$OPENCLAW_HOME/skills/"

## Notes
- Restore path: $BACKUP_DIR
EOF

echo ""
echo "=========================================="
echo "Backup Complete!"
echo "Backup Location: $BACKUP_DIR"
echo "Success: $SUCCESS_COUNT, Failed: $FAIL_COUNT"
echo "=========================================="

# Cleanup old backups
if [ -d "$BACKUP_ROOT" ]; then
    BACKUPS=$(ls -td "$BACKUP_ROOT"/*/ 2>/dev/null | wc -l)
    if [ "$BACKUPS" -gt "$KEEP_COUNT" ]; then
        echo ""
        echo "Cleaning old backups (keep latest $KEEP_COUNT)..."
        ls -td "$BACKUP_ROOT"/*/ | tail -n +$((KEEP_COUNT + 1)) | while read dir; do
            BASENAME=$(basename "$dir")
            mkdir -p "$OLD_BACKUP_ROOT/$BASENAME"
            mv "$dir" "$OLD_BACKUP_ROOT/$BASENAME/"
            echo "[MOVED] $BASENAME -> old backup"
        done
    fi
fi

# Old backup size cleanup
if [ -d "$OLD_BACKUP_ROOT" ]; then
    echo ""
    echo "Checking old backups size..."
    
    OLD_SIZE_GB=$(du -sg "$OLD_BACKUP_ROOT" 2>/dev/null | cut -f1)
    OLD_SIZE_GB=${OLD_SIZE_GB:-0}
    
    echo "Old backups total size: $OLD_SIZE_GB GB"
    
    if [ "$OLD_SIZE_GB" -gt "$MAX_OLD_SIZE_GB" ]; then
        echo "Cleaning to $TARGET_OLD_SIZE_GB GB..."
        
        ls -tdr "$OLD_BACKUP_ROOT"/*/ | while read dir; do
            CURRENT_SIZE=$(du -sg "$OLD_BACKUP_ROOT" 2>/dev/null | cut -f1)
            CURRENT_SIZE=${CURRENT_SIZE:-0}
            
            if [ "$CURRENT_SIZE" -le "$TARGET_OLD_SIZE_GB" ]; then
                break
            fi
            
            BASENAME=$(basename "$dir")
            rm -rf "$dir"
            echo "[DELETED] $BASENAME"
        done
    fi
fi

echo ""
echo "=========================================="
