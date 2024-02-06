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
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsModel.sharedInstance().students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        let student = StudentsModel.sharedInstance().students[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = student.firstName + " " + student.lastName

//        FIXME: custom cell

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableView didSelectRowAt()")
        // FIXME on click on cell
    }

}

