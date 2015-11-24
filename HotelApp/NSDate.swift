//
//  NSDate.swift
//  HotelApp
//
//  Created by Ryan Dawkins on 11/23/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import Foundation

extension NSDate {
    
    func previousMonth() -> NSDate {
        
        let cal = NSCalendar.currentCalendar()
        let components = self.getComponentsOfDate()
        components.month = components.month - 1
        components.day = 1
        
        return cal.dateFromComponents(components)!
    }
    
    func nextMonth() -> NSDate {
 //       let cal = NSCalendar.currentCalendar()
//        return cal.dateByAddingUnit(.Month, value: 1, toDate: self, options: [])!
        let cal = NSCalendar.currentCalendar()
        let components = self.getComponentsOfDate()
        components.month = components.month + 1
        components.day = 1
        
        return cal.dateFromComponents(components)!
    }
    
    func getComponentsOfDate() -> NSDateComponents {
        
        let cal = NSCalendar.currentCalendar()
        
        let yearComponents = cal.components(NSCalendarUnit.Year, fromDate: self)
        let monthComponents = cal.components(NSCalendarUnit.Month, fromDate: self)
        let dayComponents = cal.components(NSCalendarUnit.Day, fromDate: self)
        
        yearComponents.month = monthComponents.month
        yearComponents.day = dayComponents.day
        
        return yearComponents
    }
    
}