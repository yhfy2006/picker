//
//  Shared.swift
//  EZRecorder
//
//  Created by VincentHe on 2/20/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import Foundation
import UIKit

class Util:NSObject{
    
    static func getRamdonFileName()->String
    {
        // get the current date and time
        let currentDateTime = NSDate()
        
        // get the user's calendar
        let userCalendar = NSCalendar.currentCalendar()
        
        // choose which date and time components are needed
        let requestedComponents: NSCalendarUnit = [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute,
            NSCalendarUnit.Second
        ]
        let dateTimeComponents = userCalendar.components(requestedComponents, fromDate: currentDateTime)
        
        // now the components are available
        let fileName = "\(dateTimeComponents.year)\(dateTimeComponents.month)\(dateTimeComponents.day)\(dateTimeComponents.hour)\(dateTimeComponents.minute)\(dateTimeComponents.second)" + ".m4a"
        
        return fileName

    }
    
    static func getAudioDirectory()->String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        let audioPath = documentsDirectory + "/audios"
        
        do{
            if !NSFileManager.defaultManager().fileExistsAtPath(audioPath)
            {
                try NSFileManager.defaultManager().createDirectoryAtPath(audioPath, withIntermediateDirectories: false, attributes: nil)
            }
        }catch let error as NSError
        {
            print(error.localizedDescription);
        }
        return audioPath
    }
    
    
}