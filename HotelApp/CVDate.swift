//
//  CVDate.swift
//  HotelApp
//
//  Created by Ryan Dawkins on 11/23/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import Foundation
import CVCalendar

extension CVDate {
    
    func toNSDate() -> NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = date.getComponentsOfDate()
        components.day = (self.day)
        components.month = (self.month)
        components.year = (self.year)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.dateFromComponents(components)!
    }
    
    func previousMonth() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = date.getComponentsOfDate()
        components.day = (self.day)
        components.month = (self.month)-1
        components.year = (self.year)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.dateFromComponents(components)!
    }
    
    func nextMonth() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = date.getComponentsOfDate()
        components.day = (self.day)
        components.month = (self.month)+1
        components.year = (self.year)
        components.hour = 0
        components.minute = 0
        components.second = 0
    
        return calendar.dateFromComponents(components)!
    }
    
}