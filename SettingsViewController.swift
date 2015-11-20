//
//  SettingsViewController.swift
//  
//
//  Created by Jeff Shepherd on 11/20/15.
//
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    let userName = PFUser.currentUser()?.username

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //after a link is made to the storyboard, this can be altered to work with it.
        let currentUserLabel = "Current User: \(userName)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //once logoff button is created on the storyboard, this code can go inside.
    func LogOffButton(){
        
        //logout of parse
        PFUser.logOut()

        //Return to the root view. Login view should load automatically.
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
