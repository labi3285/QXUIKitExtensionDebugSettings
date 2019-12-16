//
//  QXSettingsViewController.swift
//  Project
//
//  Created by labi3285 on 2019/12/16.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

open class QXDebugEnvironmentsViewController: QXTableViewController<Any> {
    
    public var respondChanged: (() -> ())?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "调试设置"
        
        tableView.sectionHeaderSpace = 10
        tableView.sectionFooterSpace = 10
        
        let currentEnvironment = UserDefaults.standard.value(forKey: "kQXDebugEnvironmentCode") as? String ?? QXDebugSetting.Environment.test.code
        
        var envs: [(String, QXDebugSetting.Environment)] = []
        for e in QXDebugSetting.settings {
            if envs.firstIndex(where: { $0.0 == e.environment.code }) == nil {
                envs.append((e.environment.code, e.environment))
            }
        }
        
        var cells: [QXSettingCell] = []
        cells = []
        for e in envs {
            switch e.1 {
            case .custom:
                let c = QXSettingTitleArrowCell()
                c.titleLabel.text = e.1.name
                c.backButton.respondClick = { [weak self] in
                    let vc = QXDebugSettingsViewController()
                    vc.respondChanged = { [weak self] in
                        self?.respondChanged?()
                    }
                    self?.push(vc)
                }
                cells.append(c)
            default:
                let c = QXSettingTitleSelectCell()
                c.titleLabel.text = e.1.name
                c.isSelected = e.0 == currentEnvironment
                c.backButton.respondClick = { [weak self, weak c] in
                    if let ws = self, let c = c {
                        for _c in cells {
                            if _c === c {
                                _c.isSelected = true
                            } else {
                                _c.isSelected = false
                            }
                        }
                        UserDefaults.standard.setValue(e.0, forKey: "kQXDebugEnvironmentCode")
                        UserDefaults.standard.synchronize()
                        self?.respondChanged?()
                        
                        let vc = UIAlertController(title: "提示", message: "设置成功，请重启app。", preferredStyle: .alert)
                        vc.addAction(UIAlertAction(title: "关闭app", style: .destructive, handler: { (a) in
                            exit(0)
                        }))
                        ws.present(vc)
                    }
                }
                cells.append(c)
            }
        }
        tableView.sections = [ QXTableViewSection(cells) ]
        tableView.qxReloadData()
    }
        
}
