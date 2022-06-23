//
//  QXDebugLogDetailViewController.swift
//  Project
//
//  Created by labi3285 on 2022/6/23.
//  Copyright © 2022 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

open class QXDebugLogDetailViewController: QXTableViewController<Any> {
    
    open var log: QXDebugLog!
    
    lazy var titleCell: QXStaticTextCell = {
        let e = QXStaticTextCell()
        e.label.font = QXFont(14, QXColor.dynamicTitle, bold: true)
        return e
    }()
    
    lazy var lineCell: QXStaticCell = {
        let e = QXStaticCell()
        let line = QXLineView()
        line.lineColor = QXColor.dynamicLine
        e.contentView.addSubview(line)
        line.IN(e).LEFT(15).RIGHT(15).CENTER.MAKE()
        e.fixHeight = 1
        return e
    }()
    
    lazy var textCell: QXStaticTextCell = {
        let e = QXStaticTextCell()
        e.label.font = QXFont(14, QXColor.dynamicText)
        e.label.isCopyEnabled = true
        return e
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "详情"
        contentView.models = [
            titleCell,
            lineCell,
            textCell
        ]
    }
    open override func didSetup() {
        super.didSetup()
        titleCell.label.text = QXDate.Formats.standard24.string(log.time)
        switch log.level  {
        case .info:
            textCell.label.font = QXFont(14, QXColor.dynamicText)
        case .warning:
            textCell.label.font = QXFont(14, QXColor.orange)
        case .error:
            textCell.label.font = QXFont(14, QXColor.red)
        }
        textCell.label.text = log.text
    }
    
}
