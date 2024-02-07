//
//  MapTabViewController.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 31/01/24.
//

import UIKit
import MapKit

class MapTabViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        print("MapTabViewController viewDidLoad()")
        
        mapView.delegate = self
        
        // Set navigation bar preferences
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addLocation)),
            UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh)),
            ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        navigationItem.title = "On The Map"
        
        UdacityClient.getStudentLocations { studentLocations, error in
            self.handleStudentLocations(studentLocations: studentLocations, error: error)
        }
    }
    
    // MARK: - Navigation functions
    
    @objc func addLocation() {
        print("addLocation()")
        self.performSegue(withIdentifier: "addLocation", sender: nil)
    }
    
    @objc func refresh() {
        print("refresh()")
        // TODO
    }
    
    @objc func logout() {
        print("logout()")
        UdacityClient.endSession { logoutSuccess, error in
            DispatchQueue.main.async {
                if (logoutSuccess) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showFailureAlert(message: "Some error occurred during logout")
                }
            }
        }
    }
    
    func handleStudentLocations(studentLocations: [StudentInformation], error: Error?) {
        // FIXME display error
        print("getStudentLocations result: \(studentLocations)")
        StudentsModel.sharedInstance().students = studentLocations
        self.loadLocations()
    }

    func showFailureAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadLocations() {
        var annotations = [MKPointAnnotation]()
        
        for studentInfo in StudentsModel.sharedInstance().students {
            let lat = CLLocationDegrees(studentInfo.latitude)
            let long = CLLocationDegrees(studentInfo.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentInfo.firstName
            let last = studentInfo.lastName
            let mediaURL = studentInfo.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    // MARK: - Map view delegate methods
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let subtitle = view.annotation?.subtitle! {
                if let toOpen = URL(string: subtitle) {
                    if UIApplication.shared.canOpenURL(toOpen as URL) {
                        print("The url is valid")
                        UIApplication.shared.open(toOpen, options: [:], completionHandler: nil)
                    } else {
                        print("The url is not valid")
                    }
                }
            }
        }
    }
    
}

