//
//  Shared.swift
//  TracePilot
//
//  Created by VincentHe on 3/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import HealthKit


struct GlobalVariables{

    static var appThemeColorColor = UIColor(rgba: "#00A9AE")
    
}


class Util:NSObject{

    static func getAudioDirectory()->String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        let audioPath = documentsDirectory
        return audioPath
    }
    
    static func mps2kph(speed:Double)->Double
    {
        return speed*3.6
    }
    
    static func mps2Knot(speed:Double)->Double
    {
        return speed * 1.94384
    }
    
    static func distanceInMiles(value:Double)->Double
    {
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: value)
        return distanceQuantity.doubleValueForUnit(HKUnit.mileUnit())
    }

}