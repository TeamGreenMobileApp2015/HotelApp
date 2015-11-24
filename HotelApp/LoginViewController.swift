//
//  LoginViewController.swift
//  HotelApp
//

import Foundation
import UIKit
import Parse

class LoginViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var keyboardIsShown : Bool = false;
    
    let user = PFUser.currentUser()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        
        //Observers for showing and hiding the keyboard that calls keyboardWillShow or keyvoardWillHide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        //Creates a swipe gesture recogniser for the down swipe gesture
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    //When login is click it will get the fields and check the login data
    //If the login data matches a record then it will segue to the menu
    @IBAction func onLoginClicked(sender: AnyObject){
        
        var username = self.usernameField.text
        let password = self.passwordField.text
        
        if let name = username {
            username = name.lowercaseString
        }
        
        PFUser.logInWithUsernameInBackground(username!, password:password!){
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil{
                print("successful login!")
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
            }else{
                print("failed login")
            }
        }
    }
    
    //Lowers the keyboard when return is clicked
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }
    
    //Raises the view if the keyboard is not already being shown
    func keyboardWillShow(sender: NSNotification){
        if(!keyboardIsShown){
            self.view.frame.origin.y -= 150
        }
        keyboardIsShown = true;
    }
    
    //Lowers the view if the keyboard is show
    func keyboardWillHide(sender: NSNotification){
        if(keyboardIsShown){
            self.view.frame.origin.y += 150
        }
        keyboardIsShown = false;
    }
    
    //Lowers the keyboard on swipe down
    func dismissKeyboard(){
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
}