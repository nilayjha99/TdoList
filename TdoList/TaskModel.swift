//
//  TaskModel.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-24.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//
import UIKit

class TaskModel {
   
    var title: String
    var dateCreated: String?
    var dueDate: String?
    var priority: String?
    var photo: UIImage?
    var thumbnail: UIImage?
    var imageFrameOffset: CGPoint?
    var notes: String?
    
    init(title: String, dateCreated: String?, dueDate: String?,
         priority: String?,photo: UIImage?, thumbnail: UIImage?,
         imageFrameOffset: CGPoint?, notes: String?) {
        self.title = title
        self.dateCreated = dateCreated
        self.dueDate = dueDate
        self.photo = photo
        self.thumbnail = thumbnail
        self.imageFrameOffset = imageFrameOffset
        self.notes = notes
    }
    
    init(title: String) {
        self.title = title
    }
    
    func getDateFromString(_ dateString: String) {
        
    }
    
}
