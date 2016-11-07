//
//  LoggingViewController.swift
//  TracePilot
//
//  Created by He, Changchen on 11/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit

class LoggingViewController: UIViewController {

    let centerRoundShape = CAShapeLayer()
    let centerRoundGradinentShape = CAGradientLayer()
    var statusPointView = UIView()
    var startAnimation = CAKeyframeAnimation(keyPath: "position")
    
    var startRecording = false
    var animating = false
    
    let ringBlue = Util.hexStringToUIColor(hex: "25BFF0").cgColor
    let buttonGrey = Util.hexStringToUIColor(hex: "979797").cgColor
    
    @IBOutlet var launchButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        centerRoundShape.strokeColor = UIColor.white.cgColor
        centerRoundShape.fillColor = nil
        centerRoundShape.lineWidth = 3.0
        
//        centerRoundGradinentShape.colors = [Util.hexStringToUIColor(hex: "FF6F6F").cgColor,Util.hexStringToUIColor(hex: "419BF9").cgColor]
        centerRoundGradinentShape.colors = [ringBlue,UIColor.red.cgColor]
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
            self.statusPointView.layer.removeAllAnimations()
            self.animating = false
            self.centerRoundShape.strokeColor = self.buttonGrey
            self.statusPointView.isHidden = true
            
            
            //            UIView.animateWithDuration(.5, animations: {
            //                self.launchButton?.layer.position.y -= 100
            //                self.centerRoundShape.position.y -= 100
            //            })
            
            UIView.animate(withDuration: 1.0, delay: 0.0,
                                       usingSpringWithDamping: 0.25,
                                       initialSpringVelocity: 0.0,
                                       options: [],
                                       animations: {
                                        //                                        self.centerRoundShape.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
                                        //                                        self.launchButton?.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
                                        self.launchButton?.layer.position.y -= 100
                                        self.centerRoundShape.position.y -= 100
                                        
                                        
                }, completion: nil)
        }else
        {
            
            self.statusPointView.layer.add(self.startAnimation, forKey: "Move7")
            self.animating = true
            self.centerRoundShape.strokeColor = self.ringBlue
            self.statusPointView.isHidden = false
            
            UIView.animate(withDuration: 1.0, delay: 0.0,
                                       usingSpringWithDamping: 0.25,
                                       initialSpringVelocity: 0.0,
                                       options: [],
                                       animations: {
                                        self.launchButton?.center = self.view.center
                                        if(self.startRecording)
                                        {
                                            self.centerRoundShape.position.y += 100
                                            //                                            self.launchButton?.layer.transform = CATransform3DMakeScale(1, 1, 1.0)
                                            //                                            self.centerRoundShape.transform = CATransform3DMakeScale(1, 1, 1.0)
                                            
                                        }
                                        
                }, completion: nil)
            
            
            //            UIView.animateWithDuration(1.0, animations: {
            //                self.launchButton?.center = self.view.center
            //                if(self.startRecording)
            //                {
            //                   self.centerRoundShape.position.y += 100
            //                }
            //            })
            
            self.startRecording = true
        }
        
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
