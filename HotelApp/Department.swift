//
//  Department.swift
//  HotelApp
//
//  Created by Ryan Dawkins on 10/28/15.
//  Copyright © 2015 Ryan Dawkins. All rights reserved.
//

import Foundation
import Parse

class Department : PFObject, PFSubclassing {
    
    
    override class func initialize() {
        
        // No idea what this crap does. It was in the docs...
        // https://parse.com/docs/ios/guide#objects-subclassing-pfobject
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Department"
    }
    
    // Name of the Department
    @NSManaged var name : String
    
    @NSManaged var red : Int
    
    @NSManaged var green : Int
    
    @NSManaged var blue : Int
    
}