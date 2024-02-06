//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 03/02/24.
//

import Foundation

struct StudentInformation: Codable, Equatable {
    let objectId: String
    let uniqueKey: String?
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: String
    let updatedAt: String
    
    // TODO
    // let createdAt: Date
    // let updatedAt: Date
    // let ACL: String
}
