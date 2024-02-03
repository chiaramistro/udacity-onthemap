//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 03/02/24.
//

import Foundation

class UdacityClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations
    
        var stringValue: String {
            switch self {
                case .getStudentLocations: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }

    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        print("getStudentLocations()")
        taskForGETRequest(url: Endpoints.getStudentLocations.url, responseType: StudentLocationResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // MARK: - Generic GET request method
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        print("Url \(url)")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Data not valid")
                completion(nil, error)
                return
            }
            print("Data \(String(data: data, encoding: .utf8)!)")
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType, from: data)
                completion(response, nil)
            } catch {
                print("Parsing not valid")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
