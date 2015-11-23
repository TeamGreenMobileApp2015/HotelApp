//
//  ViewController.swift
//  HotelApp
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var tasks = []
    var user = PFUser.currentUser()
    var departments = [String: Department]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = PFUser.currentUser()
        
        do {
            let objects = try Department.query()?.findObjects()
            let depts = objects as! [Department]
            for d in depts {
                self.departments[d.name] = d
            }
        } catch _ {
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //Tests if the user is logged in if not it will segue to the LoinViewController
        if user == nil {
            print("not logged in")
            self.performSegueWithIdentifier("loginSegue", sender: self)
            print("should have performed segueu")
        } else {
            print("is logged in apparently")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Detectes which segue was triggered(Which icon was pressed)
    //Sets data members of the destination CalenderViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender:AnyObject?) {
        if let destination = segue.destinationViewController as? CalendarViewController{

            print(segue.identifier)
            
            destination.department = self.departments[segue.identifier!]
            
            switch(segue.identifier!){
                case "Dining":
                    destination.title = "Dining"
                case "Rooms":
                    destination.title = "Rooms"
                case "Lobby":
                    destination.title = "Lobby"
                case "Housekeeping":
                    destination.title = "Housekeeping"
                case "Maintenance":
                    destination.title = "Maintenance"
                case "Overview":
                    destination.title = "Overview"
                case "logout":
                    PFUser.logOut()
                default:
                    break
            }
        }
        else if let _ = segue.destinationViewController as? LoginViewController{
            PFUser.logOut()
            user = nil
            print("I should be logged out now")
        }
    }
}
