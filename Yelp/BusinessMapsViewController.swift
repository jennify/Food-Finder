//
//  BusinessMapsViewController.swift
//  Yelp
//
//  Created by Jennifer Lee on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class BusinessMapsViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var businesses: [Business]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        var num = 0
        var maxMinLatitude: [String: Double]! = [
            "min": Double.infinity,
            "max": -Double.infinity,
        ]
        var maxMinLongtitude: [String: Double]! = [
            "min": Double.infinity,
            "max": -Double.infinity,
        ]
        
        for business in self.businesses {
            if business.lattitude != nil && business.longitude != nil {
                addAnnotationAtCoordinate("\(num)" , coordinate: CLLocationCoordinate2D(latitude: business.lattitude!, longitude: business.longitude!))
                maxMinLatitude["min"] = min(maxMinLatitude["min"]!, business.lattitude!)
                maxMinLatitude["max"] = max(maxMinLatitude["max"]!, business.lattitude!)
                maxMinLongtitude["min"] = min(maxMinLongtitude["min"]!, business.longitude!)
                maxMinLongtitude["max"] = max(maxMinLongtitude["max"]!, business.longitude!)
                
            }
            num++
        }
        let widerDelta = 0.01
        
        let span = MKCoordinateSpanMake(maxMinLatitude["max"]! - maxMinLatitude["min"]! + widerDelta, maxMinLongtitude["max"]! - maxMinLongtitude["min"]! + widerDelta)
        
        let centerLat: Double = (maxMinLatitude["max"]! + maxMinLatitude["min"]!) / 2
        let centerLong: Double = (maxMinLongtitude["max"]! + maxMinLongtitude["min"]!)/2
        let center = CLLocation(latitude: centerLat, longitude: centerLong)
        goToLocationWithSpan(center, span: span)
    
        
    }
    
    func addAnnotationAtCoordinate(title: String?, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        if title != nil {
            annotation.title = title
        }
        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func goToLocationWithSpan(location: CLLocation, span:MKCoordinateSpan) {
        
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
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
