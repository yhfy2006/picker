//
//  MainViewController.swift
//  EZRecorder
//
//  Created by He, Changchen on 2/19/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import EZAudio
import RealmSwift


class MainViewController: UIViewController ,EZMicrophoneDelegate,EZRecorderDelegate,EZAudioPlayerDelegate{

    @IBOutlet var tableView:UITableView?
    @IBOutlet var startRecordingButton:UIButton?
    
    var soundNumber = 0
    var isRecording = false
    
    var soundJob:SoundJob?
    var soundCellCache:[MainTableSoundViewCell] = Array()
    
    //EZAudio
    var playerArray:[EZAudioPlayer] = Array()
    var microphone: EZMicrophone?
    var recorder:EZRecorder?

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView?.separatorInset = UIEdgeInsetsZero;
        self.edgesForExtendedLayout = UIRectEdge.None
        
        microphone = EZMicrophone.sharedMicrophone()
        microphone!.delegate = self
        
        self.soundJob = realm.objects(SoundJob).first
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let soundJob = self.soundJob
        {
            return soundJob.sounds.count
        }else
        {
            return 0
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("soundCell") as! MainTableSoundViewCell
        cell.audioFilePath = soundJob!.sounds[indexPath.row].filePath
        cell.loadCell()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - EZAudio
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //plot?.updateBuffer(buffer[0], withBufferSize: bufferSize);
            let cell = self.soundCellCache.last
            cell?.recordingAudioPlot?.updateBuffer(buffer[0], withBufferSize: bufferSize)
        });
    }
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording
        {
            self.recorder?.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }
    }
    
    @IBAction func startOrStopRecording()
    {
        if isRecording
        {
            isRecording = false
            self.microphone!.stopFetchingAudio()
            self.recorder?.closeAudioFile()
            self.startRecordingButton?.setTitle("Record", forState: .Normal)
            
            let cell = self.soundCellCache.last
            cell?.isRecording = false
            self.tableView?.reloadData()
        }
        else
        {
            isRecording = true
            self.microphone!.startFetchingAudio()
            self.isRecording = true
            
            let filePathString = self.getRandomAudioFilePath()
            let audioFileUrl = NSURL(fileURLWithPath: filePathString)
            let sound = Sound()
            sound.filePath = filePathString
            try! realm.write{
                self.soundJob?.sounds.append(sound)
            }
            self.tableView?.reloadData()
            
            recorder = EZRecorder(URL: audioFileUrl, clientFormat: self.microphone!.audioStreamBasicDescription(), fileType: EZRecorderFileType.M4A, delegate: self)
            self.startRecordingButton?.setTitle("Stop", forState: .Normal)
        }
        

    }
    
    func getRandomAudioFilePath() ->String
    {
        let path = Util.getAudioDirectory() + "/" + Util.getRamdonFileName()
        print(path)
        return path
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
