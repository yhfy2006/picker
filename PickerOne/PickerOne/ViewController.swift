//
//  ViewController.swift
//  PickerOne
//
//  Created by VincentHe on 2/4/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerJob = PickerJob()
        pickerJob.id = pickerJob.IncrementaID()
        // Get the default Realm
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.path)
        
        try! realm.write {
            realm.add(pickerJob)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

