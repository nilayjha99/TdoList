//
//  ListModel.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-26.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import Foundation

public class ListModel {
    var taskList = [TaskModel]()
    
    // sort by date descending
    func sortByDate() {
        self.taskList.sort(by: { $0.tmpDate?.compare($1.tmpDate!) == .orderedDescending })
    }
   
    // sort by priority ascending
    func sortByPriority() {
         self.taskList.sort(by: { $0.priority < $1.priority})
    }
}
