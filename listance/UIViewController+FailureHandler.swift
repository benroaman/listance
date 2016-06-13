//
//  UIViewControllerExtension.swift
//  listance
//
//  Created by Ben Roaman on 4/28/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func dataGetFailure(error: NSError) {
        AlertUtils.generateSingleOptionAlert(self, title: "Uh Oh!", message: "We couldn't get your data! " + error.localizedDescription, actionTitle: "Okay", handler: nil)
    }
    
    func dataCreateFailure(error: NSError) {
        AlertUtils.generateSingleOptionAlert(self, title: "Uh Oh!", message: "We couldn't create your data! " + error.localizedDescription, actionTitle: "Okay", handler: nil)
    }
    
    func dataUpdateFailure(error: NSError) {
        AlertUtils.generateSingleOptionAlert(self, title: "Uh Oh!", message: "We couldn't update your data! " + error.localizedDescription, actionTitle: "Okay", handler: nil)
    }
    
    func dataDeleteFailure(error: NSError) {
        AlertUtils.generateSingleOptionAlert(self, title: "Uh Oh!", message: "We couldn't delete your data! " + error.localizedDescription, actionTitle: "Okay", handler: nil)
    }
}
