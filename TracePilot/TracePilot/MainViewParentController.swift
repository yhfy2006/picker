//
//  ViewController.swift
//  TracePilot
//
//  Created by VincentHe on 3/1/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit

class ViewController: UIPageViewController {

    @IBOutlet var containerViewSession:UIView?
    @IBOutlet var containerViewHistoryView:UIView?
    
    var sessionVC: UIViewController?
    var historyVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionVC = R.storyboard.main.sessionVC
        historyVC = R.storyboard.main.historyVC
        setVCForIndex(0);
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        setVCForIndex(sender.selectedSegmentIndex)
    }
    
    func setVCForIndex(index: Int) {
        setViewControllers([index == 0 ? sessionVC! : historyVC!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
}


extension ViewController : UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController == sessionVC { return historyVC } else { return nil }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController == historyVC { return sessionVC } else { return nil }
    }
}
