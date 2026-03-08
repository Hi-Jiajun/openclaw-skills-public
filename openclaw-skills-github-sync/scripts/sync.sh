#!/bin/bash

# OpenClaw Skills GitHub Sync Script for Linux/Mac
# ==== 请根据你的路径修改以下配置 ====
PRIVATE_PATH="$HOME/openclaw-skills-private"   # 私有 skills 路径
PUBLIC_PATH="$HOME/openclaw-skills-public"      # 公开 skills 路径

echo "=========================================="
echo "OpenClaw Skills GitHub Sync"
echo "=========================================="

# Function to sync a repository
sync_repo() {
    local repo_path="$1"
    local repo_name="$2"
    
    if [ ! -d "$repo_path" ]; then
        echo "[SKIP] $repo_name not found"
        return
    fi
    
    cd "$repo_path"
    
    if [ ! -d ".git" ]; then
        echo "[SKIP] $repo_name - Not a git repository"
        return
    fi
    
    status=$(git status --porcelain)
    
    if [ -n "$status" ]; then
        echo "Changes in $repo_name"
        echo "$status"
        
        git add -A
        git commit -m "Sync $(date '+%Y-%m-%d %H:%M')"
        git push origin main
        
        if [ $? -eq 0 ]; then
            echo "[OK] $repo_name synced"
        else
            echo "[FAIL] $repo_name sync failed"
        fi
    else
        echo "[OK] $repo_name - No changes"
    fi
}

# Sync private skills
echo ""
echo "--- Private Skills ---"
sync_repo "$PRIVATE_PATH" "Private"

# Sync public skills  
echo ""
echo "--- Public Skills ---"
sync_repo "$PUBLIC_PATH" "Public"

echo ""
echo "=========================================="
