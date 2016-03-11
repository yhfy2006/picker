//
//  ResultDisplayViewController.swift
//  TracePilot
//
//  Created by He, Changchen on 3/7/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import MapKit
import HealthKit

class ResultDisplayViewController: UIViewController,MKMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ResultChartCellDelegate{

    var traceEvent:TraceEvent?
    @IBOutlet var mapView: MKMapView!
    var mapAnotationView:MKAnnotationView?
    @IBOutlet var collectionView:UICollectionView?
    
    lazy var airPlanePin:AirPlanPointAnnotation = {
        var _airPlanePin = AirPlanPointAnnotation()
        _airPlanePin.imageName = "transport"
        return _airPlanePin
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        loadMap()
        if let firstLocation = self.traceEvent?.traceLocations.first
        {
            airPlanePin.coordinate = CLLocationCoordinate2DMake((firstLocation.locationLatitude), (firstLocation.locationLongitude))
            mapView.addAnnotation(airPlanePin)
        }

    }
    
    
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc = traceEvent!.traceLocations.first
        
        var minLat = initialLoc?.locationLatitude
        var minLng = initialLoc?.locationLongitude
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = traceEvent!.traceLocations
        
        for location in locations {
            minLat = min(minLat!, location.locationLatitude)
            minLng = min(minLng!, location.locationLongitude)
            maxLat = max(maxLat!, location.locationLatitude)
            maxLng = max(maxLng!, location.locationLongitude)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat! + maxLat!)/2,
                longitude: (minLng! + maxLng!)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat! - minLat!)*1.1,
                longitudeDelta: (maxLng! - minLng!)*1.1))
    }
    
    func loadMap() {
        if traceEvent?.traceLocations.count > 0 {
            mapView.hidden = false
            
            // Set the map bounds
            mapView.region = mapRegion()
            
            // Make the line(s!) on the map
            let colorSegments = MulticolorPolylineSegment.colorSegments(forLocations: (traceEvent?.traceLocations)!)
            mapView.addOverlays(colorSegments)
        } else {
            // No locations were found!
            mapView.hidden = true
            
            UIAlertView(title: "Error",
                message: "This flight has no locations saved",
                delegate:nil,
                cancelButtonTitle: "OK").show()
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MulticolorPolylineSegment
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 3
        return renderer
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is AirPlanPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! AirPlanPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        mapAnotationView = anView
        return anView
    }
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locations = traceEvent?.traceLocations
        for location in locations! {
            coords.append(CLLocationCoordinate2D(latitude: location.locationLatitude,
                longitude: location.locationLongitude))
        }
        
        return MKPolyline(coordinates: &coords, count: (locations?.count)!)
    }
    
    
    //Mark: - CollectionView
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
     {
       return 2
     }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
     {
        if indexPath.row == 0
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BasicInfoCell",forIndexPath: indexPath) as! ResultDiaplayCellBasicInfo
            cell.traceEvent = self.traceEvent
            cell.loadCell()
            return cell
        }else if indexPath.row == 1
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpeedChartCell",forIndexPath: indexPath) as! ChartCellSpeedCell
            cell.traceEvent = self.traceEvent
            cell.delegate = self
            cell.loadCell()
            
            return cell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize{

        return CGSizeMake(collectionView.bounds.width, collectionView.bounds.height)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }

    // MARK: -ResulstDiaplay chat delegate
    func didTapAtIndex(index: Int) {
        let location = self.traceEvent?.traceLocations[index]
        airPlanePin.coordinate = CLLocationCoordinate2DMake((location?.locationLatitude)!, (location?.locationLongitude)!)
        // handle image rotation
//        if let mapAnotationView = self.mapAnotationView
//        {
//            mapAnotationView.image = 
//        }
        
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

class AirPlanPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
