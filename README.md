# UUVPN 部署仓库

包含完整的 iOS 客户端和后端服务源代码，可直接克隆部署。

## 项目结构

```
uuvpn-deploy/
├── README.md                 # 项目说明
├── .gitignore               # Git 忽略文件
├── backend/                 # 后端服务（完整源代码）
│   ├── src/                 # Xboard 源代码
│   ├── data/                # 数据目录
│   ├── docker-compose.yml   # Docker 配置
│   ├── .env.example         # 环境变量模板
│   └── deploy.sh            # 一键部署脚本
└── ios-client/              # iOS 客户端（完整源代码）
    ├── XiaoXiong/           # 主应用
    ├── Extension/           # VPN 扩展
    ├── ApplicationLibrary/  # 共享库
    ├── Library/             # 核心库
    └── uuvpn.xcodeproj      # Xcode 项目
```

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/wushaoqiang88/uuvpn-deploy.git
cd uuvpn-deploy
```

### 2. 部署后端服务

```bash
cd backend

# 编辑环境配置
vim .env

# 运行部署脚本
./deploy.sh
```

服务将在 http://localhost:7001 启动

### 3. 配置 iOS 客户端

1. 打开 `ios-client/uuvpn.xcodeproj`
2. 修改服务器地址：`XiaoXiong/DefaultUI/Network/UserManager.swift`
3. 配置签名证书
4. 编译运行

## 后端详细说明

### 环境变量 (.env)

```bash
APP_NAME=XBoard
APP_ENV=production
APP_KEY=base64:...  # 使用 php artisan key:generate 生成
APP_DEBUG=false
APP_URL=http://your-server-ip

# 数据库配置（默认 SQLite）
DB_CONNECTION=sqlite
DB_DATABASE=data/database/database.sqlite
```

### 使用 MySQL (可选)

修改 `docker-compose.yml` 和 `.env` 启用 MySQL。

### 目录说明

- `src/` - 完整的 Xboard 源代码
- `data/database/` - SQLite 数据库文件
- `data/logs/` - 日志文件
- `data/theme/` - 主题文件
- `data/plugins/` - 插件目录

## iOS 客户端详细说明

### 系统要求

- Xcode 15.0+
- iOS 15.0+
- macOS 14.0+

### 修改服务器地址

编辑 `ios-client/XiaoXiong/DefaultUI/Network/UserManager.swift`：

```swift
public let configURL = "http://YOUR_SERVER_IP:7001/api/v1/"
```

### 依赖管理

项目使用 Swift Package Manager 管理依赖：
- Crisp - 客服系统
- GRDB - SQLite 数据库
- Lottie - 动画
- QRCode - 二维码生成

### 打包发布

1. Product → Archive
2. Distribute App → Ad Hoc / App Store

## 常见问题

### 真机无法连接后端

确保手机和服务器在同一网络，或服务器有公网 IP。

### 修改服务器地址后无效

清除 App 缓存或重新安装 App。

### 后端部署失败

检查 Docker 和 Docker Compose 是否正确安装。

## 更新代码

```bash
git pull

# 更新后端
cd backend
docker-compose up -d --build

# 更新 iOS
# 在 Xcode 中重新编译
```

## 技术栈

- **后端**: PHP (Laravel) + SQLite/MySQL + Redis + Docker
- **iOS**: SwiftUI + Network Extension + Swift Package Manager
- **部署**: Docker Compose

## 许可证

请参考各子项目的 LICENSE 文件。
