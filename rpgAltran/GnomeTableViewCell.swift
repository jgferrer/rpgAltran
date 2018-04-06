//
//  GnomeTableViewCell.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 4/4/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import UIKit

class GnomeTableViewCell: UITableViewCell {

    @IBOutlet weak var gnomeCell: UIView!
    @IBOutlet weak var gnomeImage: UIImageView!
    @IBOutlet weak var gnomeName: UILabel!
    @IBOutlet weak var gnomeAge: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
