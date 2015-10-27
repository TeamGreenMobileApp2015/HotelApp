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

    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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


}

