//
//  MainTableViewCells.swift
//  EZRecorder
//
//  Created by VincentHe on 2/20/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import EZAudio

class MainTableSoundViewCell: UITableViewCell {
    
    @IBOutlet var recordingAudioPlot:EZAudioPlotGL?
    var isRecording = false;
    var audioFilePath:String?
    var audioFile:EZAudioFile?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadCell()
    {
        self.recordingAudioPlot?.backgroundColor = UIColor(red: 0.984, green: 0.71 ,blue: 0.365 ,alpha: 1)
        self.recordingAudioPlot?.color = UIColor(red: 1.0, green: 1.0 ,blue: 1.0 ,alpha: 1)
        self.recordingAudioPlot?.plotType = EZPlotType.Rolling
        self.recordingAudioPlot?.shouldFill = true
        self.recordingAudioPlot?.shouldMirror = true
        
        if let filePath = self.audioFilePath
        {
            if !self.isRecording
            {
                let fileUrl = NSURL(fileURLWithPath: "/Users/vincentnewpro/Library/Developer/CoreSimulator/Devices/C908F5A9-C058-48F7-A366-90B7C60A5E1C/data/Containers/Data/Application/E2063A0F-3BA5-438B-961A-DEDE48A5C98B/Documents/1.m4a")
                self.audioFile = EZAudioFile(URL: fileUrl)
                
                self.audioFile?.getWaveformDataWithCompletionBlock({ (waveformData, length) -> Void in
                    let buffer = waveformData[0]
                    self.recordingAudioPlot?.updateBuffer(buffer, withBufferSize: UInt32(length))
                })
            }
        }
        
    }
}
