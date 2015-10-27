//
//  LoginViewController.swift
//  HotelApp
//
//  Created by Ryan Dawkins on 10/26/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginViewController : UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginClicked(sender: AnyObject) {
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        PFUser.logInWithUsernameInBackground(username!, password:password!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                print("successful login!")
                
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
                
            } else {
                
                print("failed login")
                
            }
        }
        
    }
}