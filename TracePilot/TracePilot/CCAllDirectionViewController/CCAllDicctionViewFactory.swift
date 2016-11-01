//
//  CCAllDicctionViewFactory.swift
//  TracePilot
//
//  Created by He, Changchen on 10/28/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit

class CCAllDicctionViewFactory: NSObject {
    var row:Int = 0
    var column:Int = 0
    var contentArray = Array<(row:Int,col:Int,controller:UIViewController)>()
    
    static let sharedInstance : CCAllDicctionViewFactory = {
        let instance = CCAllDicctionViewFactory()
        return instance
    }()
    
//    init(row:Int,column:Int) {
//        self.row = row
//        self.column = column
//    }
    
    func addVCTo(row:Int,col:Int,controller:UIViewController){
        let a:(row:Int,col:Int,controller:UIViewController)  = (row,col,controller)
        self.contentArray.append(a)
    }
    
    func getVCAt(row:Int,col:Int) -> UIViewController? {
        let filtered = contentArray.filter{$0.row == row && $0.col == col }
        if(filtered.count>0)
        {
            let a = filtered[0].controller
            return a
        }else
        {
            return nil
        }
    }
    
}
