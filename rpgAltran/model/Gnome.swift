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
    let id: Int
    let name: String
    let thumbnail: String
    let age: Int
    let weight: Double
    let height: Double
    let hair_color: String
    let professions: [String]
    let friends: [String]
    
}
