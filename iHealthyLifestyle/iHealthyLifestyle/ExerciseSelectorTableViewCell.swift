//
//  ExerciseSelectorTableViewCell.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 12/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit

class ExerciseSelectorTableViewCell: UITableViewCell {    
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var groupsLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
