//
//  EditFlightViewController.swift
//  TracePilot
//
//  Created by He, Changchen on 3/3/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import RealmSwift

class EditFlightViewController: UIViewController {

    @IBOutlet var picTakingButton:UIButton?
    @IBOutlet var flightNameField:UITextField?
    @IBOutlet var flightCommentView:UITextView?
    
    @IBOutlet var commitButton:UIButton?
    @IBOutlet var discardButton:UIButton?
    
    // DB store
    var traceEvent:TraceEvent?
    
    var delegate:EditFlightViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func discard(sender:UIButton)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.delegate?.editDidDiscard()
        }
    }
    
    @IBAction func commit(sender:UIButton)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
//            try! Realm().write{
//               self.traceEvent?.title = (self.flightNameField?.text)!
//               self.traceEvent?.selfDecsription = (self.flightCommentView?.text)!
//            }
            
            self.delegate?.editDidCommit(self.flightNameField?.text,flightComment: self.flightCommentView?.text)
        }
    }
    
}

protocol EditFlightViewDelegate {
    func editDidDiscard()
    func editDidCommit(flightName:String?,flightComment:String?)
}