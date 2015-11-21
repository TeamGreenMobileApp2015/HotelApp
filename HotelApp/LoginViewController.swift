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
        
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        
        //Observer for showing the keyboard that calls keyboardWillShow method
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        //Observer for hiding the keyboard that calls keyboardWillHide method
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        //Swipe Gesture Recogniser that calls dismissKeyboard
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        //Sets the swipe gesture to down
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        //Adds the recogniser to the view
        self.view.addGestureRecognizer(swipe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    //Lowers the keyboard when return is clicked
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Raises the view if the keyboard is not already being shown
    func keyboardWillShow(sender: NSNotification) {
        if(!keyboardIsShown){
            self.view.frame.origin.y -= 150
        }
        keyboardIsShown = true;
    }
    
    //Lowers the view if the keyboard is show
    func keyboardWillHide(sender: NSNotification) {
        if(keyboardIsShown){
            self.view.frame.origin.y += 150

        }
        keyboardIsShown = false;
    }
    
    //Lowers the keyboard on swipe down
    func dismissKeyboard() {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
}