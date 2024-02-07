//
//  UserModel.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 07/02/24.
//

import Foundation

class UserModel {
    var user = User(firstName: "", lastName: "")
    
    class func sharedInstance() -> UserModel {
        struct Singleton {
            static var sharedInstance = UserModel()
        }
        return Singleton.sharedInstance
    }
}
