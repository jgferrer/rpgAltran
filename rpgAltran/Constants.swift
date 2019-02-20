//
//  Constants.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 28/12/2018.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation

struct Constants {
    
    static let URLScheme = "https"
    static let URLHost = "rpgaltranapi.herokuapp.com"
    static let URLPort = 443
    static let URLComments = "/api/comments/"
    static let URLUsers = "/api/users/"
    
    
    static let URLLoginPath = URLScheme + "://" + URLHost + ":" + String(URLPort) + URLUsers + "login"
    static let URLCreateUserPath = URLScheme + "://" + URLHost + ":" + String(URLPort) + URLUsers + "createUser"
    static let URLGnomes = URLScheme + "://" + URLHost + ":" + String(URLPort) + "/api/json"
    
}
