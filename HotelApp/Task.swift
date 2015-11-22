//
//  Task.swift
//  HotelApp
//

import Foundation
import Parse

class Task : PFObject, PFSubclassing{

    //Variables for the name of the tasks, Task due date, its department, and if its completed
    @NSManaged var name : String
    @NSManaged var dueDate : NSDate
    @NSManaged var department : Department
    @NSManaged var completed : Bool

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
        return "Task"
    }
}