//
//  DayViewViewController.swift
//  HotelApp
//

import Foundation
import UIKit
import Parse

class DayViewViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var taskTableView: UITableView!
    
    var taskList: [Task] = [Task]()
    var selectedDept: String?
    var selectedDate: NSDate?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //self.taskTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "dayTaskCell")
    }
    
    override func viewWillAppear(animated: Bool){
        LoadTasks()
        self.taskTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("dayTaskCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = taskList[indexPath.row].name
        
        if let dept = selectedDept {
            cell.detailTextLabel?.text = dept
        } else {
            do {
                try taskList[indexPath.row].department.pin()
            } catch _{
                
            }
            cell.detailTextLabel?.text = taskList[indexPath.row].department.name
        }
        

        if taskList[indexPath.row].completed == true{
            cell.imageView?.image = UIImage(named: "check")
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.detailTextLabel?.textColor = UIColor.grayColor()
        }else{
            cell.imageView?.image = UIImage(named: "uncheck")
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        //change completed status when cell is selected
        if taskList[indexPath.row].completed == true{
            taskList[indexPath.row].completed = false
        }else{
            taskList[indexPath.row].completed = true
        }

        //Save the change to Parse
        taskList[indexPath.row].saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if(success){
                self.LoadTasks()
                self.taskTableView.reloadData()
            }else{
                print(error)
                
                //Print alert
                let alert = UIAlertController(title: "Error saving changes. Check your internet connection.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            print("delete cell")
            
            //Delete task at cell
            taskList[indexPath.row].deleteInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if(success) {
                    self.LoadTasks()
                    self.taskTableView.reloadData()
                }else{
                    print(error)
                    
                    //Print alert
                    let alert = UIAlertController(title: "Error saving changes. Check your internet connection.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //Loads and refreshes the view
    func LoadTasks(){
        
        //Set beginning and end time of day for the selected date
        let calendar = NSCalendar.currentCalendar()
        var startOfDay: NSDate?
        var endOfDay: NSDate?
        
        if let date = selectedDate {
            let unitFlags: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .Month, .Year]
            let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
            
            components.hour = 0
            components.minute = 0
            components.second = 0
            
            startOfDay = calendar.dateFromComponents(components)!
            
            components.hour = 23
            components.minute = 59
            components.second = 59
            
            endOfDay = calendar.dateFromComponents(components)!
        }
        
        if let innerQuery = Department.query() {
            if let query = Task.query() {
                
                //if deparment has been selected, filter to it
                if let dept = selectedDept {
                    innerQuery.whereKey("name", equalTo: dept)
                    query.whereKey("department", matchesQuery: innerQuery)
                }
                
                //If date has been set, filter to it
                if let date = selectedDate {
                    if let startOfDay = startOfDay {
                        query.whereKey("dueDate", greaterThanOrEqualTo: startOfDay)
                    }
                    if let endOfDay = endOfDay {
                        query.whereKey("dueDate", lessThanOrEqualTo: endOfDay)
                    }
                }

                query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if let objects = objects as? [Task] {
                            self.taskList = objects
                            self.taskTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}