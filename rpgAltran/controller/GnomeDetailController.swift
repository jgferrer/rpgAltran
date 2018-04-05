//
//  GnomeDetailController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 5/4/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class GnomeDetailController: UIViewController {
    
    var gnomeDict : NSDictionary?
    @IBOutlet weak var gnomeNameLbl: UILabel!
    
    override func viewDidLoad()
    {
        if let name = self.gnomeDict?.value(forKey: "name") {
            print(name)
        }
        
        gnomeNameLbl.text = self.gnomeDict?.value(forKey: "name") as? String
        
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
