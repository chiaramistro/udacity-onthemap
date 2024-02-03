//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 03/02/24.
//

import Foundation

struct SessionRequest: Codable {
    let udacity: SessionRequestData
}

struct SessionRequestData: Codable {
    let username: String
    let password: String
}
