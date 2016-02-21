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
    var audioFile:EZAudioFile?
    var sound:Sound?
    var index:Int?
    var isloaded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //self.setSelectedBoarder()
        // Configure the view for the selected state
    }
    
    
    func setSelectedBoarder()
    {
        self.recordingAudioPlot?.layer.borderWidth = 2
        self.recordingAudioPlot?.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func removeSelectedBoarderCell()
    {
        self.recordingAudioPlot?.layer.borderWidth = 0
        self.recordingAudioPlot?.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func loadCell()
    {
        if isloaded
        {
            return
        }
        self.recordingAudioPlot?.backgroundColor = UIColor(red: 0.984, green: 0.71 ,blue: 0.365 ,alpha: 1)
        self.recordingAudioPlot?.color = UIColor(red: 1.0, green: 1.0 ,blue: 1.0 ,alpha: 1)
        self.recordingAudioPlot?.shouldFill = true
        self.recordingAudioPlot?.shouldMirror = true
        self.recordingAudioPlot?.gain = 10
        
        if let fileId = self.sound?.fileId
        {
            if self.sound?.isRecording == false
            {
                if fileId != "" {
                    self.recordingAudioPlot?.plotType = EZPlotType.Buffer
                    let filePath = Util.getAudioDirectory()+"/\(fileId)"
                    let fileUrl = NSURL(fileURLWithPath:filePath)
                    audioFile = EZAudioFile(URL: fileUrl)
                    let formdata = audioFile?.getWaveformData()
                    self.recordingAudioPlot?.updateBuffer((formdata?.buffers[0])!, withBufferSize: UInt32((formdata?.bufferSize)!))
                    print("index \(self.index) \(fileId)")
                    self.isloaded = true
                }else
                {
                    self.recordingAudioPlot?.clear()
                }
            }else
            {
                self.recordingAudioPlot?.plotType = EZPlotType.Rolling
            }
        }
        
    }
}
