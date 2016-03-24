//
//  Shared.swift
//  TracePilot
//
//  Created by VincentHe on 3/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import HealthKit
import Observable
import CoreMotion
import RealmSwift
import CSwiftV


enum ResultDisplayCellType {
    case metaData
    case speedChart
    case altitudeChart
}


struct GlobalVariables{

    static var appThemeColorColor = UIColor(rgba: "#00A9AE")
    
}

struct AppObservables {
    var wakeUpFromBackGroundNotice: Observable<String>= Observable("")
    var goingtoBackGroundNotice:Observable<String>= Observable("")
}


class Util:NSObject{

    static var observables:AppObservables = AppObservables()
    
    static func getNearestAirport(lat:Double,longt:Double) -> AirPort?
    {
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "latitude BETWEEN {%f, %f} AND longtitude BETWEEN {%f, %f}",
            lat - 0.01,
            lat + 0.01,
            longt - 0.01,
            longt + 0.01
        )
        
        let airPort = realm.objects(AirPort).filter(predicate).first
        return airPort
    }
    
    static func getEventdAirports(event:TraceEvent?) -> [(AirPort,TraceLocation)]
    {
        var resultArray = Array<(AirPort,TraceLocation)>()
        if let event = event
        {
            let locationList = event.traceLocations
            var airPortCheckSet = Set<Int>()
            for location in locationList
            {
                let airport  = Util.getNearestAirport(location.locationLatitude, longt: location.locationLongitude)
                if let airport = airport
                {
                    if !airPortCheckSet.contains(airport.id)
                    {
                        let tuple = (airport,location)
                        resultArray.append(tuple)
                        airPortCheckSet.insert(airport.id)
                    }
                }
            }

        }
        return resultArray;
    }
    
    static func processAirportData()
    {
        let realm = try! Realm()
        let airPorts = realm.objects(AirPort)
        if airPorts.count == 0
        {
            let fileURL: NSURL! = NSBundle.mainBundle().URLForResource("airports", withExtension: "csv")
            if let data = NSData(contentsOfURL: fileURL) {
                if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    let csv = CSwiftV(String: String(content))
                    let rows = csv.rows
                    for row in rows
                    {
                        let airPort = AirPort()
                        airPort.id = Int(row[0])!
                        airPort.name = row[1]
                        airPort.city = row[2]
                        airPort.country = row[3]
                        airPort.threeLetterCode = row[4]
                        airPort.fourLetterCode = row[5]
                        airPort.latitude = Double(row[6])!
                        airPort.longtitude = Double(row[7])!
                        airPort.timezone =  Int(floor(CGFloat((row[9] as NSString).floatValue)))
                        airPort.altitude = Double(row[8])!
                        airPort.dst = row[10]
                        airPort.tzTimezone = row[11]
                        
                        try! realm.write{
                            realm.add(airPort)
                        }

                    }
                }
            }
        }

    }
    
    static func altimeterAvailable() -> Bool
    {
        return CMAltimeter.isRelativeAltitudeAvailable()
    }
    
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