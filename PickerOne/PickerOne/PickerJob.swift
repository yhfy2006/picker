//
//  PickerJob.swift
//  PickerOne
//
//  Created by VincentHe on 2/4/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import Foundation
import RealmSwift

class PickerJob: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
    dynamic var title = ""
    dynamic var createdDate = NSDate()
    dynamic var jobDescription = ""

    let jobDetails = List<JobDetails>()
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(PickerJob).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}

class JobDetails:Object{
    dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
    dynamic var text = ""
    dynamic var imageData:NSData?

    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(JobDetails).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}