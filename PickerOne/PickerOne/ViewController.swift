//
//  ViewController.swift
//  PickerOne
//
//  Created by VincentHe on 2/4/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
//
//    @IBOutlet var collectionView:UICollectionView?
//    
//    private let reuseIdentifierForStory = "JobPageItemCell"
//    private let reuseIdentifierForEmpty = "JobPageEmptyItemCell"
//    
//    private var pickerJobs:Results<PickerJob>?
//    
//    private let sectionInsets = UIEdgeInsets(top:0, left: 0.0, bottom: 0.0, right: 0.0)
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Get the default Realm
//        let realm = try! Realm()
//        
////        let pickerJob = PickerJob()
////        pickerJob.title = "where to travel"
////        pickerJob.id = pickerJob.IncrementaID()
////                try! realm.write {
////                    realm.add(pickerJob)
////                }
//       
//        
//        self.pickerJobs = realm.objects(PickerJob)
//        //self.pickerJobs = realm.objects(PickerJob)
//
//        print(Realm.Configuration.defaultConfiguration.path)
//        
//
//        
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        
//        return 1;
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        if let jobs = pickerJobs{
//            return jobs.count
//        }else{
//            return 1
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
////        if let jobs = pickerJobs{
////            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierForStory, forIndexPath: indexPath) as! MainCollectionViewCells
////        }else{
////            return 1
////        }
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierForStory, forIndexPath: indexPath) as! MainCollectionViewCells
//        cell.pickJob = pickerJobs![indexPath.row]
//        cell.loadContent()
//        return cell
//    }
//    
//
//}
//
//extension ViewController : UICollectionViewDelegateFlowLayout {
//    //1
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//            
//            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
//    }
//    
//    //3
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//            return sectionInsets
//    }
}

