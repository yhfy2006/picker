//
//  CameraViewController.swift
//  TracePilot
//
//  Created by He, Changchen on 11/16/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet var cPreviewView:UIView?
    @IBOutlet var shutterButton:UIButton?
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.session = AVCaptureSession()
        self.session!.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && self.session!.canAddInput(input) {
            self.session!.addInput(input)
        }
        
        self.stillImageOutput = AVCaptureStillImageOutput()
        self.stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        if self.session!.canAddOutput(self.stillImageOutput) {
            self.session!.addOutput(self.stillImageOutput)
            
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            self.videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
            self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            self.videoPreviewLayer!.frame = UIScreen.main.bounds
            self.cPreviewView?.layer.addSublayer(self.videoPreviewLayer!)
            self.session!.startRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTakePhoto(){
        
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
