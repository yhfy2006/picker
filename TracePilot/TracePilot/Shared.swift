//
//  Shared.swift
//  TracePilot
//
//  Created by VincentHe on 3/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit

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

}