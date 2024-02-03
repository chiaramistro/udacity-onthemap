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

    }
    
}
