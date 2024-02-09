//
//  UserData.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 07/02/24.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}
