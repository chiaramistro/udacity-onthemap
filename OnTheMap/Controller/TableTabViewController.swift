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
        print("tableView didSelectRowAt()")
        // FIXME on click on cell
    }

}

