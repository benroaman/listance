//
//  ItemDetailViewController.swift
//  listance
//
//  Created by Ben Roaman on 4/30/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    // MARK: Instance Variables
    
    var item: Item?
    var editMode = false
    
    var didEditItem:((Item)->Void)?
    
    // MARK: Outlets
    
    // MARK: Actions
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Private Functions
    
}
