//
//  ViewController.swift
//  EZRecorder
//
//  Created by VincentHe on 2/13/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import EZAudio

class ViewController: UIViewController,EZMicrophoneDelegate,EZRecorderDelegate,EZAudioPlayerDelegate {

    @IBOutlet var start1:UIButton?
    @IBOutlet var start2:UIButton?
    
    @IBOutlet var stop1:UIButton?
    @IBOutlet var stop2:UIButton?
    

    
    @IBOutlet var button:UIButton?
    
    var microphone: EZMicrophone?
    var recorder:EZRecorder?
    var isRecording = false
    var player1:EZAudioPlayer?
    var player2:EZAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        microphone = EZMicrophone.sharedMicrophone()
        microphone!.delegate = self
        player1  = EZAudioPlayer(delegate:self)
        player2 = EZAudioPlayer(delegate:self)
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording
        {
            self.recorder?.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }
    }
    
    @IBAction func start(sender:UIButton)
    {
        self.microphone!.startFetchingAudio()
        self.isRecording = true

//        if sender.tag == 1
//        {
//            audioFileUrl =
//
//        }else
//        {
//            
//        }
        
        let audioFileUrl = self.testFilePathURL(sender.tag)
        
        
        recorder = EZRecorder(URL: audioFileUrl, clientFormat: self.microphone!.audioStreamBasicDescription(), fileType: EZRecorderFileType.M4A, delegate: self)

    }
    
    @IBAction func stop(sender:UIButton)
    {
        self.microphone!.stopFetchingAudio()
        self.isRecording = false
        if sender.tag == 1
        {

        }else
        {
            
        }
        
        self.recorder?.closeAudioFile()

    }
    
    @IBAction func play(sender:UIButton)
    {
        if sender.tag == 1 || sender.tag == 2
        {
            let audioFile = EZAudioFile(URL: testFilePathURL(sender.tag))
            if sender.tag == 1
            {
                self.player1?.audioFile = audioFile
                self.player1?.play()
            }else
            {
                self.player2?.audioFile = audioFile
                self.player2?.play()
            }
        }else
        {
            let audioFile1 = EZAudioFile(URL: testFilePathURL(1))
            let audioFile2 = EZAudioFile(URL: testFilePathURL(2))

            self.player1?.audioFile = audioFile1
            self.player2?.audioFile = audioFile2
            
            self.player1?.play()
            self.player2?.play()
            
        }
    }
    
    func applicationDocumentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! String
        print(documentsDirectory)
        return documentsDirectory
    }
    
    func testFilePathURL(tag:Int)-> NSURL{
        return NSURL(fileURLWithPath: applicationDocumentsDirectory()+"/"+String(tag)+".m4a")
    }
    
    
    
    
    func recorderDidClose(recorder: EZRecorder!) {
        recorder.delegate = nil
    }
    
    func recorderUpdatedCurrentTime(recorder: EZRecorder!) {
        
    }
    

    
}

