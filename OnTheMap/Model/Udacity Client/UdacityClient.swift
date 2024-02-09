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
        static var userId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case signUp
        case handleSession
        case studentLocations
        case updateStudentLocations(String)
        case userData(String)
        
        var stringValue: String {
            switch self {
                case .signUp: return "https://www.udacity.com/account/auth#!/signup"
                case .handleSession: return Endpoints.base + "/session"
                case .studentLocations: return Endpoints.base + "/StudentLocation"
                case .updateStudentLocations(let objectId): return Endpoints.base + "/StudentLocation/\(objectId)"
                case .userData(let userId): return Endpoints.base + "/users/\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }

    }
    
    class func createSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: SessionRequestData(username: username, password: password))
        var request = URLRequest(url: Endpoints.handleSession.url)
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
               Auth.userId = responseObject.account.key
               completion(true, nil)
           } catch {
               print("Parsing not valid")
               do {
                   let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                   completion(false, errorResponse)
               } catch {
                   print("Error parsing not valid")
                   completion(false, error)
               }
           }
       }
       
       task.resume()
    }
    
    class func endSession(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.handleSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
       
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
               let _ = try decoder.decode(EndSessionResponse.self, from: data)
               Auth.sessionId = ""
               Auth.userId = ""
               completion(true, nil)
           } catch {
               print("Parsing not valid")
               completion(false, error)
           }
       }
       
       task.resume()
    }
    
    class func getUserData(userId: String, completion: @escaping (User?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.userData(userId).url) { originalData, response, error in
            guard let originalData = originalData else {
                print("Data not valid")
                completion(nil, error)
                return
            }
            let range = 5..<originalData.count
            let data = originalData.subdata(in: range)
            print("Data \(String(data: data, encoding: .utf8)!)")
            let decoder = JSONDecoder()
            do {
                let userData = try decoder.decode(User.self, from: data)
                completion(userData, nil)
            } catch {
                print("Parsing not valid")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        print("getStudentLocations()")
        taskForGETRequest(url: Endpoints.studentLocations.url, responseType: StudentLocationResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func addNewStudentLocation(newStudentLoc: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
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
    class func updateStudentLocation(objectId: String, updatedStudentLoc: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
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
