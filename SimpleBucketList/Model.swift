//
//  Model.swift
//  SimpleBucketList
//
//  Created by Jay Ravaliya on 12/28/15.
//  Copyright © 2015 JRav. All rights reserved.
//

import UIKit

final class Model {
    
    var data : [String]!
    var status : [Bool]!
    
    init() {
        if(NSUserDefaults.standardUserDefaults().objectForKey("data") != nil) {
            data = NSUserDefaults.standardUserDefaults().objectForKey("data") as! [String]
        }
        else {
            data = []
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("status") != nil) {
            status = NSUserDefaults.standardUserDefaults().objectForKey("status") as! [Bool]
        }
        else {
            status = []
        }
        
    }
    
    func getData() -> [String] {
        return self.data
    }
    
    func getStatus() -> [Bool] {
        return self.status
    }
    
    func addData(task : String) {
        data.append(task)
        status.append(false)
        self.synchronize()
    }
    
    func deleteData(index : Int) {
        data.removeAtIndex(index)
        status.removeAtIndex(index)
        self.synchronize()
    }
    
    func editData(index : Int, new : String) {
        data[index] = new
        self.synchronize()
    }
    
    func editStatus(index : Int, isArchived : Bool) {
        status[index] = isArchived
        self.synchronize()
    }
    
    func synchronize() {
        NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "data")
        NSUserDefaults.standardUserDefaults().setObject(self.status, forKey: "status")
    }
    
}

class Archived {
    
    var data : [String]!
    
    init() {
        if(NSUserDefaults.standardUserDefaults().objectForKey("archived") != nil) {
            data = NSUserDefaults.standardUserDefaults().objectForKey("archived") as! [String]!
        }
        else {
            data = []
        }
    }
    
    func getData() -> [String] {
        return data
    }
    
    func addData(new : String) {
        self.data.append(new)
        NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "archived")
    }
    
    func deleteAll() {
        self.data = []
        NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "archived")
    }
    
    func synchronize() {
        NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "archived")
    }
    
}
