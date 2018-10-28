//
//  ViewController.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-20.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import UIKit

class TaskImageInfo {
    var photo: UIImage
    var thumbnail: UIImage
    var imageFrameOffset: CGRect?
    var zoomLevel: CGFloat?
    var offset_X: CGFloat?
    var offset_Y: CGFloat?
    
    init(photo: UIImage, thumbnail: UIImage) {
        self.photo = photo
        self.thumbnail = thumbnail
    }
    
    func updateThumbnail(thumbnail: UIImage, frameOffset: CGRect, zoomLevel: CGFloat) {
        self.thumbnail = thumbnail
        self.imageFrameOffset = frameOffset
        self.zoomLevel = zoomLevel
    }
}

class ViewController: UIViewController {

    // MARK: - Widget Outlets -
    @IBOutlet weak var priorityIndicator: UIButton!
    @IBOutlet weak var taskPhoto: UIImageView!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var dueDateField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var recentreButton: UIButton!
  
    
    // MARK: - Private Properties -
    private var datePicker : UIDatePicker?
    private var picker: UIPickerView?
    private var selectedPrioriy: String = "low"
    
    // MARK: - Properties -
    let priorities = ["low", "medium", "high"]
    var task: TaskModel?
    var taskImage: TaskImageInfo?

    // MARK: - Lifecycle Hooks -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPriorityPicker()
        self.initDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.populateTaskValues()
    }
    
    func populateTaskValues() {
        
        guard self.task != nil else {
            if self.taskImage == nil {
            self.recentreButton.isEnabled = false
            } else {
                self.taskPhoto.image = self.taskImage?.thumbnail
            }
            self.notesField.text = ""
            self.priorityField.text = self.priorities[0]
            self.setPriorityIndicatorColor()
            return
        }
        
        self.titleField.text = self.task?.title
        self.dueDateField.text = self.task?.dueDate
        self.priorityField.text = self.priorities[((self.task?.priority)!)]
        self.setPriorityIndicatorColor()
        
        if self.task?.photo != nil {
            self.setTaskThumbnail()
        } else {
            self.recentreButton.isEnabled = false
        }
        
        if self.task?.notes != nil {
            self.notesField.text = self.task?.notes
        } else {
            self.notesField.text = ""
        }
    }
    
    func setTaskThumbnail() {
        self.taskPhoto.image = self.task?.thumbnail
        self.taskImage = TaskImageInfo(photo: (self.task?.photo)!, thumbnail: (self.task?.thumbnail)!)
    }
    
    // MARK: - Seague Handlers -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let dest = segue.identifier ?? ""
        if dest == "recentreImage" {
            guard let abc = segue.destination as? RecentreController else {
               fatalError("wtf")
            }
//            abc.imageToRecentre = taskPhoto.image
            abc.taskImage = taskImage
        }
        
    }

}

// MARK: - DatePicker Section -
extension ViewController {
    // code for date picker
    private func initDatePicker() {
        // code for toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // add done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dueDateDoneTapped))
        
        // add Immediate button
        let immediatButton = UIBarButtonItem(title: "Immediate", style: .done, target: nil, action: #selector(dueDateImmediateTapped))
        
        // add unspecify Button
        let unspecifyButton = UIBarButtonItem(title: "Unspecified", style: .done, target: nil, action: #selector(dueDateUnspecifyTapped))
        
        toolbar.setItems([doneButton, immediatButton, unspecifyButton], animated: true)
        
        //add toolbar to date picker
        self.dueDateField.inputAccessoryView = toolbar
        
        // code to handle the duedate date input
        self.datePicker =  UIDatePicker()
        self.datePicker?.datePickerMode = .dateAndTime
        
        // set datepicker as input control
        self.dueDateField.inputView = self.datePicker
    }
    
    @objc private func dueDateDoneTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        self.dueDateField.text = dateFormatter.string(from: (self.datePicker?.date)!)
        view.endEditing(true)
    }
    
    @objc private func dueDateImmediateTapped() {
        self.dueDateField.text = "Immediate"
        view.endEditing(true)
    }
    
    @objc private func dueDateUnspecifyTapped() {
        self.dueDateField.text = "Unspecified"
        view.endEditing(true)
    }
    
    
}

// MARK: - PriorityPicker Section -
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // code for priority picker
    private func initPriorityPicker() {
        // code for toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // add done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(priorityPickerDoneTapped))
        toolbar.setItems([doneButton], animated: true)
        
        
        // code to handle priority input
        self.picker = UIPickerView()
        self.picker?.delegate = self
        self.picker?.dataSource = self
        self.priorityField.inputView = self.picker
        self.priorityField.inputAccessoryView = toolbar
    }
    
    @objc private func priorityPickerDoneTapped() {
        self.priorityField.text = self.selectedPrioriy
        self.setPriorityIndicatorColor()
        view.endEditing(true)
    }
    
    // code for custom picker to take input the priority
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.priorities.count
    }
    
    // returns the selected input and sets it into the textfield
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPrioriy =  self.priorities[row]
    }
    
    // set the appereance of the "lables" on the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.priorities[row]
    }
    
    private func setPriorityIndicatorColor() {
        var color: UIColor
        switch (self.priorityField.text) {
        case self.priorities[0]:
            color = UIColor.green
        case self.priorities[1]:
            color = UIColor.orange
        case self.priorities[2]:
            color = UIColor.red
        default:
            color = UIColor.black
            print("nothing")
        }
        self.priorityIndicator.backgroundColor = color
    }
}

// MARK: - ImagePicker Section -
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // code for image selection
    @IBAction func choosePhoto(_ sender: UITapGestureRecognizer) {
        
        // image controller
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        // build action sheet
        let imageActionSheet = UIAlertController(title: "Photo Source", message: "choose a source.", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("no camera")
            }
        })
        
        imageActionSheet.addAction(cameraAction)
        
        let galleryAction = UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        })
        
        imageActionSheet.addAction(galleryAction)
        
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        imageActionSheet.addAction(cancelActon)
        
        present(imageActionSheet, animated: true)
    }
    
    
    //MARK: - UIImagePickerControllerDelegate -
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // if cancel is pressed from image picker
        // then return to current view closing photo library
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate -
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        // if user selects an image process the input
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        // Set photoImageView to display the selected image.
        self.taskPhoto.image = selectedImage
        self.taskImage = TaskImageInfo(photo: self.taskPhoto.image!, thumbnail: self.taskPhoto.image!)
        self.taskImage?.zoomLevel = nil
        self.taskImage?.imageFrameOffset = nil
        self.recentreButton.isEnabled = true
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Helper Functions -
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
