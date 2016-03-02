//
//  SessionViewController.swift
//  TracePilot
//
//  Created by VincentHe on 3/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import Spring
import EasyAnimation

class SessionViewController: UIViewController {
    
    @IBOutlet var goundSpeedValueLabel:UILabel?
    @IBOutlet var goundSpeedUnitLabel:UILabel?
    @IBOutlet var altitudeValueLabel:UILabel?
    @IBOutlet var altitudeUnitLabel:UILabel?
    @IBOutlet var headingValueLabel:UILabel?
    @IBOutlet var headingUnitLabel:UILabel?
    
    @IBOutlet var timeCountLabel:UILabel?
    
    @IBOutlet var distanceValueLabel:UILabel?
    @IBOutlet var distanceUnitLabel:UILabel?
    
    @IBOutlet var airplaneImageView:UIImageView?
    
    @IBOutlet var loggingButton:UIButton?
    
    var startLogging:Bool = false
    
    // Timer
    var timer:NSTimer?
    var startTime = NSTimeInterval()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loggingButtonPressed(sender:UIButton){
        if startLogging
        {
            stopUpdateTime()
            startLogging = false
            self.airplaneImageView?.layer.removeAllAnimations()
            self.loggingButton?.setTitle("Start logging", forState: .Normal)
        }else
        {
            self.startUpdateTime()
            UIView.animateWithDuration(0.5, delay: 0.0,
                options: [],
                animations: {
                    self.airplaneImageView?.transform =  CGAffineTransformMakeRotation(CGFloat(-M_PI_4/2))
                    
                }, completion: { (finished) -> Void in
                    UIView.animateWithDuration(1.0, delay: 0.0,
                        options: [.Repeat, .Autoreverse, .CurveLinear],
                        animations: {
                            self.airplaneImageView?.transform =  CGAffineTransformMakeRotation(CGFloat(M_PI_4/2))
                            
                        }, completion: { (finished) -> Void in
                            print("a")
                            self.airplaneImageView?.transform =  CGAffineTransformMakeRotation(CGFloat(0))
                    })
            })
            self.loggingButton?.setTitle("Stop logging", forState: .Normal)
            startLogging = true
        }
    }
    
    func startUpdateTime()
    {
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func stopUpdateTime()
    {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTime()
    {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let hours = UInt8(elapsedTime / 360)
        elapsedTime -= (NSTimeInterval(hours) * 360)
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        timeCountLabel?.text = "\(strHours):\(strMinutes):\(strSeconds)"
        
    }
    
}
