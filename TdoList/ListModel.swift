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
    var immediateTasks = [TaskModel]()
    var unspecifiedTasks = [TaskModel]()
    
    // sort by date descending
    func sortByDate(tasks: [TaskModel]) -> [TaskModel] {
        var tasksToSort = tasks
        tasksToSort.sort(by: { $0.tmpDate?.compare($1.tmpDate!) == .orderedAscending })
        return tasksToSort
    }
   
    // sort by priority ascending
    func sortByPriority(tasks: [TaskModel], order: String = "asc") -> [TaskModel] {
          var tasksToSort = tasks
        if order == "asc" {
         tasksToSort.sort(by: { $0.priority < $1.priority})
        } else {
         tasksToSort.sort(by: { $0.priority > $1.priority})
        }
        return tasksToSort
    }
    
    func segregateTasks(_ tasks: [TaskModel]) {
        for task in tasks {
            if task.dueDate == "Immediate" {
                self.immediateTasks.append(task)
            } else if task.dueDate == "Unspecified" {
                self.unspecifiedTasks.append(task)
            } else {
                self.taskList.append(task)
            }
        }
    }
    
    func sortImmediateTasks() {
        self.immediateTasks = self.sortByPriority(tasks: self.immediateTasks, order: "desc")
    }
    
    func sortUnspecifiedTasks() {
        self.unspecifiedTasks = self.sortByPriority(tasks: self.unspecifiedTasks, order: "desc")
    }
    
    func sortNormalTasks() {
        self.taskList = self.sortByPriority(tasks: self.taskList, order: "desc")
        self.taskList = self.sortByDate(tasks: self.taskList)
    }
    
    func getSortedTasks(_ tasks: [TaskModel]) -> [TaskModel] {
        self.segregateTasks(tasks)
        self.sortImmediateTasks()
        self.sortUnspecifiedTasks()
        self.sortNormalTasks()
        var sortedTasks = self.immediateTasks + self.taskList + self.unspecifiedTasks
        return sortedTasks
    }
}
