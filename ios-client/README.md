# UUVPN iOS 客户端

## 项目说明

基于 SwiftUI 开发的 iOS VPN 客户端，支持 sing-box 内核。

## 环境要求

- Xcode 15.0+
- iOS 15.0+
- macOS 14.0+ (用于开发)

## 快速开始

### 1. 配置服务器地址

编辑 `XiaoXiong/DefaultUI/Network/UserManager.swift`：

```swift
// 修改为你的后端服务器地址
public let configURL = "http://YOUR_SERVER_IP:7001/api/v1/"
```

### 2. 配置签名

在 Xcode 中：
1. 选择项目文件
2. 选择 Target (SFI)
3. 切换到 Signing & Capabilities
4. 选择你的 Team
5. 修改 Bundle Identifier (例如: com.yourname.uuvpn)

### 3. 运行

- 模拟器: 选择 iOS Simulator → 点击 Run
- 真机: 连接 iPhone → 选择设备 → 点击 Run

## 项目结构

```
ios-client/
├── XiaoXiong/              # 主应用代码
│   ├── DefaultUI/          # UI 界面
│   │   ├── View/           # 视图
│   │   ├── Network/        # 网络请求
│   │   └── Model/          # 数据模型
│   └── Application.swift   # 应用入口
├── Extension/              # VPN 扩展
├── ApplicationLibrary/     # 共享库
└── Library/                # 核心库
```

## 主要功能

- [x] 用户登录/注册
- [x] 节点订阅
- [x] VPN 连接
- [x] 节点测速
- [x] 分流规则
- [x] 客服系统 (Crisp)

## 打包发布

### 测试版 (Ad Hoc)

1. Product → Archive
2. Distribute App → Ad Hoc
3. 选择证书和描述文件
4. 导出 ipa 文件

### App Store

1. Product → Archive
2. Distribute App → App Store Connect
3. 上传后等待审核

## 注意事项

### 真机测试

- 确保手机和服务器在同一局域网，或服务器部署在公网
- 首次安装需要在设置中信任开发者证书

### Network Extension

VPN 功能需要：
- 有效的开发者账号
- Network Extension 权限
- App Groups 配置

## 常见问题

### 编译错误 "IPC failed"

这是模拟器限制，真机不会出现。已在代码中添加模拟器检测跳过 VPN 安装。

### 登录失败

1. 检查服务器地址是否正确
2. 确保手机能访问服务器
3. 检查后端服务是否正常运行

### 无法连接 VPN

1. 确保已安装 VPN 配置
2. 检查 Network Extension 权限
3. 查看系统设置中的 VPN 配置

## 自定义配置

### 修改主题颜色

编辑 `Assets.xcassets` 中的颜色资源。

### 修改服务器地址

编辑 `UserManager.swift` 中的 `configURL`。

### 修改客服 ID

编辑后端返回的配置中的 `crisptoken`。

## 许可证

请参考项目根目录的 LICENSE 文件。
