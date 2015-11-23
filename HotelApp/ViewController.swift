//
//  ViewController.swift
//  HotelApp
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var tasks = []
    var user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = PFUser.currentUser()
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
            switch(segue.identifier!){
                case "Dining":
                    destination.title = "Dining"
                case "Rooms":
                    destination.title = "Rooms"
                case "Lobby":
                    destination.title = "Lobby"
                case "HouseKeeping":
                    destination.title = "HouseKeeping"
                case "Maintenance":
                    destination.title = "Maintenance"
                case "AddDepartment":
                    destination.title = "AddDepartment"
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
