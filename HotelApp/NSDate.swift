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
        
        let calendar = NSCalendar.currentCalendar()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: self)
        components.month = components.month - 1
        
        return calendar.dateFromComponents(components)!
    }
    
    func nextMonth() -> NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: self)
        components.month = components.month + 1
        
        return calendar.dateFromComponents(components)!
    }
    
}