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
    
    @IBOutlet weak var gnomeAge: UILabel!
    @IBOutlet weak var gnomeHairColor: UILabel!
    @IBOutlet weak var gnomeWeight: UILabel!
    @IBOutlet weak var gnomeHeight: UILabel!
    @IBOutlet weak var gnomeImage: UIImageView!
    @IBOutlet weak var gnomeName: UILabel!
    
    override func viewDidLoad()
    {
        gnomeName.text = gnome?.name
        gnomeAge.text = "\(gnome!.age!)"
        gnomeHairColor.text = "\(gnome?.hair_color ?? "")"
        gnomeWeight.text = "\(gnome!.weight!)"
        gnomeHeight.text = "\(gnome!.height!)"
        
        
        let url = URL(string: (gnome?.thumbnail)!)
        gnomeImage.kf.setImage(with: url)
        gnomeImage.layer.cornerRadius = gnomeImage.frame.height / 2
    }
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
