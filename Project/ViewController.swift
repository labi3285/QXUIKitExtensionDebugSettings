//
//  ViewController.swift
//  Project
//
//  Created by labi3285 on 2019/11/1.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

let key_api1 = QXDebugSetting.Key("api地址1", "api1")
let key_api2 = QXDebugSetting.Key("api地址2", "api2")
let key_api3 = QXDebugSetting.Key("api地址3", "api3")

/// 在所有方法之前配置
func SetupApis() {
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

class ViewController: UIViewController {
    
    lazy var label: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 0
        e.fixWidth = 300
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "Home"
        view.addSubview(label)
        label.IN(view).CENTER.MAKE()
        
        var t = ""
        t += baseApi1
        t += "\n"
        t += baseApi2
        t += "\n"
        t += baseApi3
        t += "\n"
        
        label.text = t
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(baseApi1)
        print(baseApi2)
        print(baseApi3)

    }
    
}


