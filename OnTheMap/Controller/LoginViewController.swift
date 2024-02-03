//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 30/01/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("LoginViewController viewDidLoad()")
    }
    
    @IBAction func onLogin(_ sender: Any) {
        print("onLogin()")
        self.performSegue(withIdentifier: "showHome", sender: nil)
    }
    


}

