import Foundation

public enum FilePath {
    public static let packageName = "com.uuvpn.appleaman"
}

public extension FilePath {
    static let groupName = "group.\(packageName)"

    private static let defaultSharedDirectory: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: FilePath.groupName)

    #if os(iOS)
        static let sharedDirectory: URL = {
            // 优先使用 App Group，如果没有则使用应用自身的文档目录
            if let groupDir = defaultSharedDirectory {
                return groupDir
            }
            // 模拟器或没有 App Group 时使用应用自身的目录
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }()
    #elseif os(tvOS)
        static let sharedDirectory: URL = {
            let baseDir = defaultSharedDirectory ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return baseDir
                .appendingPathComponent("Library", isDirectory: true)
                .appendingPathComponent("Caches", isDirectory: true)
        }()
    #elseif os(macOS)
        static var sharedDirectory: URL = {
            if let groupDir = defaultSharedDirectory {
                return groupDir
            }
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }()
    #endif

    #if os(iOS)
        static let cacheDirectory = sharedDirectory
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Caches", isDirectory: true)
    #elseif os(tvOS)
        static let cacheDirectory = sharedDirectory
    #elseif os(macOS)
        static var cacheDirectory: URL {
            sharedDirectory
                .appendingPathComponent("Library", isDirectory: true)
                .appendingPathComponent("Caches", isDirectory: true)
        }
    #endif

    #if os(macOS)
        static var workingDirectory: URL {
            cacheDirectory.appendingPathComponent("Working", isDirectory: true)
        }
    #else
        static let workingDirectory = cacheDirectory.appendingPathComponent("Working", isDirectory: true)

    #endif

    static var iCloudDirectory: URL = {
        // iCloud 容器可能不存在，使用应用文档目录作为备选
        if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
            return iCloudURL.appendingPathComponent("Documents", isDirectory: true)
        }
        // 如果没有 iCloud 访问权限，使用应用本地文档目录
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("iCloudStub", isDirectory: true)
    }()
}

public extension URL {
    var fileName: String {
        var path = relativePath
        if let index = path.lastIndex(of: "/") {
            path = String(path[path.index(index, offsetBy: 1)...])
        }
        return path
    }
}
