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
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    //Mark: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return traceEvents.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "traceEventCell",for: indexPath) as! FeedViewNormalCell
        let traceEvent = traceEvents[indexPath.row]
        cell.traceEvent = traceEvent
        cell.loadCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: IndexPath!) -> CGSize{
        
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath)
    {
        let traceEvent = traceEvents[indexPath.row]
        self.performSegue(withIdentifier: "goToResultView", sender:traceEvent)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "goToResultView")
        {
            
            let controller = (segue.destination as! ResultDisplayViewController)
            controller.traceEvent = sender as? TraceEvent
        }
    }
}
