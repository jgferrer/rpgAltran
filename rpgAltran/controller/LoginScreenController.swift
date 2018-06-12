//
//  LoginScreenController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 10/6/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit

class LoginScreenController: UIViewController {
    
    var instanceOfVC: ViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        instanceOfVC.blurEffect.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
