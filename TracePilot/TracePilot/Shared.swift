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
    
    static func timeString(seconds:NSTimeInterval)->String
    {
        var elapsedTime: NSTimeInterval = seconds
        //calculate the minutes in elapsed time.
        let hours = UInt8(elapsedTime / 3600)
        elapsedTime -= (NSTimeInterval(hours) * 3600)
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let scend = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", scend)
        
        return "\(strHours):\(strMinutes):\(strSeconds)"
    }

}