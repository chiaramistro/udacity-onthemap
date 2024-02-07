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
    
    var locationLink: String!
    var locationName: String!
    var coordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        setLoadingState(true)
        
        UdacityClient.getUserData(userId: UdacityClient.Auth.userId) { success, error in
            print("getUserData() success \(success)")
            DispatchQueue.main.async {
                if (success) {
                    self.proceedWithAddingLocation()
                } else {
                    // FIXME custom response error
                    self.presentAlert(message: "Some error occurred while retrieving user info")
                }
            }
        }
    }
    
    func proceedWithAddingLocation() {
        let newStudentInfo = StudentInformation(objectId: "", uniqueKey: "", firstName: UserModel.sharedInstance().user.firstName, lastName: UserModel.sharedInstance().user.lastName, mapString: locationName, mediaURL: locationLink, latitude: Float(coordinates.latitude), longitude: Float(coordinates.longitude), createdAt: "", updatedAt: "")
        print("proceedWithAddingLocation() newStudentInfo \(newStudentInfo)")
        UdacityClient.addNewStudentLocation(newStudentLoc: newStudentInfo) { success, error in
            DispatchQueue.main.async {
                if (success) {
                    print("Location added successfully")
                    self.setLoadingState(false)
                    self.dismiss(animated: true, completion: nil)
                    // FIXME navigation
                } else {
                    // FIXME custom response error
                    self.presentAlert(message: "Some error occurred while adding new location")
                }
            }
        }
    }
    
    func setLoadingState(_ isLoading: Bool) {
        if (isLoading) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        finishButton.isEnabled = !isLoading
    }
    
    func presentAlert(message: String) {
        setLoadingState(false)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
