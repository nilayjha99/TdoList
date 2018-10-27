//
//  MyLogger.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-26.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import os.log

public class MyLogger {
    // to put a log at debug level
    public static func logDebug(_ message: StaticString) -> Void {
        os_log(message, log: OSLog.default, type: .debug)
    }
}
