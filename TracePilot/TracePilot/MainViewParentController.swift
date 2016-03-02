//
//  ViewController.swift
//  TracePilot
//
//  Created by VincentHe on 3/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var containerViewSession:UIView?
    @IBOutlet var containerViewHistoryView:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentTitles = [
            "session",
            "history",
        ]
        
        let segmentedControl = UISegmentedControl(items: segmentTitles)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        // change the width from 400.0 to something you want if it's needed
        segmentedControl.frame = CGRectMake(0, 0, 200.0, 30.0)
        segmentedControl.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.tintColor = UIColor.whiteColor()
        self.navigationItem.titleView = segmentedControl
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

