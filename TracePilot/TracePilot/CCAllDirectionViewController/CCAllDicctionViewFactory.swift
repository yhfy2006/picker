//
//  CCAllDicctionViewFactory.swift
//  TracePilot
//
//  Created by He, Changchen on 10/28/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit

class CCAllDicctionViewFactory: NSObject {
    var row:Int
    var column:Int
    var contentArray = Array<(row:Int,col:Int,controller:UIViewController)>()
    
    init(row:Int,column:Int) {
        self.row = row
        self.column = column
    }
    
    func addVCTo(row:Int,col:Int,controller:UIViewController){
        let a:(row:Int,col:Int,controller:UIViewController)  = (row,col,controller)
        self.contentArray.append(a)
    }
    
}
