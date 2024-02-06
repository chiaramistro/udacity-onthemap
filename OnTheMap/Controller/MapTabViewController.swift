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
        
        // Set navigation bar preferences
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addLocation)),
            UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh)),
            ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        navigationItem.title = "On The Map"
        
        UdacityClient.getStudentLocations { studentLocations, error in
            print("getStudentLocations result: \(studentLocations)")
            StudentsModel.sharedInstance().students = studentLocations
        }
    }
    
    @objc func addLocation() {
        print("addLocation()")
        // TODO
    }
    
    @objc func refresh() {
        print("refresh()")
        // TODO
    }
    
    @objc func logout() {
        print("logout()")
        // TODO
    }

    }
    
}

