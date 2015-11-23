//
//  IconViewController.swift
//  HotelApp
//

import UIKit
import SwiftMoment
import CVCalendar
import Parse

class CalendarViewController: UIViewController{

    var shouldShowDaysOut = false
    var animationFinished = true
    
    var finished = 0
    var selectedDay:DayView!
    var departments = [Department]()
    var department : Department? = nil
    
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    var dateDepartments = [Int: DepartmentDate]()
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getDepartments()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getDepartments(){
        Department.query()!.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            self.departments = objects as! [Department]
            self.loadDateBoxesByDepartment()
        }
    }
    
    func loadDateBoxesByDepartment(){
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date)
        
        let currentMonth = components.month
        
        // Getting the First and Last date of the month
        components.day = 1
        components.year = 2015
        let firstDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        components.month  += 1
        
        let lastDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        components.month = currentMonth
        components.timeZone = NSTimeZone(name: "UTC")
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        // Loop through the entire month
        var indexedDay = calendar.dateFromComponents(components)!
        
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        var endOfIndexedDay = calendar.dateFromComponents(components)!
        
        while indexedDay.compare(lastDateOfMonth) == NSComparisonResult.OrderedAscending{
            self.finished++
            
            self.getTasksForDay(components.day, startDate: indexedDay, endDate: endOfIndexedDay)
            
            components.day += 1
            components.hour = 0
            components.minute = 0
            components.second = 0
            
            indexedDay = calendar.dateFromComponents(components)!
            
            components.hour = 23
            components.minute = 59
            components.second = 59
            
            endOfIndexedDay = calendar.dateFromComponents(components)!
        }
    }
    
    func getTasksForDay(day: Int, startDate: NSDate, endDate: NSDate){
        let query = Task.query()?.whereKey("dueDate", greaterThanOrEqualTo: startDate).whereKey("dueDate", lessThanOrEqualTo: endDate)
        
        if self.department != nil{
            query?.whereKey("department", equalTo: self.department!)
        }
        
        query!.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error != nil{
                print("has error")
                print(error?.description)
                return
            }
            
            let tasks = objects as! [Task]
            
            if tasks.count == 0{
                self.decrementFinished()
                
                return
            }else{
            }
            
            var departmentDate = DepartmentDate()
            if (self.dateDepartments[day] != nil){
                departmentDate = self.dateDepartments[day]!
            }
            
            var changedDepartmentDate = false
            
            for task in tasks{
                do{
                    try task.department.pin()
                }catch _{
                    
                }
                
                let department = task.department
                
                if (task.department.name == "Rooms" && !departmentDate.rooms){
                    departmentDate.rooms = true
                    
                    changedDepartmentDate = true
                    
                    let color = UIColor(red: CGFloat(department.red), green: CGFloat(department.green), blue: CGFloat(department.blue), alpha: CGFloat(1))
                    departmentDate.colors.append(color)
                }
                else if (task.department.name == "Maintenance" && !departmentDate.maintenance){
                    departmentDate.maintenance = true
                    
                    changedDepartmentDate = true
                    
                    let color = UIColor(red: CGFloat(department.red), green: CGFloat(department.green), blue: CGFloat(department.blue), alpha: CGFloat(1))
                    departmentDate.colors.append(color)
                }
                else if (task.department.name == "Lobby" && !departmentDate.lobby){
                    departmentDate.lobby = true
                    
                    changedDepartmentDate = true
                    
                    let color = UIColor(red: CGFloat(department.red), green: CGFloat(department.green), blue: CGFloat(department.blue), alpha: CGFloat(1))
                    departmentDate.colors.append(color)
                }
                else if (task.department.name == "Housekeeping" && !departmentDate.housekeeping){
                    departmentDate.housekeeping = true
                    
                    changedDepartmentDate = true
                    
                    let color = UIColor(red: CGFloat(department.red), green: CGFloat(department.green), blue: CGFloat(department.blue), alpha: CGFloat(1))
                    departmentDate.colors.append(color)
                }
                else if (task.department.name == "Dining" && !departmentDate.dining){
                    departmentDate.dining = true
                    
                    changedDepartmentDate = true
                    
                    let color = UIColor(red: CGFloat(department.red), green: CGFloat(department.green), blue: CGFloat(department.blue), alpha: CGFloat(1))
                    departmentDate.colors.append(color)
                }
            }
            
            if changedDepartmentDate{
                self.dateDepartments[day] = departmentDate
            }
            self.decrementFinished()
        })
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    func decrementFinished(){
        self.finished--
        
        if self.finished == 0{
            self.calendarView.commitCalendarViewUpdate()
            self.calendarView.reloadInputViews()
            self.menuView.commitMenuViewUpdate()
            self.calendarView.setNeedsDisplay()
            self.calendarView.contentController.refreshPresentedMonth()
        }
    }
}

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate{
    /// Required method to implement!
    func presentationMode() -> CalendarMode{
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday{
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool{
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool{
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool){
        print("\(dayView.date.commonDescription) is selected!")
        selectedDay = dayView
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool{
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool{
        let day = dayView.date.day
        
        let hasDay : Bool = self.dateDepartments[day] != nil

        if hasDay{
        }
        
        return hasDay
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor]{
        
        let dateDepartment = self.dateDepartments[dayView.date.day]
    
        if dateDepartment != nil {
            return (dateDepartment?.colors)!
        }else{
            return [UIColor]()
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool{
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat{
        return 13
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType{
        return .Short
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView{
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool{
//        if (dayView.isCurrentDay) {
//            return true
//        }
//        return false
        let day = dayView.date.day
        
        let hasDay : Bool = self.dateDepartments[day] != nil
        
        
        if hasDay{
        }
        
        return hasDay
    }
}

extension CalendarViewController{
    func toggleMonthViewWithMonthOffset(offset: Int){
        let calendar = NSCalendar.currentCalendar()
        //let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate){
        //let calendar = NSCalendar.currentCalendar()
        //let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate){
        //let calendar = NSCalendar.currentCalendar()
        //let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
}

extension CVCalendarContentViewController{
    public func refreshPresentedMonth(){
        for weekV in presentedMonthView.weekViews{
            for dayView in weekV.dayViews{
                dayView.preliminarySetup()
                dayView.supplementarySetup()
                dayView.dotMarkers.removeAll()
                dayView.reloadContent()
                dayView.setupDotMarker()
            }
        }
    }
}