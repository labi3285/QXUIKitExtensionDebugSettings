//
//  QXDebugSettingsTodosViewController.swift
//  Project
//
//  Created by labi3285 on 2019/12/16.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

open class QXDebugSettingsTodosViewController: QXTableViewController<Any> {
    
    public var respondChange: (() -> ())?
    
    public lazy var logItem: QXBarButtonItem = {
        let e = QXBarButtonItem.titleItem("日志") { [weak self] in
            let vc = QXDebugLogsViewController()
            self?.push(vc)
        }
        return e
    }()
    
    public lazy var environmentItem: QXBarButtonItem = {
        let e = QXBarButtonItem.titleItem("变量") { [weak self] in
            let vc = QXDebugEnvironmentsViewController()
            vc.respondChange = self?.respondChange
            self?.push(vc)
        }
        return e
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "调试"
        
        navigationBarRightItems = [ environmentItem, logItem ]
        
        tableView.sectionHeaderSpace = 10
        tableView.sectionFooterSpace = 10
        
        var cells: [QXSettingCell] = []
        for e in QXDebugTodo.todos {
            let c = QXDebugTodoCell()
            c.titleLabel.text = e.name
            c.backButton.respondClick = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    e.todo()
                })
            }
            cells.append(c)
        }
        tableView.sections = [ QXTableViewSection(cells) ]
        tableView.qxReloadData()
    }
        
}

open class QXDebugTodoCell: QXSettingCell {
    
    open override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            backButton.isEnabled = isEnabled
        }
    }

    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(16, QXColor.dynamicTitle)
        e.compressResistanceX = 1
        return e
    }()
    public final lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.views = [self.titleLabel, QXFlexSpace()]
        return e
    }()
        
    public required init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 50
        backButton.isDisplay = true
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
