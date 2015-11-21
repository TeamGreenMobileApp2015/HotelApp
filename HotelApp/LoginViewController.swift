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

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var keyboardIsShown : Bool = false;
    
    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        var swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if(!keyboardIsShown){
            self.view.frame.origin.y -= 150
        }
        keyboardIsShown = true;
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
        keyboardIsShown = false;
    }
    
    func dismissKeyboard() {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
}