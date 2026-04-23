#!/bin/bash
# ============================================
# Git 自动同步服务管理脚本
# 用法: ./auto-sync-manager.sh [start|stop|restart|status|logs]
# ============================================

REPO_DIR="/Users/wushaoqiang/Desktop/vpn/uuvpn-deploy"
PID_FILE="$REPO_DIR/.git-auto-sync.pid"
LOG_FILE="$REPO_DIR/.git-auto-sync.log"

case "$1" in
    start)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "✅ 自动同步服务已在运行 (PID: $(cat $PID_FILE))"
            exit 0
        fi
        cd "$REPO_DIR" && nohup ./auto-sync.sh > /dev/null 2>&1 &
        echo "🚀 自动同步服务已启动"
        sleep 1
        ./auto-sync-manager.sh status
        ;;
    stop)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            if kill -0 "$PID" 2>/dev/null; then
                kill "$PID" 2>/dev/null
                rm -f "$PID_FILE"
                echo "🛑 自动同步服务已停止"
            else
                rm -f "$PID_FILE"
                echo "⚠️ 服务未运行，已清理 PID 文件"
            fi
        else
            echo "⚠️ 服务未运行"
        fi
        ;;
    restart)
        ./auto-sync-manager.sh stop
        sleep 1
        ./auto-sync-manager.sh start
        ;;
    status)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "✅ 自动同步服务运行中 (PID: $(cat $PID_FILE))"
            echo "📁 监控目录: $REPO_DIR"
            echo "🌐 远程仓库: $(cd $REPO_DIR && git remote get-url origin 2>/dev/null)"
        else
            echo "❌ 自动同步服务未运行"
        fi
        ;;
    logs)
        if [ -f "$LOG_FILE" ]; then
            echo "📋 最近 30 条日志:"
            tail -n 30 "$LOG_FILE"
        else
            echo "⚠️ 日志文件不存在"
        fi
        ;;
    *)
        echo "用法: $0 [start|stop|restart|status|logs]"
        echo ""
        echo "命令说明:"
        echo "  start    - 启动自动同步服务"
        echo "  stop     - 停止自动同步服务"
        echo "  restart  - 重启自动同步服务"
        echo "  status   - 查看服务状态"
        echo "  logs     - 查看最近日志"
        exit 1
        ;;
