//
//  IndicatorUtils.swift
//  listance
//
//  Created by Ben Roaman on 4/29/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class IndicatorUtils: NSObject {
    
    class func addScreenCoveringActivityIndicator(controller:UIViewController, color:UIColor) -> UIView {
        let screenRect = UIScreen.mainScreen().bounds
        let blocker = UIView(frame: screenRect)
        blocker.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.color = color
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        blocker.addSubview(activityIndicator)
        blocker.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: blocker, attribute: .CenterX, multiplier: 1, constant: 0))
        blocker.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: blocker, attribute: .CenterY, multiplier: 1, constant: 0))
        if let tabBarController = controller.navigationController?.tabBarController {
            tabBarController.view.addSubview(blocker)
        } else if let navigationController = controller.navigationController {
            navigationController.view.addSubview(blocker)
        } else {
            controller.view.addSubview(blocker)
        }
        activityIndicator.startAnimating()
        return blocker
    }
}