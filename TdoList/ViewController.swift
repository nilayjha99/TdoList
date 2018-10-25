//
//  ViewController.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-20.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var taskPhoto: UIImageView!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var dueDateField: UITextField!
    private var datePicker : UIDatePicker?
    private var picker: UIPickerView?
    private var selectedPrioriy: String = "low"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPriorityPicker()
        self.initDatePicker()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let dest = segue.identifier ?? ""
        if dest == "recentreImage" {
        let abc = segue.destination as? RecentreController
            abc?.imageToRecentre = taskPhoto.image
        }
        
    }
    
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
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

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
    
 
    // code for priority picker
    private func initPriorityPicker() {
        // code for toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // add done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(priorityPickerDoneTapped))
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
        view.endEditing(true)
    }
    
    let priorities = ["low", "medium", "high"]
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
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
