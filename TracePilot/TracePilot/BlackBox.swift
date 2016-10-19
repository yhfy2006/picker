//
//  BlackBox.swift
//  TracePilot
//
//  Created by VincentHe on 3/15/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import CoreLocation
import UIKit
import CoreMotion
import AVFoundation


class BlackBox: NSObject {
   static let sharedInstance = BlackBox()
   
   lazy var locationManager:CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    lazy var locations = [CLLocation]()
    lazy var altitudes = [Double]()
    
    // Timer
    var startTime = TimeInterval()
    var timer:Timer?
    
    //altimeter
    let altimeter = CMAltimeter()
    
    //base altitude
    var baseAltitude = DBL_MAX
    
    // tracking
    var seconds = 0.0
    var distance = 0.0
    var speed = 0.0
    var heading = 0.0
    var relativeAltitude = 0.0
    
    // motion
    let motionKit = MotionKit()
    var stalls:[Stall] = Array()
    
    
    var isRecording = false
    
    var player: AVAudioPlayer!
    
    var delegate:BlackBoxDelegate?

    
    override init()
    {
        super.init()
        self.setupMusicPlayer()
    }
    
    func startRecordingWithLoggingState(_ state:Int)
    {
        isRecording = true
        
        // clearup data
        stalls.removeAll()
        
        
        if(state == 1)
        {
            startTime = Date.timeIntervalSinceReferenceDate
        }else if(state == 2)
        {
            seconds = Date.timeIntervalSinceReferenceDate - startTime
        }
        let aSelector : Selector = #selector(BlackBox.eachSecond)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        
        locationManager.startUpdatingLocation()
        // 1
        if CMAltimeter.isRelativeAltitudeAvailable() {
            // 2
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                // 3
                if (error == nil) {
                    self.relativeAltitude = data!.relativeAltitude.doubleValue
                    print("气压计:\(data!.relativeAltitude.doubleValue)")
                }
            })
        }
        
        motionKit.getDeviceMotionObject(0.2) { (deviceMotion) -> () in
            if deviceMotion.userAcceleration.x>1 || deviceMotion.userAcceleration.y>1 || deviceMotion.userAcceleration.z>1
            {
                print("bumped")
            }
        }
//
        motionKit.getAccelerationFromDeviceMotion { (x, y, z) -> () in
            // record stalls
            if((abs(x) < 0.1) && (abs(y) < 0.1) && (abs(z) < 0.1)){
                if let lastStall = self.stalls.last
                {
                    if lastStall.occurTime! < self.seconds - 10
                    {
                        let newStall = Stall()
                        newStall.occurTime = self.seconds
                        self.stalls.append(newStall)
                    }
                }
            }
        }
        
        // play music!
        player.numberOfLoops = -1
        player.play()
        
    }
    
    func stopRecording()
    {
        locationManager.stopUpdatingLocation()
        altimeter.stopRelativeAltitudeUpdates()
        motionKit.stopDeviceMotionUpdates()
        timer?.invalidate()
        timer = nil
        player.stop()
    }
    
    func discardAllData()
    {
        seconds = -1;
        heading = 0
        speed = 0;
        distance = 0;
        relativeAltitude = 0;
        eachSecond()
    }
    
    // Everything each second should be doing
    func eachSecond()
    {
        seconds += 1
        delegate?.blackBoxEachSecondUpdate(seconds,distance:distance, speed: speed, heading: heading, altitude: relativeAltitude + baseAltitude);
        
    }
    
    func setupMusicPlayer()
    {
        var error: NSError?
        var success: Bool
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSessionCategoryPlayAndRecord,
                with: .defaultToSpeaker)
            success = true
        } catch let error1 as NSError {
            error = error1
            success = false
        }
        if !success {
            NSLog("Failed to set audio session category.  Error: \(error)")
        }
        //let songNames = ["FeelinGood","IronBacon","WhatYouWant"]
        //let songs = songNames.map { AVPlayerItem(URL:
        //    NSBundle.mainBundle().URLForResource($0, withExtension: "mp3")!) }
        
        let fileURL: URL! = Bundle.main.url(forResource: "10sec", withExtension: "mp3")
        do {
            try self.player = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch let error1 as NSError {
            error = error1
            success = false
        }
        
        
    }
}

protocol BlackBoxDelegate
{
    func blackBoxEachSecondUpdate(_ duration:Double,distance:Double,speed:Double,heading:Double,altitude:Double)
    func locationManagerGetUpdated(_ newestLocations:CLLocation)
}

extension BlackBox:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            if location.horizontalAccuracy < 20 {
                // update base
                if baseAltitude == DBL_MAX && location.verticalAccuracy >= 0
                {
                    baseAltitude = location.altitude
                }
                
                // update distance, heading, and speed
                if self.locations.count > 0
                {
                    let firstLocation = self.locations.last
                    distance += location.distance(from: firstLocation!)
                    speed = Util.mps2Knot(location.speed)
                    heading = location.course
                }
                //sace location
                self.locations.append(location)
                self.altitudes.append(relativeAltitude)
                delegate?.locationManagerGetUpdated(location)
                
            }
        }
    }
    
    
}
