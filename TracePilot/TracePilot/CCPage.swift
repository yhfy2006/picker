//
//  CCPage.swift
//  TracePilot
//
//  Created by He, Changchen on 10/28/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import SnapKit


class CCPage: UICollectionViewCell {
    
    var customView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func load(){
        if let _ = customView
        {
            print("hey")
        }else
        {
            customView = UIView(frame:self.contentView.bounds)
            customView?.backgroundColor = UIColor.blue
        }
        addSubview(customView!)
        customView!.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        self.contentView.backgroundColor = getRandomColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}
