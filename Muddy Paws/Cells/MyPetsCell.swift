//
//  MyPetsCell.swift
//  Muddy Paws
//
//  Created by SatnamSingh on 21/07/21.
//  Copyright © 2021 TechGeeks. All rights reserved.
//

import UIKit

class MyPetsCell: UITableViewCell {

    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var lblPetName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
