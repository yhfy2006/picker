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
        //TODO
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
        debugView?.isHidden = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SessionViewController.debugLongPress(_:)))
        self.debugButton!.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.blackBox.locationManager.requestAlwaysAuthorization()
        if self.loggingStatus == 2
        {
            resumeButtonPressed(UIButton())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func startSwingAnimation()
    {
        stopSwingAnimation()
        UIView.animate(withDuration: 0.5, delay: 0.0,
            options: [],
            animations: {
                self.airplaneImageView?.transform =  CGAffineTransform(rotationAngle: CGFloat(-M_PI_4/2))
                
            }, completion: { (finished) -> Void in
                UIView.animate(withDuration: 1.0, delay: 0.0,
                    options: [.repeat, .autoreverse, .curveLinear],
                    animations: {
                        self.airplaneImageView?.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI_4/2))
                        
                    }, completion: { (finished) -> Void in
                        print("a")
                        self.airplaneImageView?.transform =  CGAffineTransform(rotationAngle: CGFloat(0))
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
            loggingButton?.isHidden = false
            resumeButton?.isHidden  = true
            finishButton?.isHidden = true
            self.loggingButton?.setTitle("Start logging", for: UIControlState())
        }else if self.loggingStatus == 2
        {
           self.loggingButton?.setTitle("Pause logging", for: UIControlState())
            loggingButton?.isHidden = false
            resumeButton?.isHidden  = true
            finishButton?.isHidden = true
        }else
        {
            self.loggingButton?.setTitle("Pause logging", for: UIControlState())
            loggingButton?.isHidden = true
            resumeButton?.isHidden  = false
            finishButton?.isHidden = false
        }
        
    }
    
    
    func startRecording()
    {
        self.blackBox.startRecordingWithLoggingState(self.loggingStatus)
    }
    
    func blackBoxEachSecondUpdate(_ duration: Double, distance: Double, speed: Double, heading: Double, altitude: Double)
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
    
    func locationManagerGetUpdated(_ newestLocations: CLLocation)
    {
        // debugView
        self.debugLocationLabel?.text = "lo:" + String(format: "%.4f", newestLocations.coordinate.latitude) + " " + String(format: "%.4f", newestLocations.coordinate.longitude)
        
        self.debugLocationAlti?.text = "loAl:" + String(format: "%.2f", self.blackBox.baseAltitude) + "+" + String(format: "%.2f", self.blackBox.relativeAltitude)
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
            index += 1
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
            self.flightEidtViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditSessionView") as? EditFlightViewController
        }
        self.flightEidtViewController?.traceEvent = self.traceEvent
        self.flightEidtViewController?.delegate = self
        self.present(self.flightEidtViewController!, animated: true, completion: nil)
        
    }
    func editDidCommit(_ flightName: String?, flightComment: String?) {
        saveFlight()
        try! realm.write{
            self.traceEvent?.title = flightName!
            self.traceEvent?.selfDecsription = flightComment!
        }
        self.performSegue(withIdentifier: "goToResultView", sender:nil)
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
    
    @IBAction func loggingButtonPressed(_ sender:UIButton){
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
    
    @IBAction func resumeButtonPressed(_ sender:UIButton)
    {
        self.loggingStatus = 2
        updateButtonWithStatus()
        startRecording()
        startSwingAnimation()
    }
    
    @IBAction func finishButtonPressed(_ sender:UIButton)
    {
        presentFlightEditView();
    }
    
    
    func debugLongPress(_ guesture: UILongPressGestureRecognizer)
    {
        if guesture.state == UIGestureRecognizerState.began {
            debugView?.isHidden = !debugView!.isHidden
        }
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "goToResultView")
        {
            
            let controller = (segue.destination as! ResultDisplayViewController)
            controller.traceEvent = self.traceEvent
        }
    }
    
    
}


