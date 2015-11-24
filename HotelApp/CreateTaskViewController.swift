//
//  CreateTaskViewController.swift
//  HotelApp
//

import Foundation
import UIKit
import Parse

class CreateTaskViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var deptPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //set initial values from DayViewViewController
    var initialDate: NSDate?
    var initialDept: String?
    
    var deptSelection: Department?
    var deptObjects: [Department] = [Department]()

    //parse object subclasses
    var newTask = Task()
    var newDept = Department()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //prevent tasks due dates from being set before today
        datePicker.minimumDate = NSDate()
        if let date = initialDate {
            datePicker.setDate(date, animated: false)
        }
        
        //load the department names into the picker view
        loadDept()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
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
    @IBAction func CreateTaskButton(sender: AnyObject){
        var inputCheck = true
        
        //set task name
        if let taskName = taskNameTextField.text{
            if taskName != ""{
                newTask.name = taskName
                print("taskName: \(taskName)")
            }else{
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
            newTask.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if(success){
                    print("Saving task")
                    
                    //display "Task saved" notification and return to previous view controller
                    let alert = UIAlertController(title: "Task added", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        alert.dismissViewControllerAnimated(false, completion: nil)
                        self.performSegueWithIdentifier("unwindWithNewtask", sender: self)
                    })
                    
                }else{
                    print("Error Saving \(error)")
                }
            }
        }
    }
    
    func loadDept(){
        //load the departments into the picker view
        if let query = Department.query(){
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects as? [Department]{
                        
                        self.deptObjects = objects
                        
                        //if department was selected from main menu, start deptPicker there. Else, set initial value to first item
                        if let _ = self.initialDept {
                            for index in 0..<objects.count {
                                if objects[index].name == self.initialDept {
                                    self.deptPicker.selectRow(index, inComponent: 0, animated: false)
                                }
                            }
                            //set the initialDept to nil so it doesn't keep changing.
                            self.initialDept = nil
                        } else {
                            //set to first value
                            self.deptSelection = self.deptObjects[0]
                        }
                        
                        //reload the deptPicker
                        self.deptPicker.reloadAllComponents()
                    }
                }
            }
        }
    }
}