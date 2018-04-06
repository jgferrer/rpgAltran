//
//  Gnome.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 1/4/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//
/*
 {"id":0,
 "name":"Tobus Quickwhistle",
 "thumbnail":"http://www.publicdomainpictures.net/pictures/10000/nahled/thinking-monkey-11282237747K8xB.jpg",
 "age":306,
 "weight":39.065952,
 "height":107.75835,
 "hair_color":"Pink",
 "professions":["Metalworker","Woodcarver","Stonecarver"," Tinker","Tailor","Potter"],
 "friends":["Cogwitz Chillwidget","Tinadette Chillbuster"]}
 */

import Foundation
import UIKit

struct Gnome: Codable {
    var id: Int?
    var name: String?
    var thumbnail: String?
    var age: Int?
    var weight: Double?
    var height: Double?
    var hair_color: String?
    var professions: [String]?
    var friends: [String]?
    
    init(with dictionary: NSDictionary?) {
        guard let dictionary = dictionary else { return }
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        thumbnail = dictionary["thumbnail"] as? String
        age = dictionary["age"] as? Int
        weight = dictionary["weight"] as? Double
        height = dictionary["height"] as? Double
        hair_color = dictionary["hair_color"] as? String
        professions = dictionary["professions"] as? [String]
        friends = dictionary["friends"] as? [String]
    }
}
