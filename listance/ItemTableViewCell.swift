//
//  ItemTableViewCell.swift
//  listance
//
//  Created by Ben Roaman on 4/30/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    // MARK: Instance Variables
    
    var item:ItemSync?
    var isInstance = false;
    
    var onToggleItemChecked:((ItemSync?, (Bool)->Void)->Void)?
    
    // MARK: Outlets
    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var checkboxButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func checkboxAction(sender: AnyObject) {
        if let callback = onToggleItemChecked {
            callback(self.item, { checked in
                self.setCheckboxVisualState(checked)
            })
        }
    }
    
    // MARK: Lifecycle Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        infoLabel.text = ""
        thumbnail.image = UIImage(named: "placeholder_image")
    }
    
    // MARK: Public Functions
    
    func configure(item: ItemSync) {
        self.item = item
        if let itemThumbnail = item.image, thumbnailData = itemThumbnail.data {
            self.thumbnail.image = UIImage(data: thumbnailData)
        }
        self.nameLabel.text = item.name
        self.infoLabel.text = item.info
        setCheckboxVisualState(item.checked)
        self.selectionStyle = .None
    }
    
    // MARK: Private Functions
    
    private func setCheckboxVisualState(checked:Bool) {
        if !isInstance {
            checkboxButton.tintColor = UIColor.lightGrayColor()
            checkboxButton.setImage(UIImage(named: "unchecked_35px"), forState: .Normal)
            checkboxButton.enabled = false
        } else if checked {
            checkboxButton.tintColor = UIColor.withHexValue(AppColors.aqua)
            checkboxButton.setImage(UIImage(named: "checked_35px"), forState: .Normal)
        } else {
            checkboxButton.tintColor = UIColor.withHexValue(AppColors.tomato)
            checkboxButton.setImage(UIImage(named: "unchecked_35px"), forState: .Normal)
        }
    }
}
