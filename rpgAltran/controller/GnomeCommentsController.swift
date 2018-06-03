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

class GnomeCommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gnome: Gnome?
    var gnomeComments: [Comment] = []
    @IBOutlet weak var gnomeCommentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getComments(for: (gnome?.id)!) { (result) in
            switch result {
                case .success(let comments):
                    self.gnomeComments = comments
                    self.gnomeCommentsTable.reloadData()
            case .failure(let error):
                fatalError("error: \(error.localizedDescription)")
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
        cell.comment.text = curComment.comment
        
        return cell
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
