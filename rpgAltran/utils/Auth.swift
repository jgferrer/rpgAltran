//
//  Auth.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 21/6/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit

enum AuthResult {
    case success
    case failure
}

typealias newUserJSON = [String: Any]

class Auth {
    static let defaultsTokenKey = "RPGALTRAN-API-TOKEN-KEY"
    static let defaultsUsernameKey = "RPGALTRAN-API-USERNAME-KEY"
    let defaults = UserDefaults.standard
    
    var token: String? {
        get {
            return defaults.string(forKey: Auth.defaultsTokenKey)
        }
        set {
            defaults.set(newValue, forKey: Auth.defaultsTokenKey)
        }
    }
    
    var username: String? {
        get {
            return defaults.string(forKey: Auth.defaultsUsernameKey)
        }
        set {
            defaults.set(newValue, forKey: Auth.defaultsUsernameKey)
        }
    }
    
    func login(username: String, password: String, completion: @escaping (AuthResult) -> Void) {
        let path = Constants.URLLoginPath
        guard let url = URL(string: path) else {
            fatalError()
        }
        guard let loginString = "\(username):\(password)"
            .data(using: .utf8)?
            .base64EncodedString()
            else {
                fatalError()
        }
        
        var loginRequest = URLRequest(url: url)
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, _ in
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data
                else {
                    completion(.failure)
                    return
            }
            
            do {
                let token = try JSONDecoder().decode(Token.self, from: jsonData)
                self.token = token.token
                self.username = username
                completion(.success)
            } catch {
                completion(.failure)
            }
        }
        dataTask.resume()
    }
    
    func logout() {
        self.token = nil
        /*
        DispatchQueue.main.async {
            // 2
            guard let applicationDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let rootController = UIStoryboard(name: "Login", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "LoginNavigation")
            applicationDelegate.window?.rootViewController = rootController
        }
         */
    }
    
    func createUser(username: String, password: String, completion: @escaping (AuthResult) -> Void) {
        let path = Constants.URLCreateUserPath
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache"
        ]
        guard let url = URL(string: path) else {
            fatalError()
        }
        guard let username64 = "\(username)"
            .data(using: .utf8)?
            .base64EncodedString()
            else {
                fatalError()
        }
        guard let password64 = "\(password)"
            .data(using: .utf8)?
            .base64EncodedString()
            else {
                fatalError()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postData = NSMutableData(data: "username=\(username64)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(password64)".data(using: String.Encoding.utf8)!)
        
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data
                else {
                    completion(.failure)
                    return
            }
            
            do {
                let token = try JSONDecoder().decode(Token.self, from: jsonData)
                self.token = token.token
                self.username = username
                completion(.success)
            } catch {
                completion(.failure)
            }
        }
        dataTask.resume()
    }
    
}
