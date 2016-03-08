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

class ResultDisplayViewController: UIViewController,MKMapViewDelegate {

    var traceEvent:TraceEvent?
    @IBOutlet var mapView: MKMapView!

    
    override func viewDidLoad() {
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
                message: "Sorry, this run has no locations saved",
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
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locations = traceEvent?.traceLocations
        for location in locations! {
            coords.append(CLLocationCoordinate2D(latitude: location.locationLatitude,
                longitude: location.locationLongitude))
        }
        
        return MKPolyline(coordinates: &coords, count: (locations?.count)!)
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
