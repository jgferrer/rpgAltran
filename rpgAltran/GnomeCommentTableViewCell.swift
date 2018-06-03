//
//  GnomeCommentTableViewCell.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 3/6/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import UIKit

class GnomeCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gnomeComment: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var comment: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
