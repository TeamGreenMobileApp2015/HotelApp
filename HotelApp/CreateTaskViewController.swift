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
    
    var pickerData: [String] = [String]()
    
    var deptSelection: String?
    
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
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deptSelection = pickerData[row]
    }
    
    func loadDept(){
        
        //load the department names into the picker view
        if let query = Department.query(){
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects as? [Department]{
                        for dept in objects {
                            if dept.name != "" {
                                self.pickerData.append(dept.name)
                            }
                            
                            //reload the deptPicker
                            self.deptPicker.reloadAllComponents()
                            
                            //set first as initial selection
                            self.deptSelection = self.pickerData[0]
                        }
                    }
                }
            }
        }
    }
    
    func tempAlert(alertMessage: String, sec: Double){
        let alert = UIAlertController(title: alertMessage, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        presentViewController(alert, animated: true, completion: nil)
        
        //dismiss alert by timer
        let delay = sec * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            
            alert.dismissViewControllerAnimated(false, completion: nil)
        })

    }
    
    
    @IBAction func CreateTaskButton(sender: AnyObject) {
        var inputComplete = true
        
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
                
                inputComplete = false
                print("taskName missing. Data will not be saved.")
            }
        }
        
        //set task department
        if let deptSelection = deptSelection {
            newTask.department.name = deptSelection
            print("department: \(deptSelection)")
        }
        
        //Set task due date
        newTask.dueDate = datePicker.date
        print("dueDate: \(datePicker.date)")
        
        //Set task as incomplete
        newTask.completed = false
        
        //if all data for the task has been set...
        if inputComplete {
            
            //save the new task to the cloud
            newTask.saveEventually()
            print("Saving task")
            
            //display save notification and return to previous view controller
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
    
    //    func printAllTasks(){
    //        if let query = Task.query(){
    //            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
    //                if error == nil {
    //                    if let objects = objects as? [Task]{
    //                        for dept in objects {
    //                            print(dept)
    //                            print("--------------")
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
}