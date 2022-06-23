//
//  QXDebugLog.swift
//  Project
//
//  Created by labi3285 on 2022/6/22.
//  Copyright © 2022 labi3285_lab. All rights reserved.
//

import QXUIKitExtension

public enum QXDebugLogLevel: Int {
    case info = 0
    case warning = 1
    case error = 2
}

public struct QXDebugLog {

    public let id: String
    public let time: QXDate
    public let level: QXDebugLogLevel
    public let text: String
    
    public init(_ dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        if let e = dic["time"] as? String, let t = TimeInterval(e) {
            self.time = QXDate(Date(timeIntervalSince1970: t))
        } else {
            self.time = QXDate.init(.init(timeIntervalSince1970: 0))
        }
        self.level = QXDebugLogLevel(rawValue: dic["level"] as? Int ?? 0) ?? .info
        self.text = dic["text"] as? String ?? ""
    }
    
    public init(_ level: QXDebugLogLevel, _ text: String) {
        let time = QXDate.now
        self.id = QXDebugLog._generate_uuid(time: time)
        self.time = time
        self.level = level
        self.text = text
    }
    
}

extension QXDebugLog {
        
    public static func log(_ level: QXDebugLogLevel, _ text: String) {
        if QXDevice.isAppRelease {
            return
        }
        _setup_todo { r in
            switch r {
            case .succeed(_):
                let e = QXDebugLog(level, text)
                _save_log(log: e)
            case .failed(let err):
                QXDebugPrint(err)
            }
        }
    }
    
    public static func getPageOfLogs(page: Int, size: Int, done: @escaping (QXRequest.Respond<[QXDebugLog]>) -> Void) {
        if QXDevice.isAppRelease {
            done(.failed(.init(-1, "生产环境")))
            return
        }
        _setup_todo { r in
            switch r {
            case .succeed(_):
                self._queue.async {
                    do {
                        var sql = ""
                        sql = "SELECT * FROM 't_qx_debug_log' "
                        sql += "ORDER BY time DESC "
                        sql += "LIMIT \(size) OFFSET \(page * size) "
                        sql += ";"
                        var es: [QXDebugLog] = []
                        for dic in try _db.query(sql) {
                            let e = QXDebugLog(dic)
                            es.append(e)
                        }
                        DispatchQueue.main.async {
                            done(.succeed(es))
                        }
                    } catch {
                        QXDebugPrint("QXDebugLog init failed: \(error)")
                        DispatchQueue.main.async {
                            done(.failed(error.qxError))
                        }
                    }
                }
            case .failed(let err):
                QXDebugPrint(err)
                done(.failed(err))
            }
        }
    }
    private static func _save_log(log: QXDebugLog) {
        if !_is_setup {
            QXDebugPrint("QXDebugLog init failed.")
            return
        }
        _queue.async {
            do {
                var sql = ""
                sql = "INSERT INTO 't_qx_debug_log' (id, time, level, text) VALUES ( "
                sql += "'\(log.id)', "
                sql += "'\(log.time.nsDate.timeIntervalSince1970)', "
                sql += "'\(log.level.rawValue)', "
                sql += "'\(log.text)' "
                sql += ");"
                try _db.execute(sql)
            } catch {
                QXDebugPrint("QXDebugLog init failed: \(error)")
            }
        }
    }
    private static func _setup_todo(done: @escaping (QXRequest.Respond<String>) -> Void) {
        if _is_setup {
            done(.succeed("ok"))
            return
        }
        _queue = DispatchQueue(label: "com.qx.qxdebug.log")
        _queue.async {
            let path = QXPath.cache /+ "QXDebugLog.db"
            do {
                try _db.openDB(path)
                var sql = ""
                sql = "CREATE TABLE IF NOT EXISTS 't_qx_debug_log' ("
                sql += "'id' TEXT NOT NULL PRIMARY KEY, "
                sql += "'level' TEXT, "
                sql += "'time' TEXT, "
                sql += "'text' TEXT "
                sql += ");"
                try _db.execute(sql)
                _is_setup = true
                DispatchQueue.main.async {
                    done(.succeed("ok"))
                }
            } catch {
                QXDebugPrint("QXDebugLog init failed: \(error)")
                DispatchQueue.main.async {
                    done(.failed(error.qxError))
                }
            }
        }
    }
    private static func _generate_uuid(time: QXDate) -> String {
        _uuid_counter += 1
        return "\(time.nsDate.timeIntervalSince1970).\(_uuid_counter)"
    }
    private static var _queue: DispatchQueue!
    private static var _is_setup = false
    private static let _db = QXSQLite()
    private static var _uuid_counter: Int = -1
    
}


