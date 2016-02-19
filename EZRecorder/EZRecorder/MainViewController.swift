//
//  MainViewController.swift
//  EZRecorder
//
//  Created by He, Changchen on 2/19/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import EZAudio


class MainViewController: UIViewController ,EZMicrophoneDelegate,EZRecorderDelegate,EZAudioPlayerDelegate{

    @IBOutlet var tableView:UITableView?
    @IBOutlet var startRecordingButton:UIButton?
    
    var soundNumber = 0
    var isRecording = false
    
    //EZAudio
    var playerArray:[EZAudioPlayer] = Array()
    var microphone: EZMicrophone?
    var recorder:EZRecorder?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        microphone = EZMicrophone.sharedMicrophone()
        microphone!.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundNumber;
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("soundCell")
        return cell!

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - EZAudio
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //plot?.updateBuffer(buffer[0], withBufferSize: bufferSize);
        });
    }
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording
        {
            self.recorder?.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }
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
