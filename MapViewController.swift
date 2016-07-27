//
//  MapViewController.swift
//  FoodPin
//
//  Created by Yapzi on 16/5/22.
//  Copyright © 2016年 Yap. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var restaurant: Restaurant!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: {placemarks, error in
            if error != nil {
                print(error)
            } else {
                if placemarks?.count != 0  {
                    let placemark = placemarks![0]
                    let annotation = MKPointAnnotation()
                    if let location = placemark.location {
                        annotation.title = self.restaurant.name
                        annotation.subtitle = self.restaurant.type
                        annotation.coordinate = location.coordinate
                        self.mapView.showAnnotations([annotation], animated: true)
                        self.mapView.selectAnnotation(annotation, animated: true)

                    }
                }
            }
        })
        self.mapView.showsCompass = true
        self.mapView.showsTraffic = true
        self.mapView.showsScale = true
        // Do any additional setup after loading the view.
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation.isKindOfClass(MKUserLocation) else {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("myPin") as? MKPinAnnotationView
            if pin == nil {
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
                pin?.canShowCallout = true
            }
            let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
            leftIconView.image = UIImage(data: restaurant.image!)
            pin?.leftCalloutAccessoryView = leftIconView
            pin?.pinTintColor = UIColor.blackColor()
            return pin
        }
        return nil
//        let identifier = "MyPin"
//        if annotation.isKindOfClass(MKUserLocation) {
//            return nil
//        }
//        // Reuse the annotation if possible
//        var annotationView:MKPinAnnotationView? =
//            mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as?
//        MKPinAnnotationView
//        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
//        }
//        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
//        leftIconView.image = UIImage(named: restaurant.image)
//        annotationView?.leftCalloutAccessoryView = leftIconView
//        return annotationView
    }

    override func viewWillAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
