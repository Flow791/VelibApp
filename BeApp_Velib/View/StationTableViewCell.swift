//
//  StationTableViewCell.swift
//  BeApp_Velib
//
//  Created by Florian Baudin on 03/10/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabelCell: UILabel!
    @IBOutlet weak var statusLabelCell: UILabel!
    @IBOutlet weak var bikeLabelCell: UILabel!
    @IBOutlet weak var availableLabelCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
