//
//  UIViewControllerExtension.swift
//  listance
//
//  Created by Ben Roaman on 4/28/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func dataGetFailure(error: NSError?) {
        dataError(error, message: "We couldn't get your data!")
    }
    
    func dataCreateFailure(error: NSError?) {
        dataError(error, message: "We couldn't create your data!")
    }
    
    func dataUpdateFailure(error: NSError?) {
        dataError(error, message: "We couldn't update your data!")
    }
    
    func dataDeleteFailure(error: NSError?) {
        dataError(error, message: "We couldn't delete your data!")
    }
    
    func dataError(error:NSError?, message:String) {
        if let e = error {
            AlertUtils.generateSingleOptionAlert(self, title: "Uh Oh!", message: message + " " + e.localizedDescription, actionTitle: "Okay", handler: nil)
        }
        NSLog("ERROR :: DATA :: \(message) :: \(error)")
    }
}
