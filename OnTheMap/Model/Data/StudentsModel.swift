//
//  StudentsModel.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 06/02/24.
//

import Foundation

class StudentsModel {
    var students = [StudentInformation]()
    
    class func sharedInstance() -> StudentsModel {
        struct Singleton {
            static var sharedInstance = StudentsModel()
        }
        return Singleton.sharedInstance
    }
}
