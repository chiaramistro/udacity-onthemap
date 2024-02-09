//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 09/02/24.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
