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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPriorityPicker()
        self.initDatePicker()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func initPriorityPicker() {
        // code to handle priority input
        self.picker = UIPickerView()
        self.picker?.delegate = self
        self.picker?.dataSource = self
        self.priorityField.inputView = self.picker
    }
    
    private func initDatePicker() {
        // code to handle the duedate date input
        self.datePicker =  UIDatePicker()
        self.datePicker?.datePickerMode = .dateAndTime
        self.datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        self.dueDateField.inputView = self.datePicker
    }
    
    @objc private func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        self.dueDateField.text = dateFormatter.string(from: (self.datePicker?.date)!)
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
        self.priorityField.text =  self.priorities[row]
        view.endEditing(true)
    }
    
    // set the appereance of the "lables" on the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.priorities[row]
    }
    
    
}

