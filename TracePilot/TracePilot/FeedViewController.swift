//
//  HistoryViewController.swift
//  TracePilot
//
//  Created by He, Changchen on 3/3/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import RealmSwift


class FeedViewController: UIViewController {
    @IBOutlet var collectionView:UICollectionView?
    
    let traceEvents =  try! Array(Realm().objects(TraceEvent))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    //Mark: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return traceEvents.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("traceEventCell",forIndexPath: indexPath) as! FeedViewNormalCell
        let traceEvent = traceEvents[indexPath.row]
        cell.traceEvent = traceEvent
        cell.loadCell()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize{
        
        return CGSizeMake(collectionView.bounds.width, 50)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let traceEvent = traceEvents[indexPath.row]
        self.performSegueWithIdentifier("goToResultView", sender:traceEvent)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "goToResultView")
        {
            
            let controller = (segue.destinationViewController as! ResultDisplayViewController)
            controller.traceEvent = sender as? TraceEvent
        }
    }
}
