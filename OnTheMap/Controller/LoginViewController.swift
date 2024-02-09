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
                if (success) {
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                } else {
                    self.presentAlert(message: error?.localizedDescription ?? "An error occurred during login, please try again")
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
        emailField.isEnabled = !isLoading
        passwordField.isEnabled = !isLoading
        loginButton.isEnabled = !isLoading
        signUpButton.isEnabled = !isLoading
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        print("onSignUp()")
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }

    func presentAlert(message: String) {
        setLoadingState(false)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

