//
//  TodoListTableViewController.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-26.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import UIKit

class TodoListTableViwController: UITableViewController {
   
    var todoList = [TaskModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if todoList.count > 1 {
            let sortModel = ListModel()
            let a = sortModel.getSortedTasks(self.todoList)
            self.todoList = a
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedMeals = loadTasks() {
            let sortModel = ListModel()
            let a = sortModel.getSortedTasks(savedMeals)
            tableView.reloadData()
            self.todoList += a
        } else {
            // Load the sample data.
            self.loadSampleTasks()
        }
        
    }

    private func loadSampleTasks() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        self.todoList += [TaskModel(title: "abcd", dateCreated: dateFormatter.string(from: Date()),
                                                dueDate: dateFormatter.string(from: Date()), priority: 1)!]
    }
    /// Save/Archieve the meal details added/updated by the user.
    private func saveTasks() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: false)
            try data.write(to: TaskModel.ArchiveURL)
            MyLogger.logDebug("Meals data successfully saved.")
        }   catch {
            MyLogger.logDebug("Error is saving meals data")
            fatalError("Unable to save data")
        }
    }
    
    /// Load/Unarchieve the meal details.
    private func loadTasks() -> [TaskModel]? {
        do {
            let tasksDataToRead = try NSData(contentsOf: TaskModel.ArchiveURL, options: .dataReadingMapped)
            let tasksData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(referencing: tasksDataToRead))
            MyLogger.logDebug("Meals data successfully read.")
            return tasksData as? [TaskModel]
        } catch {
            MyLogger.logDebug("Error in reading meals data")
            return nil
        }
    }

    // MARK: - Actions -
    /// It is a reverse seague handler which edits existing meal details or adds a new cell to tale view for a new meal.
    @IBAction func unwindToTaskList(_ sender: UIStoryboardSegue) {
        if let taskViewController = sender.source as? ViewController, let task = taskViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                self.todoList[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meal.i
                // this code computes the location of newer cell where new meal is to be inserted
                let newIndexPath = IndexPath(row: self.todoList.count, section: 0)
                
                self.todoList.append(task)
                // .automatic allows the system to decide which animation
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the meals.
            saveTasks()
        }
    }

    // MARK: - Table view data source -
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Table view cells are reused and should be dequeued using a cell identifier.
        // #warning Incomplete implementation, return the number of rows
        return self.todoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "taskTableCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TodoListTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // set the meal content on the cell
        let task = self.todoList[indexPath.row]
        cell.taskTitle.text = task.title
       
        if task.dueDate != "Unspecified" && task.dueDate != "Immediate" {
            let dateFmt = DateFormatter()
            dateFmt.dateStyle = .medium
            dateFmt.timeStyle = .short
            let dateTime = dateFmt.date(from: task.dueDate)
            let calendar = Calendar.current
            let date = String(calendar.component(.day, from: dateTime!)) +
                "-" + String(calendar.component(.month, from: dateTime!)) +
                "-" + String(calendar.component(.year, from: dateTime!))
            
            cell.taskDueDate.text = date
            
            let hour = calendar.component(.hour, from: dateTime!)
            let am_pm = (hour > 11) ? " PM" : " AM"
            let time = String(hour % 12) + ":" + String(calendar.component(.minute, from: dateTime!)) + am_pm
            cell.timeLabel.text = time
        } else {
            cell.taskDueDate.text = task.dueDate
            cell.timeLabel.text = task.dueDate
        }
        cell.priorityIndicator.backgroundColor = self.setPriorityIndicatorColor(priority: task.priority)
        if task.thumbnail != nil {
            cell.taskThumbnail.image = task.thumbnail
        }
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete from the meals array
            self.todoList.remove(at: indexPath.row)
            // Save the meals.
            saveTasks()
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    // MARK: - Navigation -
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            MyLogger.logDebug("Add info of a new task")
        case "ShowDetails":
            // check the segue's destination
            guard let TaskDetailViewController = segue.destination as? ViewController else {
                fatalError("unexpected destination: \(segue.destination)")
            }
            // cast sender of segue to TodoListTableViewCell and if sender has error rise exception
            guard let selectedTaskCell = sender as? TodoListTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            // get the tabliewss indexPath to the user selected cell
            guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            // choose the meal from tab-index selected by user
            let selectedTask = self.todoList[indexPath.row]
            // set the selected meal into the meal Detail view
            TaskDetailViewController.task = selectedTask
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }

       
    }
    private func setPriorityIndicatorColor(priority: Int) -> UIColor {
        var color: UIColor
        switch (priority) {
        case 0:
            color = UIColor.green
        case 1:
            color = UIColor.orange
        case 2:
            color = UIColor.red
        default:
            color = UIColor.black
            
        }
        return color
    }
    
}
