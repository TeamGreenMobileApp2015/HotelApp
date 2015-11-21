//
//  CreateTaskViewController.swift
//  HotelApp
//
//  Created by Ryan Dawkins on 10/28/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import Foundation
import UIKit
import Parse

class CreateTaskViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var deptPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var deptSelection: Department?
    var deptObjects: [Department] = [Department]()

    
    //parse object subclasses
    var newTask = Task()
    var newDept = Department()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prevent tasks due dates from being set before today
        datePicker.minimumDate = NSDate()
        
        //load the department names into the picker view
        loadDept()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deptObjects.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return deptObjects[row].name
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deptSelection = deptObjects[row]
    }
    
    
    // MARK: Buttons
    @IBAction func CreateTaskButton(sender: AnyObject) {
        var inputCheck = true
        
        //set task name
        if let taskName = taskNameTextField.text {
            if taskName != "" {
                newTask.name = taskName
                print("taskName: \(taskName)")
            } else {
                //if task name is empty...
                
                let alert = UIAlertController(title: "You must add a task name.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                presentViewController(alert, animated: true, completion: nil)
                
                //dismiss alert by timer
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                
                inputCheck = false
                print("taskName missing. Data will not be saved.")
            }
        }
        
        //set task department
        if let deptSelection = deptSelection {
            newTask.department = deptSelection
            print("department: \(newTask.department.name)")
        } else {
            print("Error - No Dept Selected")
            inputCheck = false
        }

        //Set task due date
        newTask.dueDate = datePicker.date
        print("dueDate: \(datePicker.date)")
        
        //Set task as incomplete
        newTask.completed = false
        
        //if all data for the task has been set...
        if inputCheck {
            
            //save the new task to the cloud
            newTask.saveEventually()
            print("Saving task")
            
            //display "Task saved" notification and return to previous view controller
            let alert = UIAlertController(title: "Task added", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            presentViewController(alert, animated: true, completion: nil)
            
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                
                alert.dismissViewControllerAnimated(false, completion: nil)
                
                if let navController = self.navigationController {
                    navController.popViewControllerAnimated(true)
                }
            })
        }
    }
    
    // MARK: Other functions
    
    func loadDept(){
        
        //load the department names into the picker view
        if let query = Department.query(){
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects as? [Department]{
                        self.deptObjects = objects
                        
                        //reload the deptPicker
                        self.deptPicker.reloadAllComponents()
                        
                        //set first as initial selection
                        self.deptSelection = self.deptObjects[0]
                        
                    }
                }
            }
        }
    }
}