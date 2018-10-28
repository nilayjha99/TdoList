//
//  TaskImageInfo.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-27.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import UIKit

class TaskImageInfo {
    var photo: UIImage
    var thumbnail: UIImage?
    var imageFrameOffset: CGRect?
    var zoomLevel: CGFloat?
    var offset_X: CGFloat?
    var offset_Y: CGFloat?
    
    init(photo: UIImage, thumbnail: UIImage?) {
        self.photo = photo
        if thumbnail == nil {
            self.thumbnail = photo
        } else {
            self.thumbnail = thumbnail
        }
    }
    
    func updateThumbnail(thumbnail: UIImage, frameOffset: CGRect, zoomLevel: CGFloat, offset_X: CGFloat, offset_Y: CGFloat) {
        self.thumbnail = thumbnail
        self.imageFrameOffset = frameOffset
        self.zoomLevel = zoomLevel
        self.offset_X = offset_X
        self.offset_Y = offset_Y
    }
}
