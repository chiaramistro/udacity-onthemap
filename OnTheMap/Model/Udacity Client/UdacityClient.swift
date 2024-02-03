//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Chiara Mistrorigo on 03/02/24.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSession
        case studentLocations
        case updateStudentLocations(String)
        
        var stringValue: String {
            switch self {
                case .createSession: return Endpoints.base + "/session"
                case .studentLocations: return Endpoints.base + "/StudentLocation"
                case .updateStudentLocations(let objectId): return Endpoints.base + "/StudentLocation/\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }

    }
    
    class func createSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: SessionRequestData(username: username, password: password))
        var request = URLRequest(url: Endpoints.createSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        print("Data \(String(data: request.httpBody!, encoding: .utf8)!)")
       
        let task = URLSession.shared.dataTask(with: request) { originalData, response, error in
           guard let originalData = originalData else {
               print("Data not valid")
               completion(false, error)
               return
           }
           let range = 5..<originalData.count
           let data = originalData.subdata(in: range)
           print("Data \(String(data: data, encoding: .utf8)!)")
           let decoder = JSONDecoder()
           do {
               let responseObject = try decoder.decode(SessionResponse.self, from: data)
               Auth.sessionId = responseObject.session.id
               completion(true, nil)
           } catch {
               print("Parsing not valid")
               completion(false, error)
           }
       }
       
       task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        print("getStudentLocations()")
        taskForGETRequest(url: Endpoints.studentLocations.url, responseType: StudentLocationResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // TODO to test
    class func addNewStudentLocation(newStudentLoc: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.studentLocations.url, responseType: AddNewStudentLocationResponse.self, body: newStudentLoc) { response, error in
            if let response = response {
                print("addNewStudentLocation() response \(response)")
                completion(true, nil)
            } else {
                completion(false, error)
            }

        }
    }
    
    // TODO test
    class func updateStudentLocation(objectId: String, updatedStudentLoc: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateStudentLocations(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(updatedStudentLoc)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Data not valid")
                completion(false, error)
                return
            }
            print("Data \(String(data: data, encoding: .utf8)!)")
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UpdateStudentLocationResponse.self, from: data)
                completion(true, nil)
            } catch {
                print("Parsing not valid")
                completion(false, error)
            }
        }
        
        task.resume()
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
    
    // MARK: - Generic POST request method
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Data not valid")
                completion(nil, error)
                return
            }
            print("Data \(String(data: data, encoding: .utf8)!)")
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType, from: data)
                completion(responseObject, nil)
            } catch {
                print("Parsing not valid")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
}
