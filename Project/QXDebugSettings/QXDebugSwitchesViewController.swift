//
//  QXDebugSettingsViewController.swift
//  Project
//
//  Created by labi3285 on 2019/12/16.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

open class QXDebugSwitchesViewController: QXTableViewController<Any> {
    
    public var respondChange: (() -> ())?

    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "开关"
        tableView.sectionHeaderSpace = 10
        tableView.sectionFooterSpace = 10
    }
    
    override open func didSetup() {
        super.didSetup()
        var allCells = [Any]()
        for e in QXDebugSwitch.switches {
            let c = QXSettingTitleSwitchCell()
            c.titleLabel.text = e.key.name
            c.switchView.isOn = e.currentValue
            c.switchView.respondChange = { [weak self] isOn in
                self?.handleChange(e, isOn: isOn)
            }
            allCells.append(c)
        }
        tableView.sections = [ QXTableViewSection(allCells) ]
    }
    
    open func handleChange(_ e: QXDebugSwitch, isOn: Bool) {
        UserDefaults.standard.setValue(isOn ? "YES" : "NO", forKey: e.key.key)
        UserDefaults.standard.synchronize()
        e.reset()
    }
    
}
