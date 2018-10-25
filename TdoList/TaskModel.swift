//
//  TaskModel.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-24.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//
import UIKit

public enum dueDateEnum {
    case unspecified(String?)
    case specified(Date)
    case immedeate(String)
}

class TaskModel {
   
    var title: String?
    var dateCreated: Date?
    var dueDate: dueDateEnum?
    var photo: UIImage?
    var originalPhoto: UIImage?
    var notes: String?
    
    init(title: String, dateCreated: Date, dueDate: dueDateEnum, photo: UIImage, notes: String) {
        self.title = title
        self.dateCreated = dateCreated
        self.dueDate = dueDate
        self.photo = photo
        self.notes = notes
    }
}
