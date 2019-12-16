//
//  QXDebugEnvironmentButton.swift
//  Project
//
//  Created by labi3285 on 2019/12/16.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

public func QXDebugEnvironmentsButton(_ window: UIWindow) {
    #if DEBUG
    let btn = QXTitleButton()
    btn.font = QXFont(14, QXColor.green)
    btn.padding = QXEdgeInsets(5, 5, 5, 5)
    btn.title = QXDebugSetting.envirment.name
    btn.respondClick = { [weak window] in
        let vc = QXDebugEnvironmentsViewController()
        let nav = QXNavigationController(rootViewController: vc)
        window?.qxTopVc?.present(nav, animated: true, completion: nil)
    }
    window.addSubview(btn)
    if QXDevice.isLiuHaiScreen {
        btn.IN(window).RIGHT(15).BOTTOM(49 + 30 + 15).MAKE()
    } else {
        btn.IN(window).RIGHT(15).BOTTOM(49 + 15).MAKE()
    }
    #endif
}
    