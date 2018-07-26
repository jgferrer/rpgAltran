//
//  Token.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 21/6/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation

final class Token: Codable {
    var id: Int?
    var token: String
    var userId: Int
    
    init(token: String, userId: Int){
        self.token = token
        self.userId = userId
    }
    
}
