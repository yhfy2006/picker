//
//  DataAnalysorReport.swift
//  TracePilot
//
//  Created by He, Changchen on 4/29/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import Foundation

class DataAnalysorReport: NSObject {
    var avgSpeed:Double?
    var avgAltitude:Double?
    var steepTurns:[SteepTurn]?
    var stalls:[Stall]?
    var duration:Double?
    var window:DataReportWindow?
    var reportDescription:String?
    var date:Date?
}
