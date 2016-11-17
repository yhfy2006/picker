//
//  LoggingViewController.swift
//  TracePilot
//
//  Created by He, Changchen on 11/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion


class LoggingViewController: UIViewController,BlackBoxDelegate {

    let centerRoundShape = CAShapeLayer()
    let centerRoundGradinentShape = CAGradientLayer()
    var statusPointView = UIView()
    var startAnimation = CAKeyframeAnimation(keyPath: "position")
    
    var startRecording = false
    var animating = false
    
    let ringBlue = Util.hexStringToUIColor(hex: "25BFF0").cgColor
    let buttonGrey = Util.hexStringToUIColor(hex: "979797").cgColor
    
    // recording functions
    let blackBox = BlackBox.sharedInstance
    
    @IBOutlet var launchButton:UIButton?
    @IBOutlet var speedLabel:UILabel?
    @IBOutlet var altitudeLabel:UILabel?
    @IBOutlet var headingLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blackBox.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        let radis = launchButton!.bounds.size.width/2.0 + 10
        centerRoundShape.path = Util.makeCircleAtLocation(location: self.launchButton!.center, radius: radis).cgPath
        
        centerRoundShape.strokeColor = UIColor.purple.cgColor
        centerRoundShape.fillColor = nil
        centerRoundShape.lineWidth = 3.0
        
//        centerRoundGradinentShape.colors = [Util.hexStringToUIColor(hex: "FF6F6F").cgColor,Util.hexStringToUIColor(hex: "419BF9").cgColor]
        centerRoundGradinentShape.colors = [UIColor.red.cgColor,ringBlue]
        centerRoundGradinentShape.frame = view.layer.frame
        
//        centerRoundGradinentShape.startPoint = CGPoint(x: 0.5, y: 1)
//        centerRoundGradinentShape.endPoint = CGPoint(x:0.5,y:0)
        view.layer.addSublayer(centerRoundGradinentShape)
        centerRoundGradinentShape.mask = centerRoundShape
        //centerRoundShape.frame = CGRectMake(0, 0, launchButton!.bounds.size.width/2.0 + 10, launchButton!.bounds.size.width/2.0 + 10)
        //self.launchButton?.layer.addSublayer(centerRoundShape)
        
        //view.layer.addSublayer(centerRoundShape)
        
        // start building animation path
        let startingPoint = CGPoint(x:self.launchButton!.center.x, y:self.launchButton!.center.y - radis)
        let orbit = CAKeyframeAnimation(keyPath:"position")
        orbit.duration = 5
        
        orbit.path = CGPath(ellipseIn: centerRoundShape.path!.boundingBoxOfPath,transform: nil)
        orbit.calculationMode = kCAAnimationPaced
        orbit.repeatCount = Float.infinity
        orbit.rotationMode = kCAAnimationRotateAuto;
        
        self.startAnimation = orbit
        
        
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        aView.layer.cornerRadius = aView.frame.size.width/2
        aView.backgroundColor = self.view.backgroundColor
        aView.clipsToBounds = true
        aView.layer.borderColor = self.ringBlue
        aView.layer.borderWidth = 2.0
        
        self.statusPointView = aView
        self.statusPointView.center = startingPoint
        self.view.addSubview(self.statusPointView)
        self.statusPointView.isHidden = true
        
    }

    @IBAction func launchButtonClicked(){
        if(self.animating)
        {
            self.blackBox.stopRecording()
            self.statusPointView.layer.removeAllAnimations()
            self.animating = false
            self.centerRoundShape.strokeColor = self.buttonGrey
            self.statusPointView.isHidden = true
            
            
//            UIView.animate(withDuration: 1.0, delay: 0.0,
//                                       usingSpringWithDamping: 0.25,
//                                       initialSpringVelocity: 0.0,
//                                       options: [],
//                                       animations: {
//                                        self.launchButton?.layer.position.y -= 100
//                                        self.centerRoundShape.position.y -= 100
//                                        
//                                        
//                }, completion: nil)
        }else
        {
            
            self.blackBox.startRecordingWithLoggingState()
            self.statusPointView.layer.add(self.startAnimation, forKey: "Move7")
            self.animating = true
            self.centerRoundShape.strokeColor = self.ringBlue
            self.statusPointView.isHidden = false
            
//            UIView.animate(withDuration: 1.0, delay: 0.0,
//                                       usingSpringWithDamping: 0.25,
//                                       initialSpringVelocity: 0.0,
//                                       options: [],
//                                       animations: {
//                                        self.launchButton?.center = self.view.center
//                                        if(self.startRecording)
//                                        {
//                                            self.centerRoundShape.position.y += 100
//                                            
//                                        }
//                                        
//                }, completion: nil)
            
            self.startRecording = true
        }
        
    }
    
    //MARK: - BlackBox
    func blackBoxEachSecondUpdate(_ duration: Double, distance: Double, speed: Double, heading: Double, altitude: Double)
    {
        // distance
        //let distanceInMiles = String(format: "%.2f", Util.distanceInMiles(distance))
        //print("distance:\(distanceInMiles)")
        launchButton?.titleLabel?.text = Util.timeString(duration)
        
        self.speedLabel?.text =  String(format: "%.1f mph", speed)
        
        if CMAltimeter.isRelativeAltitudeAvailable()
        {
            self.altitudeLabel?.text = altitude == DBL_MAX ? "-" : String(format: "%.2f", altitude);
        }else
        {
            self.altitudeLabel?.text = "-"
        }
        
        self.headingLabel?.text = String(format: "%.1f °", heading);
        //launchButton?.titleLabel?.textColor = UIColor.white
    }
    
    func locationManagerGetUpdated(_ newestLocations:CLLocation)
    {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
