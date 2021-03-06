//
//  ViewController.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-20.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    // MARK: - Widget Outlets -
    @IBOutlet weak var priorityIndicator: UIButton!
    @IBOutlet weak var taskPhoto: UIImageView!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var dueDateField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var recentreButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    // MARK: - Private Properties -
    private var datePicker : UIDatePicker?
    private var picker: UIPickerView?
    private var selectedPrioriy: String = "low"
    
    // MARK: - Properties -
    let priorities = ["low", "medium", "high"]
    var task: TaskModel?
    var taskImage: TaskImageInfo?
    var taskCreationDate: String?
    
    // MARK: - Lifecycle Hooks -
    override func viewDidLoad() {
        self.titleField.delegate = self
        self.saveButton.isEnabled = false
        self.initPriorityPicker()
        self.initDatePicker()
        if self.task == nil {
            let button1 = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonClicked))
            self.navigationItem.leftBarButtonItem  = button1
        }
        super.viewDidLoad()
        
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
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
            self.updateSaveButtonState()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            self.taskCreationDate = dateFormatter.string(from: Date())
            self.dateCreatedLabel.text = self.dateCreatedLabel.text! + " " + taskCreationDate!
            return
        }
        
        self.titleField.text = self.task?.title
        self.dueDateField.text = self.task?.dueDate
        self.priorityField.text = self.priorities[((self.task?.priority)!)]
        self.setPriorityIndicatorColor()
        self.dateCreatedLabel.text = self.dateCreatedLabel.text! + " " + (self.task?.dateCreated)!
        
        
        if self.task?.photo != nil && self.taskImage == nil {
            self.taskPhoto.image = self.task?.thumbnail
            self.taskImage = TaskImageInfo(photo: (self.task?.photo)!, thumbnail: (self.task?.thumbnail)!)
            self.taskImage?.imageFrameOffset = self.task?.imageFrameOffset
            self.taskImage?.zoomLevel = self.task?.zoomLevel
            self.taskImage?.offset_X = self.task?.offset_X
            self.taskImage?.offset_Y = self.task?.offset_Y
        } else if self.taskImage?.thumbnail != nil {
            self.taskPhoto.image = self.taskImage?.thumbnail
            self.task?.thumbnail = self.taskPhoto.image
            self.task?.imageFrameOffset = self.taskImage?.imageFrameOffset
            self.task?.zoomLevel = self.taskImage?.zoomLevel
            self.task?.offset_X = self.taskImage?.offset_X
            self.task?.offset_Y = self.taskImage?.offset_Y
            self.recentreButton.isEnabled = true
        } else {
            self.recentreButton.isEnabled = false
        }
        
        if self.task?.notes != nil {
            self.notesField.text = self.task?.notes
        } else {
            self.notesField.text = ""
        }
        self.updateSaveButtonState()
    }
    
    // MARK: - Private Methods -
    /// Update the state of "save" button based on meal name textfield's value.
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = self.titleField.text ?? nil 
        self.saveButton.isEnabled = !text!.isEmpty
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
        
        guard let button = sender as? UIBarButtonItem, button === self.saveButton else {
            MyLogger.logDebug("save meal button is not pressed")
            return
        }

        var createdDate: String
        if self.task != nil {
            createdDate = (self.task?.dateCreated)!
        } else {
            createdDate = self.taskCreationDate!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        self.task = TaskModel(title: self.titleField.text!,
                              dateCreated: createdDate,
                              dueDate: self.dueDateField.text!,
                              priority: self.priorities.firstIndex(of: self.priorityField.text!)!,
                              photo: self.taskImage?.photo,
                              thumbnail: self.taskImage?.thumbnail,
                              imageFrameOffset: self.taskImage?.imageFrameOffset,
                              zoomLevel: self.taskImage?.zoomLevel,
                              offset_X: self.taskImage?.offset_X,
                              offset_Y: self.taskImage?.offset_Y,
                              notes: self.notesField.text ?? nil)
        
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
                MyLogger.logDebug("no camera found")
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

extension ViewController: UITextFieldDelegate {
    //MARK: - UITextFieldDelegate -
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true;
    }
    
    //MARK: - UITextFieldDelegate -
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateSaveButtonState()
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
