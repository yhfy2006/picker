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



class MainViewController: UIViewController,SoundTrackMangerDelegate ,EZMicrophoneDelegate,EZRecorderDelegate,EZAudioPlayerDelegate{

    @IBOutlet var tableView:UITableView?
    @IBOutlet var startRecordingButton:UIButton?
    @IBOutlet var addTrackButton:UIButton?
    
    var soundNumber = 0
    var isRecording = false
    
    var soundJob:SoundJob?
    var soundCellCache:[MainTableSoundViewCell] = Array()
    
    var soundTrackManager:SoundTrackManager?
    


    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView?.separatorInset = UIEdgeInsetsZero;
        self.edgesForExtendedLayout = UIRectEdge.None
        

        
        self.soundJob = realm.objects(SoundJob).first
        
        soundTrackManager = SoundTrackManager(soundJob: self.soundJob!)
        soundTrackManager?.delegate = self
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
        
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("soundCell", forIndexPath: indexPath) as! MainTableSoundViewCell
        cell.sound = soundJob?.sounds[indexPath.row]
        print("\(indexPath.row) \(cell.sound?.fileId)")
        cell.loadCell()
        cell.index = indexPath.row
        if self.soundTrackManager?.currentIndex == indexPath.row
        {
            cell.setSelectedBoarder()
        }else
        {
            cell.removeSelectedBoarderCell()
        }
        soundCellCache.append(cell);
        return cell
        

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let recordingIndex = self.soundTrackManager?.currentIndex
        let oldIndexPath = NSIndexPath(forRow: recordingIndex!, inSection: 0)
        let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath) as! MainTableSoundViewCell
        oldCell.removeSelectedBoarderCell()
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MainTableSoundViewCell
        cell.setSelectedBoarder()
        self.soundTrackManager?.currentIndex = indexPath.row
        
    }
    
        
    @IBAction func startOrStopRecording()
    {
        if isRecording
        {
            isRecording = false
            soundTrackManager?.stopRecord()
            self.startRecordingButton?.setTitle("Record", forState: .Normal)
        }
        else
        {
            isRecording = true
            soundTrackManager?.startRecord()
            self.startRecordingButton?.setTitle("Stop", forState: .Normal)
        }
        

    }
    
    @IBAction func addTrack()
    {
        let newIndex = soundJob?.sounds.count
        soundTrackManager?.currentIndex = newIndex!
        // add an empty sound to add the new track
        try! realm.write{
            self.soundJob?.sounds.append(Sound())
        }
        self.tableView?.reloadData()
    }
    
    @IBAction func playTrack()
    {
        self.soundTrackManager?.playCurrentSelectedTrack()
    }
    
    //Mark: Sound track manager
    
    func soundTrackStartedRecord(index: Int) {
        self.tableView?.reloadData()
    }
    
    func soundTrackStartedUpdated(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        let recordingIndex = self.soundTrackManager?.currentIndex
        let indexPath = NSIndexPath(forRow: recordingIndex!, inSection: 0)
        let cell = tableView!.cellForRowAtIndexPath(indexPath) as! MainTableSoundViewCell
        cell.recordingAudioPlot?.updateBuffer(buffer[0], withBufferSize: bufferSize)
        
    }
    
    func soundTrackStartedUpdated(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
    }
    
    func soundTrackStopRecordWithIndex(index: Int) {
        self.tableView?.reloadData()
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
