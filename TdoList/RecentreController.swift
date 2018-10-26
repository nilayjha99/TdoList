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
    public var screenshot: UIImage!
    var imageView = UIImageView()
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var saveImagePositionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recntre Image"
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
        print("-------------")
        print(contentsFrame)
        print(self.imageScrollView.zoomScale)
        self.imageView.frame = contentsFrame
    }
    
    @IBAction func avf(_ sender: Any) {
        //saveAndCropImage()
        aev()
    }
  
    func aev() {
        let offset = self.imageScrollView.contentOffset
        print(offset)
        print(self.imageScrollView.contentScaleFactor)
        setOffsets()
    }
    
    func setOffsets() {
        self.imageScrollView.setZoomScale(0.20668766012642115, animated: true)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: 620.0629803792633, height: 413.78869557309474)
//        let a = CGPoint(x: -220.0, y: -174.0)
//        self.imageScrollView.setContentOffset(a, animated: true)
    }
    
    func saveAndCropImage() {
        UIGraphicsBeginImageContextWithOptions(self.imageScrollView.bounds.size, true, UIScreen.main.scale)
        let offset = self.imageScrollView.contentOffset
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("ss")
        }
        context.translateBy(x: -offset.x, y: -offset.y)
        self.imageScrollView.layer.render(in: context)
        self.screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.previewImage.image = screenshot
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centreScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
