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
import CoreLocation
import HealthKit
import RealmSwift
import TransitionTreasury
import CoreMotion

class SessionViewController: UIViewController,EditFlightViewDelegate {
    
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
    
    var startLogging:Bool = false
    
    // Timer
    var timer:NSTimer?
    var startTime = NSTimeInterval()
    
    //altimeter 
    let altimeter = CMAltimeter()
    
    // tracking
    var seconds = 0.0
    var distance = 0.0
    var speed = 0.0
    var heading = 0.0
    var relativeAltitude = 0.0
    
    // DB store
    var traceEvent:TraceEvent?
    
    // status 1 = before start; 2=Recording; 3=Paused
    var loggingStatus = 1
    
    
    lazy var locationManager:CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    lazy var locations = [CLLocation]()
    let realm = try! Realm()
    
    var flightEidtViewController:EditFlightViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if realm.objects(TraceEvent).count == 0
        {
            let event = TraceEvent()
            event.title = "Test1"
            event.id = event.IncrementaID()
            try! realm.write {
                realm.add(event)
            }
        }else
        {
             self.traceEvent = realm.objects(TraceEvent).first
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonWithStatus()
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    @IBAction func loggingButtonPressed(sender:UIButton){
        if self.loggingStatus == 2
        {
            stopUpdateTime()
            self.loggingStatus = 3
            updateButtonWithStatus()
            stopSwingAnimation()
        }else if self.loggingStatus == 1
        {
            self.startUpdateTime()
            self.loggingStatus = 2
            updateButtonWithStatus()
            startSwingAnimation()
        }
    }
    
    @IBAction func resumeButtonPressed(sender:UIButton)
    {
       self.loggingStatus = 2
        updateButtonWithStatus()
        startUpdateTime()
        startSwingAnimation()
    }
    
    @IBAction func finishButtonPressed(sender:UIButton)
    {
        //saveFlight()
        presentFlightEditView();
    }
    
    func startSwingAnimation()
    {
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
    
    
    func startUpdateTime()
    {
        let aSelector : Selector = "eachSecond"
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        if(self.loggingStatus == 1)
        {
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        locationManager.startUpdatingLocation()
        // 1
        if CMAltimeter.isRelativeAltitudeAvailable() {
            // 2
            altimeter.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { data, error in
                // 3
                if (error == nil) {
                    self.relativeAltitude = data!.relativeAltitude.doubleValue
                }
            })
        }
        
    }
    
    // Everything each second should be doing
    func eachSecond()
    {
        seconds++
        print(seconds)
        
        // distance
        let distanceInMiles = String(format: "%.2f", Util.distanceInMiles(distance))
        print("distance:\(distanceInMiles)")
        self.distanceValueLabel?.text = distanceInMiles
        
        // speed
        let speedInKnots = String(format: "%.1f", self.speed);
        self.goundSpeedValueLabel?.text = speedInKnots
        
        // heading
        let headingIndegree = String(format: "%.1f", self.heading);
        self.headingValueLabel?.text = headingIndegree
        
        //altitude
        if let baseLocation = self.locations.last
        {
            var baseAltitude = baseLocation.altitude
            print("altitude\(baseAltitude)")
            if abs(self.relativeAltitude) >= 1
            {
                baseAltitude += self.relativeAltitude
            }
            self.altitudeValueLabel?.text = String(format: "%.2f", baseAltitude);
        }
        
        
        
        var elapsedTime: NSTimeInterval = seconds
        //calculate the minutes in elapsed time.
        let hours = UInt8(elapsedTime / 3600)
        elapsedTime -= (NSTimeInterval(hours) * 3600)
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let scend = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", scend)
        
        timeCountLabel?.text = "\(strHours):\(strMinutes):\(strSeconds)"
        
    }
    
    func saveFlight()
    {
        try! realm.write{
            self.traceEvent?.distance = distance
            self.traceEvent?.duration = seconds
        }

        for location in self.locations
        {
            let traceLocation = TraceLocation()
            try! realm.write{
                traceLocation.locationSpeed = location.speed
                traceLocation.locationHeading = location.course
                traceLocation.locationTimeStamp = location.timestamp
                traceLocation.locationLatitude = location.coordinate.latitude
                traceLocation.locationLongitude = location.coordinate.longitude
                traceLocation.eventId = self.traceEvent!.id
                self.traceEvent?.traceLocations.append(traceLocation)

            }
        }

    }
    
    func stopUpdateTime()
    {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
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
    
    func editDidCommit()
    {
        saveFlight()
        self.performSegueWithIdentifier("goToResultView", sender:nil)
    }
    
    func editDidDiscard()
    {
        try! realm.write{
            self.traceEvent?.distance = 0.0
            self.traceEvent?.duration = 0.0
            seconds = -1;
            heading = 0
            speed = 0;
            distance = 0;
            relativeAltitude = 0;
            eachSecond()
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

extension SessionViewController:CLLocationManagerDelegate{
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print(newLocation.altitude);
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            if location.horizontalAccuracy < 20 {
                // update distance, heading, and speed
                if self.locations.count > 0 {
                    let firstLocation = self.locations.last
                    distance += location.distanceFromLocation(firstLocation!)
                    speed = Util.mps2Knot(location.speed)
                    heading = location.course
                }
                //sace location
                self.locations.append(location)
            }
        }
    }
    
 
}
