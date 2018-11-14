//
//  NavDrawerTableViewCell.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 10/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit

class NavDrawerTableViewCell: UITableViewCell {

    @IBOutlet weak var NavDrawerClickableCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
