//
//  TaskModel.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-24.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//
import UIKit


class TaskModel: NSObject, NSCoding {

   
    // MARK: - Properties -
    var title: String
    var dateCreated: String
    var dueDate: String
    var priority: Int
    var photo: UIImage?
    var thumbnail: UIImage?
    var imageFrameOffset: CGRect?
    var zoomLevel: CGFloat?
    var notes: String?
    var offset_X: CGFloat?
    var offset_Y: CGFloat?
    
    private let dateFormatter = DateFormatter()
    var tmpDate: Date?
    
    //MARK: - Archiving Paths -
    // lookup the curent application's documents directory and create the file URL by appending meals to the end of the documents URL.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")

    
    struct PropertyKey {
        static let title = "title"
        static let dateCreated = "dateCreated"
        static let dueDate = "dueDate"
        static let photo = "photo"
        static let thumbnail = "thumbnail"
        static let imageFrameOffset = "imageFrameOffset"
        static let zoomLevel = "zoomLevel"
        static let notes = "notes"
        static let priority = "priority"
        static let offset_X = "offset_X"
        static let offset_Y = "offset_Y"
    }
    
    //MARK: - NSCoding -
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: PropertyKey.title)
        aCoder.encode(self.dateCreated, forKey: PropertyKey.dateCreated)
        aCoder.encode(self.dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(self.photo, forKey: PropertyKey.photo)
        aCoder.encode(self.priority, forKey: PropertyKey.priority)
        aCoder.encode(self.thumbnail, forKey: PropertyKey.thumbnail)
        aCoder.encode(self.imageFrameOffset, forKey: PropertyKey.imageFrameOffset)
        aCoder.encode(self.zoomLevel, forKey: PropertyKey.zoomLevel)
        aCoder.encode(self.notes, forKey: PropertyKey.notes)
        aCoder.encode(self.offset_X, forKey: PropertyKey.offset_X)
        aCoder.encode(self.offset_Y, forKey: PropertyKey.offset_Y)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let Title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            MyLogger.logDebug("Unable to decode the title for a task object.")
            return nil
        }
        
        guard let DateCreated = aDecoder.decodeObject(forKey: PropertyKey.dateCreated) as? String else {
            MyLogger.logDebug("Unable to decode the dateCreated for a task object.")
            return nil
        }
        
        guard let DueDate = aDecoder.decodeObject(forKey: PropertyKey.dueDate) as? String else {
            MyLogger.logDebug("Unable to decode the dueDate for a task object.")
            return nil
        }
        
        guard let Priority = aDecoder.decodeObject(forKey: PropertyKey.priority) as? Int else {
            MyLogger.logDebug("Unable to decode the priority for a task object.")
            return nil
        }

        let Photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let Thumbnail = aDecoder.decodeObject(forKey: PropertyKey.thumbnail) as? UIImage
        let ImageFrameOffset = aDecoder.decodeObject(forKey: PropertyKey.imageFrameOffset) as? CGRect
        let ZoomLevel = aDecoder.decodeObject(forKey: PropertyKey.zoomLevel) as? CGFloat
        let Notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        let Offset_X = aDecoder.decodeObject(forKey: PropertyKey.offset_X) as? CGFloat
        let Offset_Y = aDecoder.decodeObject(forKey: PropertyKey.offset_Y) as? CGFloat
        
        self.init(title: Title, dateCreated: DateCreated,
                  dueDate: DueDate, priority: Priority,
                  photo: Photo,
                  thumbnail: Thumbnail,
                  imageFrameOffset: ImageFrameOffset,
                  zoomLevel: ZoomLevel,
                  offset_X: Offset_X,
                  offset_Y: Offset_Y,
                  notes: Notes)
    }
    
    
    // MARK: - Initializers -
    /**
     - parameters:
        - title: title of the task. Must not be empty.
        - dateCreated: date and time on which the task was created.
        - dueDate: date and time at which the task is due.
        - priprity: priority of the task.
        - photo: original image selected for the task.
        - thumbnail: Image after being modified by user. To display on task list.
     
     */
    init?(title: String, dateCreated: String, dueDate: String,
          priority: Int,
          photo: UIImage? = nil,
          thumbnail: UIImage? = nil,
          imageFrameOffset: CGRect? = nil,
          zoomLevel: CGFloat? = nil,
          offset_X: CGFloat? = nil,
          offset_Y: CGFloat? = nil,
          notes: String? = nil) {
    
        // Theese fields must not be empty
        guard !(title.isEmpty || dateCreated.isEmpty || dueDate.isEmpty) else {
            return nil
        }

        self.title = title
        self.dateCreated = dateCreated
        self.priority = priority
        self.dueDate = dueDate
        self.photo = photo
        if thumbnail == nil {
            self.thumbnail = photo
        } else {
            self.thumbnail = thumbnail
        }
        self.imageFrameOffset = imageFrameOffset
        self.zoomLevel = zoomLevel
        self.offset_X = offset_X
        self.offset_Y = offset_Y
        self.notes = notes
        // set date formatting
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .short
        self.dateFormatter.timeZone = TimeZone.current
        self.tmpDate = self.dateFormatter.date(from: self.dueDate)
    }
   
    func getDateFromString(_ dateString: String) -> Date {
        return self.dateFormatter.date(from: dateString)!
    }
    
    func getDateString(_ dateTime: Date) -> String {
        return self.dateFormatter.string(from: dateTime)
    }
}

