#!/bin/bash

# Xboard 后端部署脚本
# 包含完整源代码部署

set -e

echo "========================================"
echo "  UUVPN 后端服务部署脚本"
echo "========================================"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "错误: Docker 未安装"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "错误: Docker Compose 未安装"
    echo "请先安装 Docker Compose"
    exit 1
fi

# 创建必要目录
echo "创建数据目录..."
mkdir -p data/database
mkdir -p data/logs
mkdir -p data/theme
mkdir -p data/plugins

# 复制环境配置文件
if [ ! -f .env ]; then
    echo "创建环境配置文件..."
    cp .env.example .env
    echo "请编辑 .env 文件配置您的数据库和其他设置"
    echo ""
    echo "重要配置项:"
    echo "  - APP_URL: 修改为服务器实际地址"
    echo "  - APP_KEY: 使用 'php artisan key:generate' 生成"
    echo ""
fi

# 构建并启动服务
echo "构建并启动 Xboard 服务..."
docker-compose up -d --build

# 等待服务启动
echo "等待服务启动..."
sleep 10

# 检查服务状态
if docker-compose ps | grep -q "Up"; then
    echo ""
    echo "========================================"
    echo "  部署成功!"
    echo "========================================"
    echo ""
    echo "服务地址: http://$(hostname -I | awk '{print $1}'):7001"
    echo ""
    echo "首次安装请访问:"
    echo "http://$(hostname -I | awk '{print $1}'):7001"
    echo ""
    echo "常用命令:"
    echo "  查看日志: docker-compose logs -f"
    echo "  停止服务: docker-compose down"
    echo "  重启服务: docker-compose restart"
    echo "  更新代码: git pull && docker-compose up -d --build"
    echo ""
else
    echo ""
    echo "========================================"
    echo "  部署可能出现问题"
    echo "========================================"
    echo ""
    echo "请检查日志: docker-compose logs"
    echo ""
fi
