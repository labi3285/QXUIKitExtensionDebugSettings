//
//  QXDebugSettingsViewController.swift
//  Project
//
//  Created by labi3285 on 2019/12/16.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

open class QXDebugSettingsViewController: QXTableViewController<Any> {
    
    public var envirnment: QXDebugSetting.Environment!
    public var respondChange: (() -> ())?

    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderSpace = 10
        tableView.sectionFooterSpace = 10
    }
    
    override open func didSetup() {
        super.didSetup()
        var envs: [(String, QXDebugSetting)] = []
        var dic: [String: Any] = [:]
        for e in QXDebugSetting.settings {
            if envs.firstIndex(where: { $0.0 == e.key.key }) == nil {
                envs.append((e.key.key, e))
            }
            if e.environment.code == envirnment.code {
                dic[e.key.key] = e.value
            }
        }
        switch envirnment! {
        case .custom:
            title = "自定义"
            var allCells = [Any]()
            var textFiledCells: [QXSettingTextFieldCell] = []
            var customDic: [String: Any]?
            if let data = UserDefaults.standard.value(forKey: "kQXDebugEnvironmentCustomData") as? Data {
                if let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    customDic = dic
                }
            }
            for e in envs {
                let a = QXStaticTextCell()
                a.label.font = QXFont(14, QXColor.dynamicTip)
                a.label.padding = QXEdgeInsets(15, 15, 0, 15)
                a.label.text = e.1.key.name
                let b = QXSettingTextFieldCell()
                b.textField.placeHolder = "点击输入"

                if let e = customDic?[e.0] {
                    b.textField.text = "\(e)"
                } else if let e = dic[e.0] {
                    b.textField.text = "\(e)"
                } else {
                    b.textField.text = ""
                }
                allCells.append(a)
                allCells.append(b)
                textFiledCells.append(b)
            }
            
            let c = QXStaticButtonCell()
            c.button.title = "设置"
            c.button.respondClick = { [weak self] in
                UserDefaults.standard.setValue(QXDebugSetting.Environment.custom.code, forKey: "kQXDebugEnvironmentCode")
                var dic: [String: Any] = [:]
                for (i, e) in textFiledCells.enumerated() {
                   dic[envs[i].0] = e.textField.text
                }
                let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
                UserDefaults.standard.setValue(data, forKey: "kQXDebugEnvironmentCustomData")
                UserDefaults.standard.synchronize()
                
                let vc = UIAlertController(title: "提示", message: "设置成功", preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (a) in
                    self?.respondChange?()
                    self?.dismiss()
                    QXDebugSettingsButton?.title = QXDebugSetting.envirment.name
                }))
                self?.present(vc)
            }
            allCells.append(QXSpace(50))
            allCells.append(c)

            tableView.sections = [ QXTableViewSection(allCells) ]
        default:
            title = envirnment.name
            var allCells = [Any]()
            for e in envs {
                let a = QXStaticTextCell()
                a.label.font = QXFont(14, QXColor.dynamicTip)
                a.label.padding = QXEdgeInsets(15, 15, 0, 15)
                a.label.text = e.1.key.name
                let b = QXSettingTextCell()
                if let e = dic[e.0] {
                    b.label.text = "\(e)"
                } else {
                    b.label.text = "(null)"
                }
                allCells.append(a)
                allCells.append(b)
            }
            
            let c = QXStaticButtonCell()
            c.button.title = "设置"
            c.button.respondClick = { [weak self] in
                if let e = self?.envirnment {
                    UserDefaults.standard.setValue(e.code, forKey: "kQXDebugEnvironmentCode")
                    UserDefaults.standard.synchronize()
                    let vc = UIAlertController(title: "提示", message: "设置成功", preferredStyle: .alert)
                    vc.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (a) in
                        self?.respondChange?()
                        self?.dismiss()
                        QXDebugSettingsButton?.title = QXDebugSetting.envirment.name
                    }))
                    self?.present(vc)
                }
            }
            allCells.append(QXSpace(50))
            allCells.append(c)
            tableView.sections = [ QXTableViewSection(allCells) ]
        }
                
    }
    
}
