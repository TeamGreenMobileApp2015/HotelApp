//
//  IconViewController.swift
//  HotelApp
//
//  Created by Nathaniel Hoover on 10/27/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import UIKit
import SwiftMoment
import CVCalendar
import Parse


class CalendarViewController: UIViewController {

    var shouldShowDaysOut = false
    var animationFinished = true
    
    var selectedDay:DayView!
    
    var departments = [Department]()
    
    
    // Set up date object
    let date = NSDate()
    
    let calendar = NSCalendar.currentCalendar()

    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getDepartments()
        
    }

    func getDepartments() {
        Department.query()!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            self.departments = objects as! [Department]
            print("got departments")
            
            self.loadDateBoxesByDepartment()
        }
    }
    
    func loadDateBoxesByDepartment() {
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date)
        
        let currentMonth = components.month
        
        // Getting the First and Last date of the month
        components.day = 1
        components.year = 2015
        let firstDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        print(firstDateOfMonth)
        
        components.month  += 1
        
        let lastDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        components.month = currentMonth
        components.day = 1
        
        // Loop through the entire month
        var indexedDay = calendar.dateFromComponents(components)!
        while indexedDay.compare(lastDateOfMonth) == NSComparisonResult.OrderedAscending {
            
            print(calendar.dateFromComponents(components)!)
            
            
            
            components.day += 1
            indexedDay = calendar.dateFromComponents(components)!
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
}

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        selectedDay = dayView
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.day
        let randomDay = Int(arc4random_uniform(31))
        if day == randomDay {
            return true
        }
        
        return true
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = Int(arc4random_uniform(3) + 1)
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
}

extension CalendarViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        print(components.month)
        components.month += offset
        print(components.month)
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
}