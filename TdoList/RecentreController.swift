//
//  RecentreController.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-24.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import UIKit

class RecentreController: UIViewController, UIScrollViewDelegate {
    /// variable to hold image
    public var imageToRecentre: UIImage!
    var imageView = UIImageView()
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var saveImagePositionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageScrollView.delegate = self
        self.loadImageToScroll()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadImageToScroll() {
        
        guard self.imageToRecentre != nil else {
            fatalError("qqqqqqq")
        }
        
        self.imageView.image = self.imageToRecentre
        self.imageView.contentMode = .center
        
        self.imageView.frame = CGRect(x: 0, y: 0,
                                      width: self.imageToRecentre.size.width,
                                      height: self.imageToRecentre.size.height)
        
    
        self.imageView.isUserInteractionEnabled = true
        self.imageScrollView.contentSize = self.imageToRecentre.size
        
        let scrollViewFrame = self.imageScrollView.frame
        let scaledWidth = scrollViewFrame.size.width / self.imageScrollView.contentSize.width
        let scaledHeight = scrollViewFrame.size.width / self.imageScrollView.contentSize.width
        let minScale = min(scaledHeight, scaledWidth)
        
        self.imageScrollView.minimumZoomScale = minScale
        self.imageScrollView.maximumZoomScale = 1
        self.imageScrollView.zoomScale = minScale
        
        self.imageScrollView.addSubview(self.imageView)
    }
    
    func centreScrollViewContents() {
        let boundSize = self.imageScrollView.bounds.size
        var contentsFrame = self.imageView.frame
        
        if contentsFrame.size.width < boundSize.width {
            contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2
        } else {
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundSize.height {
            contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2
        } else {
            contentsFrame.origin.y = 0
        }
        
        self.imageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centreScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
