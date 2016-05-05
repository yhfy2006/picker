//
//  DataAnalysor.swift
//  TracePilot
//
//  Created by He, Changchen on 4/29/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import Foundation
import MapKit
import SwiftDate
import RealmSwift



//Steep turn angle formula:
//http://aviation.stackexchange.com/questions/2871/how-to-calculate-angular-velocity-and-radius-of-a-turn

enum DataReportWindow {
    case ThisMonth
    case PastThreeMonth
    case PastYear
}

class DataAnalysor: NSObject {
    static let sharedInstance = DataAnalysor()
    
     let realm = try! Realm()
    
    func gerateReportWithTimeWindow(timeWindow:DataReportWindow)
    {
        let todayDate = NSDate()
        
        var finalReports:[DataAnalysorReport] = Array()
        
        switch timeWindow {
            
        case .ThisMonth :
            let monthStartDate = todayDate.startOf(.Month)
            let predicate = NSPredicate(format: "createdTimeStampe > %@", monthStartDate)
            let results = realm.objects(TraceEvent).filter(predicate)
            for result in results
            {
                let report = DataAnalysorReport()
                report.duration = result.duration
                report.date = result.createdTimeStampe
                report.reportDescription = "\(result.createdTimeStampe.month)/\(result.createdTimeStampe.day)"
                finalReports.append(report)
            }
            break
            
        case .PastThreeMonth:
            for i in 1...3
            {
                let monthStartDate = todayDate.startOf(.Month)
                let lastMonthStartDate = monthStartDate - i.months
                let lastMonthEndDate = lastMonthStartDate.endOf(.Month)
                let predicate = NSPredicate(format: "createdTimeStampe > %@ AND createdTimeStampe > %@" , lastMonthStartDate,lastMonthEndDate)
                let results = realm.objects(TraceEvent).filter(predicate)
                var totalDuration = 0.0
                for result in results
                {
                    totalDuration += result.duration
                }
                
                let report = DataAnalysorReport()
                report.reportDescription = "\(lastMonthStartDate.monthName)"
                finalReports.append(report)
            }
            break
            
        case .PastYear :
            for i in 1...12
            {
                let monthStartDate = todayDate.startOf(.Month)
                let lastMonthStartDate = monthStartDate - i.months
                let lastMonthEndDate = lastMonthStartDate.endOf(.Month)
                let predicate = NSPredicate(format: "createdTimeStampe > %@ AND createdTimeStampe > %@" , lastMonthStartDate,lastMonthEndDate)
                let results = realm.objects(TraceEvent).filter(predicate)
                var totalDuration = 0.0
                for result in results
                {
                    totalDuration += result.duration
                }
                
                let report = DataAnalysorReport()
                report.reportDescription = "\(lastMonthStartDate.monthName)"
                finalReports.append(report)
            }
            break
            
            default :break
            
        }
    }

    func generateReportWithTraceEvent(traceEvent:TraceEvent) -> DataAnalysorReport
    {
        let report = DataAnalysorReport()
        report.avgSpeed = self.analyzeAveSpeed(traceEvent)
        report.avgAltitude = self.analyeAveAltitude(traceEvent)
        report.steepTurns = self.analyzeSteepTurns(traceEvent)
        report.stalls = BlackBox.sharedInstance.stalls
        
        return report
    }
    
    
    func analyzeAveSpeed(traceEvent:TraceEvent) -> Double
    {
        let locationList = traceEvent.traceLocations
        var validNumber = 0
        var avgSpeed:Double = 0.0
        var totalSpeed = 0.0
        for location in locationList
        {
            if location.locationSpeed != 0
            {
                totalSpeed += location.locationSpeed
                validNumber += 1
            }
        }
        avgSpeed = totalSpeed / Double(validNumber)
        return avgSpeed
    }
    
    func analyeAveAltitude(traceEvent:TraceEvent) -> Double
    {
        let locationList = traceEvent.traceLocations
        var validNumber = 0
        var avgAltitude:Double = 0.0
        var totalAlt = 0.0
        for location in locationList
        {
            if location.locationAltitude != 0
            {
                totalAlt += location.locationAltitude
                validNumber++
            }
        }
        avgAltitude = totalAlt / Double(validNumber)
        
        return avgAltitude
    }
    
    func analyzePassedAirports(mapView: MKMapView!, traceEvent:TraceEvent ,completionHandler:([MKMapItem]?,NSError?)->Void)
    {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Airport"
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) -> Void in
            if error != nil
            {
                print("error:\(error?.localizedDescription)")
                completionHandler(nil,error)
            }else
            {
                for item in response!.mapItems{
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    completionHandler(response?.mapItems,error)
                }
                completionHandler(self.filterPassedAirports((response?.mapItems)!, traceEvent: traceEvent),error)
                
            }
        }
        
    }
    
    private func filterPassedAirports(airports:[MKMapItem],traceEvent:TraceEvent) -> [MKMapItem]
    {
        var filteredMapitems:[MKMapItem] = Array()
        let locationList = traceEvent.traceLocations
        for location in locationList
        {
            for mapitem in airports
            {
                let myLocation = CLLocation(latitude: location.locationLatitude, longitude: location.locationLongitude)
                if mapitem.placemark.location?.distanceFromLocation(myLocation) < 500 // less than 500 m
                {
                    filteredMapitems.append(mapitem)
                }
            }
        }
        return filteredMapitems
    }
    
    
    func analyzeSteepTurns(traceEvent:TraceEvent) -> [SteepTurn]
    {
        let locationList = traceEvent.traceLocations
        var lastLocation = locationList.first
        var steepTurnBegins = false
    
        var overallSteepTurns:[SteepTurn] = Array()
    
    
        if lastLocation == nil
        {
            return Array()
        }
        
        var steepTurn:SteepTurn?
        
        for location in locationList
        {
            if location == lastLocation
            {
                continue
            }else
            {
                let headingChange = location.locationHeading - lastLocation!.locationHeading
                let avgSpeed = Util.mps2Knot((location.locationSpeed + lastLocation!.locationSpeed) / 2)
                let elapsedTime = location.locationTimeStamp.timeIntervalSinceDate(lastLocation!.locationTimeStamp)
                let duration = Int(elapsedTime)
                let w = headingChange / Double(duration)

                // steep turn fomular
                // ω = 1091tanθ/V
                // θ = bank angle in degrees
                // ω = rate of turn in degrees per second
                // V = true airspeed in knots
                
                let tanCurrent = w * avgSpeed / 1091
                let angle = atan(tanCurrent)
                if angle > 35  // Steep turn!!
                {
                    if(steepTurnBegins == false)
                    {
                      steepTurn = SteepTurn()
                    }
                    
                    steepTurn?.route.append(location)
                    
                    steepTurnBegins = true
                }else
                {
                    if steepTurnBegins == true
                    {
                        steepTurnBegins = false
                        if let newTurn = steepTurn
                        {
                            overallSteepTurns.append(newTurn)
                        }
                    }
                }
                
             lastLocation = location
                
            }
        }
        
        return overallSteepTurns
    }
    
}
