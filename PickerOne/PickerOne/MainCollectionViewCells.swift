//
//  MainCollectionViewCells.swift
//  PickerOne
//
//  Created by VincentHe on 2/4/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit



class MainCollectionViewCells: UICollectionViewCell {
    
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var numberOfChoicesLabel:UILabel?
    @IBOutlet var pick1Button:UIButton?
    
    var pickJob:PickerJob?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func loadContent(){
       if let title = pickJob?.title{
            titleLabel?.text = title
        }
        
        if let numberOfChoices = pickJob?.jobDetails.count{
            numberOfChoicesLabel?.text =  "\(numberOfChoices) total choices"
        }
    }
    
//    func loadContent(completionHandler:(DailyReading?,ErrorType?)->Void)
//    {
//       
//    }

}