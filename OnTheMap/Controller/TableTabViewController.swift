//
//  TableTabViewController.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 31/01/24.
//

import UIKit

class TableTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("TableTabViewController viewDidLoad()")
        
        // Set navigation bar preferences
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addLocation)),
            UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh)),
            ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        navigationItem.title = "On The Map"
        
        tableView.dataSource = self
        tableView.delegate = self
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
    
    func showFailureAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsModel.sharedInstance().students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as! StudentTableViewCell
        let student = StudentsModel.sharedInstance().students[(indexPath as NSIndexPath).row]

        cell.studentName?.text = student.firstName + " " + student.lastName
        cell.studentUrl?.text = student.mediaURL

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentsModel.sharedInstance().students[(indexPath as NSIndexPath).row]
        if let toOpen = URL(string: student.mediaURL) {
            if UIApplication.shared.canOpenURL(toOpen as URL) {
                print("The url is valid")
                UIApplication.shared.open(toOpen, options: [:], completionHandler: nil)
            } else {
                print("The url is not valid")
            }
        }
    }

}

