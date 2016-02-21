//
//  SoundTrackManager.swift
//  EZRecorder
//
//  Created by VincentHe on 2/20/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import EZAudio
import RealmSwift




class SoundTrackManager:NSObject,EZMicrophoneDelegate,EZRecorderDelegate{
    //EZAudio
    var playerArray:[EZAudioPlayer] = Array()
    var microphone: EZMicrophone?
    var recorder:EZRecorder?
    var isRecording = false
    var delegate:SoundTrackMangerDelegate?
    var currentIndex = 0
    let realm = try! Realm()
    var soundJob:SoundJob?
    
    init(soundJob:SoundJob) {
            super.init()
            self.soundJob = soundJob
            microphone = EZMicrophone.sharedMicrophone()
            microphone!.delegate = self
    }
    
    // MARK: - EZAudio
    @objc func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.delegate?.soundTrackStartedUpdated(microphone, hasAudioReceived: buffer, withBufferSize: bufferSize, withNumberOfChannels: numberOfChannels)
        });
    }
    
    @objc func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording
        {
            self.recorder?.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
            self.delegate?.soundTrackStartedUpdated(microphone, hasBufferList: bufferList, withBufferSize: bufferSize, withNumberOfChannels: numberOfChannels)
        }
    }
    
    func startRecord()
    {
        let fileId = Util.getRamdonFileName()
        let filePathString = Util.getAudioDirectory()+"/\(fileId)"
        let audioFileUrl = NSURL(fileURLWithPath: filePathString)
        let sound = Sound()
        sound.fileId = fileId
        sound.isRecording = true
        try! realm.write{
            if self.soundJob?.sounds.count <= self.currentIndex
            {
                self.soundJob?.sounds.append(sound)
            }
            else
            {
                self.soundJob?.sounds[currentIndex] = sound
            }
        }
        self.recorder = EZRecorder(URL: audioFileUrl, clientFormat: self.microphone!.audioStreamBasicDescription(), fileType: EZRecorderFileType.M4A, delegate: self)
        self.microphone?.startFetchingAudio()
        self.isRecording = true
        self.delegate?.soundTrackStartedRecord(self.currentIndex)
    }
    
    func stopRecord()
    {
        self.microphone?.stopFetchingAudio()
        self.isRecording = false
        self.recorder?.closeAudioFile()
        try! realm.write{
            self.soundJob?.sounds[currentIndex].isRecording = false
        }
        delegate?.soundTrackStopRecordWithIndex(self.currentIndex)
    }
    
    
    func getRandomAudioFilePath() ->String
    {
        let path = Util.getAudioDirectory() + "/" + Util.getRamdonFileName()
        print(path)
        return path
    }
}

protocol SoundTrackMangerDelegate {
    
    func soundTrackStartedRecord(index:Int)
    
    func soundTrackStartedUpdated(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32)
    func soundTrackStartedUpdated(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32)
    func soundTrackStopRecordWithIndex(index:Int)

}
