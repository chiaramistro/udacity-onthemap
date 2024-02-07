//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 06/02/24.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        print("AddLocationViewController viewDidLoad()")
        
        navigationItem.title = "Add Location"
    }
    
    @IBAction func onFindLocation(_ sender: Any) {
        print("onFindLocation()")
        
        setLoadingState(true)
        
        if (linkField?.text?.isEmpty ?? true) {
            presentAlert(message: "Link field is empty")
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationField?.text ?? "", completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                self.presentAlert(message: "Some error occurred during geocoding")
                return
            }
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                self.setLoadingState(false)
                let detailController = self.storyboard!.instantiateViewController(withIdentifier: "LocationDetailsViewController") as! LocationDetailsViewController
                detailController.locationName = self.locationField?.text ?? "New location"
                detailController.coordinates = coordinates
                self.navigationController!.pushViewController(detailController, animated: true)
           }
         })
    }
    
    func setLoadingState(_ isLoading: Bool) {
        if (isLoading) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        locationField.isEnabled = !isLoading
        linkField.isEnabled = !isLoading
        findLocationButton.isEnabled = !isLoading
    }
    
    func presentAlert(message: String) {
        setLoadingState(false)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
