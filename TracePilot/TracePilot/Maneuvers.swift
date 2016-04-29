//
//  Maneuvers.swift
//  TracePilot
//
//  Created by He, Changchen on 4/29/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import Foundation

class Stall: NSObject {
    var occurTime:Double?
}

class SteepTurn: NSObject{
    var route:[TraceLocation] = Array()
}