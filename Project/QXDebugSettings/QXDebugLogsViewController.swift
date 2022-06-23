//
//  QXDebugLogsViewController.swift
//  Project
//
//  Created by labi3285 on 2022/6/22.
//  Copyright © 2022 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

open class QXDebugLogsViewController: QXTableViewController<QXDebugLog> {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "DEBUG日志"
        contentView.canRefresh = true
        contentView.canPage = true
        contentView.filter.size = 20
        tableView.adapter = QXTableViewAdapter([
            QXDebugLog.self >> QXDebugLogCell.self
        ])
        contentView.reloadData()
    }
    
    open override func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<QXDebugLog>) -> Void) {
        QXDebugLog.getPageOfLogs(page: filter.page, size: filter.size) { r in
            switch r {
            case .succeed(let ms):
                done(.succeed(ms, ms.count == filter.size))
            case .failed(let err):
                done(.failed(err))
            }
        }
    }
    
    open override func tableViewDidSelectCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection) {
        if let m = model as? QXDebugLog {
            let vc = QXDebugLogDetailViewController()
            vc.log = m
            push(vc)
        }
    }
    
    
}

open class QXDebugLogCell: QXTableViewCell {
    
    open override var model: Any? {
        didSet {
            if let m = model as? QXDebugLog {
                timeLabel.text = QXDate.Formats.standard24.string(m.time)
                switch m.level {
                case .info:
                    contentLabel.font = QXFont(12, QXColor.dynamicTitle)
                case .warning:
                    contentLabel.font = QXFont(12, QXColor.orange)
                case .error:
                    contentLabel.font = QXFont(12, QXColor.red)
                }
                contentLabel.text = m.text
            }
        }
    }
    
    open override class func height(_ model: Any?, _ context: QXTableViewCell.Context) -> CGFloat? {
        return 35
    }
    
    lazy var timeLabel: QXLabel = {
        let e = QXLabel()
        e.font = QXFont(12, QXColor.dynamicTip, bold: true)
        e.uiLabel.numberOfLines = 2
        e.uiLabel.adjustsFontSizeToFitWidth = true
        e.alignmentX = .center
        return e
    }()
    lazy var contentLabel: QXLabel = {
        let e = QXLabel()
        e.uiLabel.numberOfLines = 2
        return e
    }()
    
    public required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        timeLabel.IN(contentView).LEFT(15).WIDTH(60).TOP(3).BOTTOM(3).MAKE()
        contentLabel.IN(contentView).LEFT(90).RIGHT(15).TOP(3).BOTTOM(3).MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
