//
//  AdvancedSearchController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 8/5/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit

class AdvancedSearchController: UIViewController {

    var professions : [String] = []
    var instanceOfVC:ViewController!
    
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var btnDismiss: UIButton!
    
    override func viewDidLoad()
    {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        lblSearch.text = ""
        for profession in professions {
            lblSearch.text = lblSearch.text! + " " + profession + "\n"
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        instanceOfVC.blurEffect.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
}
