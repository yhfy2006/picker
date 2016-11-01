//
//  AllDirectionMainViewPage.swift
//  TracePilot
//
//  Created by He, Changchen on 10/28/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit

class AllDirectionMainViewPage: CCPage {
    
    //static let cellIdentifier = "allDirectionMainView"
    
   // var customView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customView = UIView(frame:frame)
        customView?.backgroundColor = UIColor.blue
        self.contentView.addSubview(customView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
