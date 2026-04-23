#!/bin/bash
# ============================================
# Git 自动同步脚本
# 监控目录变化，自动提交并推送到远程仓库
# 仓库: https://github.com/wushaoqiang88/uuvpn-deploy.git
# ============================================

REPO_DIR="/Users/wushaoqiang/Desktop/vpn/uuvpn-deploy"
LOG_FILE="$REPO_DIR/.git-auto-sync.log"
PID_FILE="$REPO_DIR/.git-auto-sync.pid"

# 记录日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 检查是否在仓库目录
cd "$REPO_DIR" || {
    log "❌ 错误: 无法进入仓库目录 $REPO_DIR"
    exit 1
}

# 写入 PID
echo $$ > "$PID_FILE"
log "🚀 自动同步服务已启动 (PID: $$)"
log "📁 监控目录: $REPO_DIR"
log "🌐 远程仓库: $(git remote get-url origin 2>/dev/null || echo 'unknown')"

# 同步函数
sync_repo() {
    # 检查是否有变更（包括 untracked 文件）
    if [ -z "$(git status --porcelain)" ]; then
        return 0
    fi

    log "📝 检测到文件变化，开始同步..."

    # 添加所有变更
    git add -A

    # 提交（使用时间戳作为提交信息）
    COMMIT_MSG="auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"

    if git commit -m "$COMMIT_MSG" 2>>"$LOG_FILE"; then
        log "✅ 提交成功: $COMMIT_MSG"
        # post-commit 钩子会自动处理推送
    else
        log "⚠️ 提交失败或无变更"
    fi
}

# 使用 fswatch 监控文件变化
# --exclude 排除 .git 目录和日志文件
if command -v fswatch >/dev/null 2>&1; then
    log "👁️ 使用 fswatch 监控文件变化..."

    fswatch -o \
        --exclude "\.git" \
        --exclude "\.git-auto-sync" \
        --exclude "\.DS_Store" \
        "$REPO_DIR" | while read -r event; do

        # 防抖：等待 3 秒，合并快速连续的变化
        sleep 3
        sync_repo
    done
else
    log "❌ fswatch 未安装，请运行: brew install fswatch"
    exit 1
fi