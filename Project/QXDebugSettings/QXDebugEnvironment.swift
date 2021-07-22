//
//  QXSetting.swift
//  Project
//
//  Created by labi3285 on 2019/12/16.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

/**
 * 样例
 *
 
 let gobal_key_test1 = QXDebugGlobalSwitch.Key("调试开关1", "test1")
 let gobal_key_test2 = QXDebugGlobalSwitch.Key("调试开关2", "test2")
 
 let key_api1 = QXDebugSetting.Key("api地址1", "api1")
 let key_api2 = QXDebugSetting.Key("api地址2", "api2")
 let key_api3 = QXDebugSetting.Key("api地址3", "api3")

 /// 在所有方法之前配置
 func SetupApis() {
 
     QXDebugGlobalSwitch.switches = [
         QXDebugGlobalSwitch(gobal_key_test1, true),
         QXDebugGlobalSwitch(gobal_key_test2, true),
     ]
     QXDebugSetting.settings = [
         QXDebugSetting(.release, key_api1, "release_url1"),
         QXDebugSetting(.release, key_api2, "release_url2"),
         QXDebugSetting(.release, key_api3, "release_url3"),
         
         QXDebugSetting(.test, key_api1, "test_url1"),
         QXDebugSetting(.test, key_api2, "test_url2"),
         QXDebugSetting(.test, key_api3, "test_url3"),

         QXDebugSetting(.uat, key_api1, "uat_url1"),
         QXDebugSetting(.uat, key_api2, "uat_url2"),
         QXDebugSetting(.uat, key_api3, "uat_url3"),
         
         QXDebugSetting(.other1(name: "自定义环境1"), key_api1, "other1_url1"),
         QXDebugSetting(.other1(name: "自定义环境1"), key_api2, "other1_url2"),
         QXDebugSetting(.other1(name: "自定义环境1"), key_api3, "other1_url3"),
         
         QXDebugSetting(.custom, key_api1, "custom_url1"),
         QXDebugSetting(.custom, key_api2, "custom_url2"),
         QXDebugSetting(.custom, key_api3, "custom_url3"),
     ]
 }

 var baseApi1: String {
     return QXDebugSetting.value(key_api1) as? String ?? ""
 }
 var baseApi2: String {
     return QXDebugSetting.value(key_api2) as? String ?? ""
 }
 var baseApi3: String {
     return QXDebugSetting.value(key_api3) as? String ?? ""
 }
 
 */

public struct QXDebugSetting {
    
    public static var isForceDebugMode: Bool = false
    
    public static var envirment: QXDebugSetting.Environment {
        func debugEnvirment() -> QXDebugSetting.Environment {
            if let code = UserDefaults.standard.value(forKey: "kQXDebugEnvironmentCode") as? String {
                switch code {
                case "release":
                    return .release
                case "custom":
                    return .custom
                case "test":
                    return .test
                case "uat":
                    return .uat
                case "ut":
                    return .ut
                case "it":
                    return .it
                case "st":
                    return .st
                default:
                    if code.hasPrefix("other1_") {
                        let name = code.replacingOccurrences(of: "other1_", with: "")
                        return .other1(name: name)
                    } else if code.hasPrefix("other2_") {
                        let name = code.replacingOccurrences(of: "other2_", with: "")
                        return .other2(name: name)
                    } else if code.hasPrefix("other3_") {
                        let name = code.replacingOccurrences(of: "other3_", with: "")
                        return .other3(name: name)
                    } else if code.hasPrefix("other4_") {
                        let name = code.replacingOccurrences(of: "other4_", with: "")
                        return .other4(name: name)
                    } else if code.hasPrefix("other5_") {
                        let name = code.replacingOccurrences(of: "other5_", with: "")
                        return .other5(name: name)
                    }
                }
            }
            return QXDebugSetting.settings.first?.environment ?? QXDebugSetting.Environment.test
        }
        #if DEBUG
        return debugEnvirment()
        #else
        if isForceDebugMode {
            return debugEnvirment()
        } else {
            return QXDebugSetting.Environment.release
        }
        #endif
    }
    
    public static func value(_ key: QXDebugSetting.Key) -> Any? {
        var envCode = QXDebugSetting.Environment.release.code
        #if DEBUG
        envCode = UserDefaults.standard.value(forKey: "kQXDebugEnvironmentCode") as? String ?? QXDebugSetting.settings.first?.environment.code ?? QXDebugSetting.Environment.test.code
        #endif
        if envCode == QXDebugSetting.Environment.custom.code {
            if let data = UserDefaults.standard.value(forKey: "kQXDebugEnvironmentCustomData") as? Data {
                if let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let e = dic[key.key] {
                        return e
                    }
                }
            }
        }
        for e in settings {
            if e.environment.code == envCode {
                if e.key.key == key.key {
                    return e.value
                }
            }
        }
        return nil
    }
    
    public static var settings: [QXDebugSetting] = []

    public enum Environment {

        /// 发布
        case release

        /// 自定义
        case custom

        /// 测试
        case test

        /// 验收
        case uat

        /// 单元测试
        case ut
        
        /// 集成测试
        case it

        /// 系统测试
        case st

        /// 其他1
        case other1(name: String)
        /// 其他2
        case other2(name: String)
        /// 其他3
        case other3(name: String)
        /// 其他4
        case other4(name: String)
        /// 其他5
        case other5(name: String)
        
        public static var settings: [QXDebugSetting] = []

        public var name: String {
            switch self {
            case .release:
                return "生产"
            case .custom:
                return "自定义"
            case .test:
                return "测试"
            case .uat:
                return "验收(UAT)"
            case .ut:
                return "单元测试(UT)"
            case .it:
                return "集成测试(IT)"
            case .st:
                return "系统测试(ST)"
            case .other1(name: let n):
                return n
            case .other2(name: let n):
                return n
            case .other3(name: let n):
                return n
            case .other4(name: let n):
                return n
            case .other5(name: let n):
                return n
            }
        }
        
        public var code: String {
            switch self {
            case .release:
                return "release"
            case .custom:
                return "custom"
            case .test:
                return "test"
            case .uat:
                return "uat"
            case .ut:
                return "ut"
            case .it:
                return "it"
            case .st:
                return "st"
            case .other1(name: let name):
                return "other1_" + name
            case .other2(name: let name):
                return "other2_" + name
            case .other3(name: let name):
                return "other3_" + name
            case .other4(name: let name):
                return "other4_" + name
            case .other5(name: let name):
                return "other5_" + name
            }
        }
            
    }
    
    public struct Key {
        public let name: String
        public let key: String
        public init(_ name: String, _ key: String) {
            self.name = name
            self.key = key
        }
    }
        
    public let environment: Environment
    public let key: Key
    public let value: Any
    public init(_ environment: Environment, _ key: Key, _ value: Any) {
        self.environment = environment
        self.key = key
        self.value = value
    }
}

public class QXDebugGlobalSwitch {
    
    public static var switches: [QXDebugGlobalSwitch] = []
    
    public static func value(_ key: QXDebugGlobalSwitch.Key) -> Bool {
        for e in switches {
            if e.key.key == key.key {
                return e.currentValue
            }
        }
        return QXDebugFatalError("invalid key", false)
    }

    public struct Key {
        public let name: String
        public let key: String
        public init(_ name: String, _ key: String) {
            self.name = name
            self.key = key
        }
    }
    public let key: Key
    public let value: Bool
    public var currentValue: Bool {
        #if DEBUG
        if let e = _cache_value {
            return e
        }
        let b = UserDefaults.standard.value(forKey: key.key) as? String ?? "NO" == "YES"
        _cache_value = b
        return b
        #else
        return value
        #endif
    }
    private var _cache_value: Bool?
    
    public func reset() {
        _cache_value = nil
    }
    
    public init(_ key: Key, _ value: Bool) {
        self.key = key
        self.value = value
    }
}
