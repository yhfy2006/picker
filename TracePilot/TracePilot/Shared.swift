//
//  Shared.swift
//  TracePilot
//
//  Created by VincentHe on 3/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion
import RealmSwift
import CSwiftV
import Observable


enum ResultDisplayCellType {
    case metaData
    case speedChart
    case altitudeChart
    case airports
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
    
    static func getNearestAirport(_ lat:Double,longt:Double) -> AirPort?
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
    
    static func getEventdAirports(_ event:TraceEvent?) -> [(AirPort,TraceLocation)]
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
            let fileURL: URL! = Bundle.main.url(forResource: "airports", withExtension: "csv")
            if let data = try? Data(contentsOf: fileURL) {
                if let content = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    let csv = CSwiftV(with: String(content))
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
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let audioPath = documentsDirectory
        return audioPath
    }
    
    static func mps2kph(_ speed:Double)->Double
    {
        return speed*3.6
    }
    
    static func mps2Knot(_ speed:Double)->Double
    {
        return speed * 1.94384
    }
    
    static func mps2mph(_ speed:Double)->Double
    {
        return speed * 2.23694
    }
    
    static func distanceInMiles(_ value:Double)->Double
    {
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: value)
        return distanceQuantity.doubleValue(for: HKUnit.mile())
    }
    
    static func timeString(_ seconds:TimeInterval)->String
    {
        var elapsedTime: TimeInterval = seconds
        //calculate the minutes in elapsed time.
        let hours = UInt8(elapsedTime / 3600)
        elapsedTime -= (TimeInterval(hours) * 3600)
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        let scend = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", scend)
        
        return "\(strHours):\(strMinutes):\(strSeconds)"
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func makeCircleAtLocation(location:CGPoint,radius:CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath()
        path.addArc(withCenter: location, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        return path
    }

}
