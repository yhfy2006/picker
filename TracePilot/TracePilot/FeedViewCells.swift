//
//  FeedViewCells.swift
//  TracePilot
//
//  Created by He, Changchen on 3/10/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import RealmSwift


class FeedViewNormalCell: UICollectionViewCell {
    @IBOutlet var dateLabel:UILabel?
    
    // DB store
    var traceEvent:TraceEvent?
    
    func loadCell(){
        self.contentView.backgroundColor = UIColor.whiteColor()
        if let traceEvent = self.traceEvent
        {
            let date = traceEvent.createdTimeStampe
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
            let stringDate = dateFormatter.stringFromDate(date)
            dateLabel?.text = stringDate
        }
        
    }
    
}
