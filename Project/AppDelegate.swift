//
//  AppDelegate.swift
//  Project
//
//  Created by labi3285 on 2019/11/1.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SetupApis()

        let w = UIWindow()
        w.rootViewController = ViewController()
        w.makeKeyAndVisible()
        window = w
        

        QXDebugEnvironmentsButton(w)
        
        return true
    }

}

