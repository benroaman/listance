//
//  TemplateTableViewCell.swift
//  listance
//
//  Created by Ben Roaman on 4/27/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class TemplateTableViewCell: UITableViewCell {
    
    // MARK: Instance Variables
    
    private var template: ListSync?
    var onInstantiate: ((ListSync?)->Void)?
    
    // MARK: Outlets
    
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: Actions
    
    @IBAction func instantiateAction(sender: AnyObject) {
        if let callback = self.onInstantiate {
            callback(self.template)
        }
    }
    
    // MARK: Lifecycle Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        infoLabel.text = ""
    }
    
    // MARK: Public Functions
    
    func configure(template:ListSync) {
        self.template = template
        self.nameLabel.text = self.template?.name
        self.infoLabel.text = self.template?.info
        self.selectionStyle = .None
    }
}
