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
    
    var instanceOfVC: AnyObject!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        Auth().logout()
        if object_getClassName(self.instanceOfVC) == object_getClassName(ViewController()) {
            let viewController = self.instanceOfVC as! ViewController
            viewController.blurEffect.isHidden = true
            viewController.tabBar.selectedItem = viewController.tabBar.items?[0]
            viewController.searchBar.enable()
            viewController.btnAdvSearch.isEnabled = true
            viewController.allGnomes()
            self.dismiss(animated: true, completion: nil)
        } else if object_getClassName(self.instanceOfVC) == object_getClassName(GnomeCommentsController()) {
            let viewController = self.instanceOfVC as! GnomeCommentsController
            viewController.blurEffect.isHidden = true
            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        let username = txtUsername.text!
        let password = txtPassword.text!
        
        Auth().login(username: username, password: password) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("Login OK!")
                    if object_getClassName(self.instanceOfVC) == object_getClassName(ViewController()) {
                        let viewController = self.instanceOfVC as! ViewController
                        viewController.blurEffect.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                    } else if object_getClassName(self.instanceOfVC) == object_getClassName(GnomeCommentsController()) {
                        let viewController = self.instanceOfVC as! GnomeCommentsController
                        viewController.blurEffect.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }
            case .failure:
                let message = "Could not login. Check your credentials and try again"
                print(message)
                ErrorPresenter.showError(message: message, on: self)
            }
        }
    }
    
    @IBAction func btnNewUser(_ sender: Any) {
        let username = txtUsername.text!
        let password = txtPassword.text!
        
        Auth().createUser(username: username, password: password) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("Login OK!")
                    if object_getClassName(self.instanceOfVC) == object_getClassName(ViewController()) {
                        let viewController = self.instanceOfVC as! ViewController
                        viewController.blurEffect.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                    } else if object_getClassName(self.instanceOfVC) == object_getClassName(GnomeCommentsController()) {
                        let viewController = self.instanceOfVC as! GnomeCommentsController
                        viewController.blurEffect.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }
            case .failure:
                let message = "Error creating user."
                print(message)
                ErrorPresenter.showError(message: message, on: self)
            }
        }
        
    }
}

