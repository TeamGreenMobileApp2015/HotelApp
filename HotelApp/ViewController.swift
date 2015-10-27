//
//  ViewController.swift
//  HotelApp
//
//  Created by Ryan Dawkins on 10/26/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.user = PFUser.currentUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dinningClicked(sender: AnyObject) {
    }

    @IBAction func roomsClicked(sender: AnyObject) {
    }
    
    @IBAction func lobbyClicked(sender: AnyObject) {
    }
    
    @IBAction func housekeepingClicked(sender: AnyObject) {
    }
    
    @IBAction func maintenanceClicked(sender: AnyObject) {
    }
    
    @IBAction func addDepartmentClicked(sender: AnyObject) {
    }
    
}

