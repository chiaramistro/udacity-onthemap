//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 03/02/24.
//

import Foundation

struct StudentLocationResponse: Codable {
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
