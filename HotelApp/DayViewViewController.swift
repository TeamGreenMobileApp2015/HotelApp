//
//  DayViewViewController.swift
//  HotelApp
//
//  Created by Ryan Dawkins on 10/28/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import Foundation
import UIKit
import Parse

class DayViewViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var taskTableView: UITableView!
    
    var taskList: [Task] = [Task]()
    var selectedDept: String?
    var selectedDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.taskTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "dayTaskCell")
        //LoadTasks()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //load or refresh the view
        LoadTasks()
        self.taskTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayTaskCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = taskList[indexPath.row].name
        
        //I'm not sure how to pull the name of the department from the task.
        let dept = taskList[indexPath.row].department
        cell.detailTextLabel?.text = "Department" //dept.name

        if taskList[indexPath.row].completed == true {
            cell.imageView?.image = UIImage(named: "check")
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.detailTextLabel?.textColor = UIColor.grayColor()
        } else {
            cell.imageView?.image = UIImage(named: "uncheck")
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //change completed status when cell is selected
        if taskList[indexPath.row].completed == true {
            taskList[indexPath.row].completed = false
        } else {
            taskList[indexPath.row].completed = true
        }

        //Save the change to Parse
        taskList[indexPath.row].saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if(success) {
                self.LoadTasks()
                self.taskTableView.reloadData()
            } else {
                print(error)
                
                //Print alert
                let alert = UIAlertController(title: "Error saving changes. Check your internet connection.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        let now = NSDate()
        let dueDate = taskList[indexPath.row].dueDate

        print("Now: \(now)")
        print("dueDate: \(dueDate)")
        
        if now == dueDate {
            print("Equal")
        } else {
            print("")
        }
        print(now.compare(dueDate))
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            print("delete cell")
            
            //Delete task at cell
            taskList[indexPath.row].deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if(success) {
                    self.LoadTasks()
                    self.taskTableView.reloadData()
                } else {
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
    
    func LoadTasks(){
        if let innerQuery = Department.query() {
            if let query = Task.query() {
                
                //if deparment has been selected, filter to it
                if let dept = selectedDept {
                    innerQuery.whereKey("name", equalTo: dept)
                    query.whereKey("department", matchesQuery: innerQuery)
                }
                /*
                //The Task subclass dueDate doesn't seem to be matching up. It may have to do with it having the time as well as date.
                if let date = selectedDate {
                    query.whereKey("dueDate", equalTo: date)
                }
                */
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