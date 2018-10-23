//
//  ViewController.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-20.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

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

