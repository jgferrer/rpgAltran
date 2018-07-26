//
//  User.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 21/6/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation

final class User: Codable {
    var id: Int?
    var username: String
    
    init(username: String) {
        self.username = username
    }
}

final class CreateUser: Codable {
    var id: Int?
    var username: String
    var password: String?
    
    init(username: String, password: String){
        self.username = username
        self.password = password
    }
}
