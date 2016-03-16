//
//  AirPort.swift
//  TracePilot
//
//  Created by VincentHe on 3/15/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import Foundation
import RealmSwift

class AirPort: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var city = ""
    dynamic var country = ""
    dynamic var threeLetterCode = ""
    dynamic var fourLetterCode = ""
    dynamic var latitude:Double = 0.0
    dynamic var longtitude:Double = 0.0
    dynamic var timezone:Int = 0
    dynamic var altitude:Double = 0.0 // in feet
    dynamic var dst = ""
    dynamic var tzTimezone = ""
}
