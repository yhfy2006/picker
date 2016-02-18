//
//  ExperimentViewController.swift
//  PickerOne
//
//  Created by VincentHe on 2/13/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import EZAudio

class ExperimentViewController: UIViewController,EZMicrophoneDelegate {
    @IBOutlet var start1:UIButton?
    @IBOutlet var start2:UIButton?
    
    @IBOutlet var stop1:UIButton?
    @IBOutlet var stop2:UIButton?
    
    @IBOutlet var button:UIButton?
    
    var microphone: EZMicrophone!;

    override func viewDidLoad() {
        super.viewDidLoad()
        microphone = EZMicrophone(delegate: self, startsImmediately: false);

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //plot?.updateBuffer(buffer[0], withBufferSize: bufferSize);
        });
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
