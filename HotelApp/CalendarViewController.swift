//
//  IconViewController.swift
//  HotelApp
//
//  Created by Nathaniel Hoover on 10/27/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import UIKit
import CalendarView

class CalendarViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    var calendar: CalendarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCalenderView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCalenderView(){
        calendar = CalendarView(frame: CGRectMake(0, 0, CGRectGetWidth(view.frame), 320))
        view.addSubview(calendar!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
