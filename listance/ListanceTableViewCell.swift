//
//  InstanceTableViewCell.swift
//  listance
//
//  Created by Ben Roaman on 5/1/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class ListanceTableViewCell: UITableViewCell {
    
    // MARK: Instance Variable
    
    var listance:ListSync?
    
    // MARK: Outlets
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    // MARK: Lifecycle Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        infoLabel.text = ""
    }
    
    // MARK: Public Functions
    
    func configure(listance:ListSync) {
        self.listance = listance
        nameLabel.text = listance.name
        infoLabel.text = listance.info
    }
}
