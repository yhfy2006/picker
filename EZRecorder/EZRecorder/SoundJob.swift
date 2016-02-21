//
//  SoundJob.swift
//  EZRecorder
//
//  Created by VincentHe on 2/20/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import Foundation
import RealmSwift

class SoundJob: Object {

    dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
    dynamic var title = ""
    dynamic var createdDate = NSDate()

    let sounds = List<Sound>()
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(SoundJob).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }

}