//
//  AlertUtils.swift
//  listance
//
//  Created by Ben Roaman on 4/27/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class AlertUtils: NSObject {
    
    class func generateSingleOptionAlert(presentingController: UIViewController, title:String?, message:String?, actionTitle:String?, handler:((action:UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        alert.title = title
        alert.message = message
        let acceptAction = UIAlertAction(title: actionTitle, style: .Cancel, handler: handler)
        alert.addAction(acceptAction)
        presentingController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func generateConfirmationAlert(controller:UIViewController, message:String, callback:()->Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .Default, handler: { action in
            callback()
        })
        let denyAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        alert.addAction(denyAction)
        alert.addAction(confirmAction)
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func generateTextInputAlert(controller: UIViewController, title: String, placeholder:String, confirmTitle:String, callback:(String)->Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = placeholder
            textField.textAlignment = .Center
        }
        alert.addAction(UIAlertAction(title: confirmTitle, style: .Default) { action in
            if let text = alert.textFields?.first?.text where !text.trim().isEmpty {
                callback(text)
            } else {
                generateSingleOptionAlert(controller, title: "Whoops!", message: "You need to give your list a title!", actionTitle: "I See...", handler: { action in
                    generateTextInputAlert(controller, title: title, placeholder: placeholder, confirmTitle: confirmTitle, callback: callback)
                })
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}
