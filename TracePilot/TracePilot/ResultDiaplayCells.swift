//
//  ResultDiaplayCells.swift
//  TracePilot
//
//  Created by He, Changchen on 3/8/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import RealmSwift


class ResultDiaplayCellBasicInfo: UICollectionViewCell {
    @IBOutlet var distanceValueLabel:UILabel?
    @IBOutlet var distanceUnitLabel:UILabel?
    
    // DB store
    var traceEvent:TraceEvent?
    
    func loadCell(){
        self.contentView.backgroundColor = UIColor.whiteColor()
        if let traceEvent = self.traceEvent
        {
            let distance = traceEvent.distance
            let distanceInMiles = String(format: "%.2f", Util.distanceInMiles(distance))
            print("distance:\(distanceInMiles)")
            self.distanceValueLabel?.text = distanceInMiles
        }
        
        
       
    }

}


