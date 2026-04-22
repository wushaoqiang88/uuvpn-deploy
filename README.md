# UUVPN 部署仓库

包含 iOS 客户端和后端服务的完整部署方案。

## 项目结构

```
uuvpn-deploy/
├── backend/          # Xboard 后端服务
├── ios-client/       # iOS 客户端代码
├── docker-compose.yml
└── README.md
```

## 快速开始

### 1. 克隆仓库

```bash
git clone <your-repo-url>
cd uuvpn-deploy
```

### 2. 启动后端服务

```bash
cd backend
docker-compose up -d
```

服务将在 http://localhost:7001 启动

### 3. 配置 iOS 客户端

打开 `ios-client/UUVPN.xcodeproj`，修改 `UserManager.swift` 中的服务器地址：

```swift
public let configURL = "http://YOUR_SERVER_IP:7001/api/v1/"
```

### 4. 后台管理

访问 `http://YOUR_SERVER_IP:7001/{admin_path}`

默认管理员账号密码请在首次安装时设置。

## 后端配置说明

### 环境变量 (.env)

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| APP_NAME | 应用名称 | XBoard |
| APP_URL | 应用URL | http://localhost |
| DB_CONNECTION | 数据库类型 | sqlite |
| DB_DATABASE | 数据库文件 | .docker/.data/database.sqlite |

### 使用 MySQL (可选)

修改 `docker-compose.yml` 和 `.env`：

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: your_password
      MYSQL_DATABASE: xboard
```

```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=xboard
DB_USERNAME=root
DB_PASSWORD=your_password
```

## iOS 客户端说明

### 修改服务器地址

编辑 `ios-client/XiaoXiong/DefaultUI/Network/UserManager.swift`：

```swift
public let configURL = "http://YOUR_SERVER_IP:7001/api/v1/"
```

### 打包发布

1. 在 Xcode 中选择真机或 Archive
2. 配置签名证书
3. Product → Archive → Distribute App

## 常见问题

### 真机无法连接后端

确保手机和服务器在同一网络，或服务器部署在公网。

### 修改服务器地址后无效

清除 App 缓存或重新安装 App。

## 技术栈

- **后端**: PHP (Laravel) + SQLite/MySQL + Redis
- **iOS**: SwiftUI + Network Extension
- **部署**: Docker + Docker Compose

## 许可证

请参考各子项目的许可证文件。
