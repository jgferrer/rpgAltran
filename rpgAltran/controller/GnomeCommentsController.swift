//
//  GnomeCommentsController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 3/6/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import RNNotificationView

class GnomeCommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gnome: Gnome?
    var gnomeComments: [Comment] = []
    @IBOutlet weak var gnomeCommentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerUtils.shared.showActivityIndicator(uiView: self.view)
        getComments(for: (gnome?.id)!) { (result) in
            switch result {
                case .success(let comments):
                    self.gnomeComments = comments
                    self.gnomeCommentsTable.reloadData()
                    ViewControllerUtils.shared.hideActivityIndicator(uiView: self.view)
                case .failure(let error):
                    //fatalError("error: \(error.localizedDescription)")
                    let notification = RNNotificationView()
                    notification.titleFont = UIFont.boldSystemFont(ofSize: 16)
                    notification.subtitleFont = UIFont.systemFont(ofSize: 14)
                    notification.show(withImage: UIImage(named: "error"),
                                      title: "Error",
                                      message: "error: \(error.localizedDescription)",
                                      duration: 3,
                                      iconSize: CGSize(width: 32, height: 32), // Optional setup
                        onTap: {
                            print("Did tap notification")
                    }
                    )
                    ViewControllerUtils.shared.hideActivityIndicator(uiView: self.view)
            }
        }
        
        gnomeCommentsTable.delegate = self
        gnomeCommentsTable.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gnomeComments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gnomeCommentCell") as! GnomeCommentTableViewCell
        
        cell.gnomeComment.layer.cornerRadius = cell.gnomeComment.frame.height / 2
        
        let curComment: Comment = gnomeComments[indexPath.row]
        
        cell.username.text = curComment.userId
        cell.dateCreated.text = curComment.dateCreated.toString(dateFormat: "dd/MM/yyyy HH:mm")
        cell.comment.text = curComment.comment
        
        return cell
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
