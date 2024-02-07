//
//  LocationDetailsViewController.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 07/02/24.
//

import UIKit
import CoreLocation
import MapKit

class LocationDetailsViewController: UIViewController, MKMapViewDelegate {
    
    var locationName: String!
    var coordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        print("LocationDetailsViewController viewDidLoad() coordinates \(coordinates)")
        
        mapView.delegate = self
        
        navigationItem.title = "Add Location"
        
        loadNewLocation()
    }
    
    func loadNewLocation() {
        var annotations = [MKPointAnnotation]()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = locationName

        annotations.append(annotation)
    
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.glyphTintColor = .white
            pinView!.markerTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func onFinish(_ sender: Any) {
        print("onFinish()")
    }
    
}
