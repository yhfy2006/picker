//
//  TraceEvent.swift
//  TracePilot
//
//  Created by VincentHe on 3/2/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import Foundation
import RealmSwift
class TraceEvent: Object {
    dynamic var id = 0
    dynamic var title = ""
    dynamic var selfDecsription = ""
    dynamic var createdTimeStampe = NSDate()
    dynamic var duration:Double = 0.0
    dynamic var distance:Double = 0.0
    
    let traceLocations = List<TraceLocation>()
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(TraceEvent).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }

}


class TraceLocation:Object{
    dynamic var id = 0
    dynamic var eventId = 0
    dynamic var locationTimeStamp:NSDate = NSDate()
    dynamic var locationLatitude:Double = 0.0
    dynamic var locationLongitude:Double = 0.0
    dynamic var locationSpeed:Double = 0.0
    dynamic var locationHeading:Double = 0.0
    dynamic var locationAltitude:Double = 0.0
}