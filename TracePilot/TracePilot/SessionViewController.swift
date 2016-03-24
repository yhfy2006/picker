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
import HealthKit
import RealmSwift
import TransitionTreasury
import AVFoundation
import CoreMotion
import CoreLocation




class SessionViewController: UIViewController,EditFlightViewDelegate,BlackBoxDelegate {
    
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
    @IBOutlet var resumeButton:UIButton?
    @IBOutlet var finishButton:UIButton?
    
    //debugView
    @IBOutlet var debugView:UIView?
    @IBOutlet var debugLocationLabel:UILabel?
    @IBOutlet var debugLocationAlti:UILabel?
    @IBOutlet var debugButton:UIButton?
    
    var startLogging:Bool = false
    
    var blackBox = BlackBox.sharedInstance
   
    
    // DB store
    var traceEvent:TraceEvent?
    
    // status 1 = before start; 2=Recording; 3=Paused
    var loggingStatus = 1
    

    
    let realm = try! Realm()
    
    var flightEidtViewController:EditFlightViewController?
    
    var player: AVQueuePlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blackBox.delegate = self
        
        self.traceEvent = TraceEvent()
        self.traceEvent?.IncrementaID()
        updateButtonWithStatus()
        
        //Observables
        Util.observables.wakeUpFromBackGroundNotice.afterChange.add { (_) -> () in
            // resume logging if status ==2
            if self.loggingStatus == 2
            {
                self.resumeButtonPressed(UIButton())
            }
        }
        
        Util.observables.goingtoBackGroundNotice.afterChange.add { (_) -> () in
            self.blackBox.timer?.invalidate()
            self.blackBox.timer = nil
        }
        
        
        //debug settings
        debugView?.hidden = true
        let longPress = UILongPressGestureRecognizer(target: self, action: "debugLongPress:")
        self.debugButton!.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.blackBox.locationManager.requestAlwaysAuthorization()
        if self.loggingStatus == 2
        {
            resumeButtonPressed(UIButton())
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func startSwingAnimation()
    {
        stopSwingAnimation()
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
    }
    
    func stopSwingAnimation()
    {
        self.airplaneImageView?.layer.removeAllAnimations()
    }
    
    func updateButtonWithStatus()
    {
        if self.loggingStatus == 1
        {
            loggingButton?.hidden = false
            resumeButton?.hidden  = true
            finishButton?.hidden = true
            self.loggingButton?.setTitle("Start logging", forState: .Normal)
        }else if self.loggingStatus == 2
        {
           self.loggingButton?.setTitle("Pause logging", forState: .Normal)
            loggingButton?.hidden = false
            resumeButton?.hidden  = true
            finishButton?.hidden = true
        }else
        {
            self.loggingButton?.setTitle("Pause logging", forState: .Normal)
            loggingButton?.hidden = true
            resumeButton?.hidden  = false
            finishButton?.hidden = false
        }
        
    }
    
    
    func startRecording()
    {
        self.blackBox.startRecordingWithLoggingState(self.loggingStatus)
    }
    
    func blackBoxEachSecondUpdate(duration: Double, distance: Double, speed: Double, heading: Double, altitude: Double)
    {
        // distance
        let distanceInMiles = String(format: "%.2f", Util.distanceInMiles(distance))
        //print("distance:\(distanceInMiles)")
        self.distanceValueLabel?.text = distanceInMiles
        
        // speed
        let speedInKnots = String(format: "%.1f", speed);
        self.goundSpeedValueLabel?.text = speedInKnots
        
        // heading
        let headingIndegree = String(format: "%.1f", heading);
        self.headingValueLabel?.text = headingIndegree
        
        if CMAltimeter.isRelativeAltitudeAvailable()
        {
            self.altitudeValueLabel?.text = altitude == DBL_MAX ? "-" : String(format: "%.2f", altitude);
        }else
        {
            self.altitudeValueLabel?.text = "-"
        }
        
        timeCountLabel?.text = Util.timeString(duration)
    }
    
    func locationManagerGetUpdated(newestLocations: CLLocation)
    {
        // debugView
        self.debugLocationLabel?.text = "lo:\(newestLocations.coordinate.latitude) \(newestLocations.coordinate.longitude)"
        self.debugLocationAlti?.text = "loAl:\(self.blackBox.baseAltitude) + \(self.blackBox.relativeAltitude)"
    }
    
    func saveFlight()
    {
        try! realm.write{
            realm.add(self.traceEvent!)
            self.traceEvent?.distance = self.blackBox.distance
            self.traceEvent?.duration = self.blackBox.seconds
        }

        var index = 0
        for location in self.blackBox.locations
        {
            let traceLocation = TraceLocation()
            try! realm.write{
                traceLocation.locationSpeed = location.speed
                traceLocation.locationHeading = location.course
                traceLocation.locationTimeStamp = location.timestamp
                traceLocation.locationLatitude = location.coordinate.latitude
                traceLocation.locationLongitude = location.coordinate.longitude
                traceLocation.eventId = self.traceEvent!.id
                if index < self.blackBox.altitudes.count
                {
                    traceLocation.locationAltitude = self.blackBox.altitudes[index]
                }
                self.traceEvent!.traceLocations.append(traceLocation)

            }
            index++
        }

    }
    
    func stopRecording()
    {
        self.blackBox.stopRecording()
    }
    
    func presentFlightEditView()
    {
        if self.flightEidtViewController == nil
        {
            self.flightEidtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EditSessionView") as? EditFlightViewController
        }
        self.flightEidtViewController?.traceEvent = self.traceEvent
        self.flightEidtViewController?.delegate = self
        self.presentViewController(self.flightEidtViewController!, animated: true, completion: nil)
        
    }
    func editDidCommit(flightName: String?, flightComment: String?) {
        saveFlight()
        try! realm.write{
            self.traceEvent?.title = flightName!
            self.traceEvent?.selfDecsription = flightComment!
        }
        self.performSegueWithIdentifier("goToResultView", sender:nil)
        editDidDiscard()
    }
    
    func editDidDiscard()
    {
        self.traceEvent = TraceEvent()
        self.traceEvent?.IncrementaID()
        try! realm.write{
            self.traceEvent?.distance = 0.0
            self.traceEvent?.duration = 0.0
        }
        self.blackBox.discardAllData()
        self.loggingStatus = 1
        updateButtonWithStatus()
        
    }
    
    //MARK: -IBActions
    
    @IBAction func loggingButtonPressed(sender:UIButton){
        if self.loggingStatus == 2
        {
            stopRecording()
            self.loggingStatus = 3
            updateButtonWithStatus()
            stopSwingAnimation()
        }else if self.loggingStatus == 1
        {
            self.startRecording()
            self.loggingStatus = 2
            updateButtonWithStatus()
            startSwingAnimation()
        }
    }
    
    @IBAction func resumeButtonPressed(sender:UIButton)
    {
        self.loggingStatus = 2
        updateButtonWithStatus()
        startRecording()
        startSwingAnimation()
    }
    
    @IBAction func finishButtonPressed(sender:UIButton)
    {
        presentFlightEditView();
    }
    
    
    func debugLongPress(guesture: UILongPressGestureRecognizer)
    {
        if guesture.state == UIGestureRecognizerState.Began {
            debugView?.hidden = !debugView!.hidden
        }
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "goToResultView")
        {
            
            let controller = (segue.destinationViewController as! ResultDisplayViewController)
            controller.traceEvent = self.traceEvent
        }
    }
    
    
}


