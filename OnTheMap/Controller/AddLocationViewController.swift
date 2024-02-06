//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 06/02/24.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    
    override func viewDidLoad() {
        print("AddLocationViewController viewDidLoad()")
    }
    
    @IBAction func onFindLocation(_ sender: Any) {
        print("onFindLocation()")
        // TODO
    }
    
}
