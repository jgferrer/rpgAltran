//
//  AddCommentController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 21/10/2018.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit

class AddCommentController: UIViewController {
    var instanceOfVC: AnyObject!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    @IBAction func addComment(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        let viewController = self.instanceOfVC as! GnomeCommentsController
        viewController.blurEffect.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
