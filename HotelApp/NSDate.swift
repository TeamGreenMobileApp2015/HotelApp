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
        return cal.dateByAddingUnit(.Month, value: -1, toDate: self, options: [])!
    }
    
    func nextMonth() -> NSDate {
        let cal = NSCalendar.currentCalendar()
        return cal.dateByAddingUnit(.Month, value: 1, toDate: self, options: [])!
    }
}