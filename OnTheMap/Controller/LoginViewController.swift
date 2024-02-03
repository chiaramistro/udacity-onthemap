//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 30/01/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("LoginViewController viewDidLoad()")
    }
    
    @IBAction func onLogin(_ sender: Any) {
        print("onLogin()")
        
        if (emailField.text?.isEmpty ?? true || passwordField?.text?.isEmpty ?? true) {
           return
        }
        
        setLoadingState(true)
        UdacityClient.createSession(username: emailField.text!, password: passwordField.text!) { success, error in
            print("createSession() success \(success) \(UdacityClient.Auth.sessionId)")
            DispatchQueue.main.async {
                self.setLoadingState(false)
                self.performSegue(withIdentifier: "showHome", sender: nil)
            }
        }
    }
    
    func setLoadingState(_ isLoading: Bool) {
        if (isLoading) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailField.isEnabled = !isLoading
        passwordField.isEnabled = !isLoading
        loginButton.isEnabled = !isLoading
        signUpButton.isEnabled = !isLoading
    }
    


}

