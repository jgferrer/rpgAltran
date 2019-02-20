//
//  Comment.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 1/6/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation

enum DateError: String, Error {
    case invalidDate
}

struct Comment: Codable {
    let id: Int
    let title: String
    let comment: String
    let userId: String
    let gnomeId: Int16
    let dateCreated: Date
}

final class CreateComment: Codable {
    var title: String
    var comment: String
    var userId: String
    var gnomeId: Int16
    
    init(title: String, comment: String, userId: String, gnomeId: Int16){
        self.title = title
        self.comment = comment
        self.userId = userId
        self.gnomeId = gnomeId
    }
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

struct GnomeCount: Codable {
    let gnomeId: Int16
    let count: Int
}

func getComments(for gnomeId: Int16, completion: ((Result<[Comment]>) -> Void)?) {
    var urlComponents = URLComponents()
    urlComponents.scheme = Constants.URLScheme
    urlComponents.host = Constants.URLHost
    urlComponents.port = Constants.URLPort
    urlComponents.path = Constants.URLComments
    
    let gnomeIdItem = URLQueryItem(name: "gnomeId", value: "\(gnomeId)")
    urlComponents.queryItems = [gnomeIdItem]
    
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                // Now we have jsonData, Data representation of the JSON returned to us
                // from our URLRequest...
                
                // Create an instance of JSONDecoder to decode the JSON data to our
                // Codable struct
                let decoder = dataDecoder()
                
                do {
                    // We would use Comment.self for JSON representing a single Comment
                    // object, and [Comment].self for JSON representing an array of
                    // Comment objects
                    let posts = try decoder.decode([Comment].self, from: jsonData)
                    completion?(.success(posts))
                } catch {
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
            }
        }
    }
    
    task.resume()
}

func getCommentsCount(for gnomeId: Int16, completion: ((Result<GnomeCount>) -> Void)?) {
    var urlComponents = URLComponents()
    urlComponents.scheme = Constants.URLScheme
    urlComponents.host = Constants.URLHost
    urlComponents.port = Constants.URLPort
    urlComponents.path = Constants.URLComments + "/count"
    
    let gnomeIdItem = URLQueryItem(name: "gnomeId", value: "\(gnomeId)")
    urlComponents.queryItems = [gnomeIdItem]
    
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(GnomeCount.self, from: jsonData)
                    completion?(.success(result))
                } catch {
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
            }
        }
    }
    
    task.resume()
}

func postComment(for gnomeComment: CreateComment, completion: ((Result<Comment>) -> Void)?) {
    var urlComponents = URLComponents()
    urlComponents.scheme = Constants.URLScheme
    urlComponents.host = Constants.URLHost
    urlComponents.port = Constants.URLPort
    urlComponents.path = Constants.URLComments
    
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let jsonEncoder = JSONEncoder()
    let jsonData = try? jsonEncoder.encode(gnomeComment)
    
    request.setValue("Bearer \(Auth().token!)", forHTTPHeaderField: "Authorization")
    request.httpBody = jsonData
    request.addValue("application/json", forHTTPHeaderField:"Content-Type")

    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                let decoder = dataDecoder()
                do {
                    let result = try decoder.decode(Comment.self, from: jsonData)
                    completion?(.success(result))
                } catch {
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
            }
        }
    }
    
    task.resume()
}

func dataDecoder () -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        throw DateError.invalidDate
    })
    return decoder
}
