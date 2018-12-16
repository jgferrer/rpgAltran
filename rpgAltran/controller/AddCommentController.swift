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
    var gnomeId: Int16?
    
    @IBOutlet weak var commentTitle: UITextField!
    @IBOutlet weak var commentText: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    @IBAction func addComment(_ sender: UIButton) {
        
        let gnomeComment = CreateComment(title: commentTitle.text!, comment: commentText.text!, userId: Auth().username!, gnomeId: gnomeId!)
        
        postComment(for: gnomeComment) { (result) in
            switch result {
            case .success(let result):
                print("Añadido! \(String(describing: result.id))")
                let viewController = self.instanceOfVC as! GnomeCommentsController
                viewController.blurEffect.isHidden = true
                viewController.loadData()
                self.dismiss(animated: true, completion: nil)
            case.failure(let error):
                print("error: \(error.localizedDescription)")
                let message = "Error posting comment. Try again."
                print(message)
                ErrorPresenter.showError(message: message, on: self)
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        let viewController = self.instanceOfVC as! GnomeCommentsController
        viewController.blurEffect.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
