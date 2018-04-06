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
    
    var gnome : Gnome?
    @IBOutlet weak var gnomeNameLbl: UILabel!
    @IBOutlet weak var gnomeImage: UIImageView!
    @IBOutlet weak var gnomeNameTitle: UINavigationItem!
    
    override func viewDidLoad()
    {
        gnomeNameLbl.text = "Age: \(gnome!.age!)"
        gnomeNameTitle.title = gnome?.name
        let url = URL(string: (gnome?.thumbnail)!)
        gnomeImage.kf.setImage(with: url)
        gnomeImage.layer.cornerRadius = gnomeImage.frame.height / 2
    }
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
