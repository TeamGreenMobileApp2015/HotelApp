//
//  Department.swift
//  HotelApp
//

import Foundation
import Parse

class Department : PFObject, PFSubclassing{
    
    //Name of the Department 
    @NSManaged var name : String
    @NSManaged var red : Int
    @NSManaged var green : Int
    @NSManaged var blue : Int
    
    override class func initialize(){
        //Requred from the parse documentation
        //https://parse.com/docs/ios/guide#objects-subclassing-pfobject
        struct Static{
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken){
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String{
        return "Department"
    }
}