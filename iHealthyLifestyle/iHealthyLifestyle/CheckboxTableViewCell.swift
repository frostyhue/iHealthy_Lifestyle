//
//  CheckboxTableViewCell.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 11/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit

class CheckboxTableViewCell: UITableViewCell {

    @IBOutlet weak var CheckboxClickableCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
