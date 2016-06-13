//
//  PermissionUtils.swift
//  listance
//
//  Created by Ben Roaman on 4/27/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit
import Photos

class PermissionUtils: NSObject {
    
    // MARK: Core Functions
    
    class func checkPermissionForPhotoLibrary(controller:UIViewController, permissionTitle pTitle:String = "Permissions", permissionMessage pMessage:String = "This App needs permission to access your photo library for this feature", permissionYesButtonText pYes:String = "Okay", permissionNoButtonText pNo:String = "Not now", redirectTitle rTitle:String = "Permissions", redirectMessage rMessage:String = "Please update your photo library permission settings to use this feature", redirectYes rYes:String = "Settings", redirectNoButtonText rNo:String = "Not Now", hasPermissionCallback callback:()->Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .Authorized :
            callback()
        case .NotDetermined :
            presentPPRequest(controller, title: pTitle, message: pMessage, yesButtonText: pYes, noButtonText: pNo, yesCallback: {
                PHPhotoLibrary.requestAuthorization({ status in
                    if status == .Authorized {
                        callback()
                    }
                })
            })
        case .Denied, .Restricted :
            presentRedirectRequest(controller, message: nil)
        }
    }
    
    class func checkPermissionForCamera(controller:UIViewController, permissionTitle pTitle:String = "Permissions", permissionMessage pMessage:String = "This App needs permission to use your camera for this feature", permissionYesButtonText pYes:String = "Okay", permissionNoButtonText pNo:String = "Not now", redirectTitle rTitle:String = "Permissions", redirectMessage rMessage:String = "Please update your camera permission settings to use this feature", redirectYes rYes:String = "Settings", redirectNoButtonText rNo:String = "Not Now", hasPermissionCallback callback:()->Void) {
        executeAVAuthSwitchFlow(AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo), controller: controller, title: pTitle, message: pMessage, yesButtonText: pYes, noButtonText: pNo, yesCallback: {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {granted in
                if granted {
                    callback()
                }
            })
        })
    }
    
    class func checkPermissionForMic(controller:UIViewController, permissionTitle pTitle:String = "Permissions", permissionMessage pMessage:String = "This App needs permission to use your mic for this feature", permissionYesButtonText pYes:String = "Okay", permissionNoButtonText pNo:String = "Not now", redirectTitle rTitle:String = "Permissions", redirectMessage rMessage:String = "Please update your microphone permission settings to use this feature", redirectYes rYes:String = "Settings", redirectNoButtonText rNo:String = "Not Now", hasPermissionCallback callback:()->Void) {
        executeAVAuthSwitchFlow(AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeAudio), controller: controller, title: pTitle, message: pMessage, yesButtonText: pYes, noButtonText: pNo, yesCallback: {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeAudio, completionHandler: {granted in
                if granted {
                    callback()
                }
            })
        })
    }
    
    class func checkPermissionForVideo(controller:UIViewController, permissionTitle pTitle:String = "Permissions", permissionMessage pMessage:String = "This App needs permission to use your camera and microphone for this feature", permissionYesButtonText pYes:String = "Okay", permissionNoButtonText pNo:String = "Not now", redirectTitle rTitle:String = "Permissions", redirectMessage rMessage:String = "Please update your camera and microphone permission settings to use this feature", redirectYes rYes:String = "Settings", redirectNoButtonText rNo:String = "Not Now", hasPermissionCallback callback:()->Void) {
        let cameraPermissionState = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        let micPermissionState = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeAudio)
        
        switch cameraPermissionState {
        case .Authorized:
            switch micPermissionState {
            case .Authorized:
                callback()
            case .NotDetermined:
                presentPPRequest(controller, title: pTitle, message: pMessage, yesButtonText: pYes, noButtonText: pNo, yesCallback: {
                    AVCaptureDevice.requestAccessForMediaType(AVMediaTypeAudio, completionHandler: {granted in
                        if granted {
                            callback()
                        }
                    })
                })
            case .Denied, .Restricted:
                presentRedirectRequest(controller, message: nil)
                break
            }
        case .NotDetermined:
            switch micPermissionState {
            case .Authorized:
                presentPPRequest(controller, title: pTitle, message: pMessage, yesButtonText: pYes, noButtonText: pNo, yesCallback: {
                    AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {granted in
                        if granted {
                            callback()
                        }
                    })
                })
            case .NotDetermined:
                presentPPRequest(controller, title: pTitle, message: pMessage, yesButtonText: pYes, noButtonText: pNo, yesCallback: {
                    AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {granted in
                        if granted {
                            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeAudio, completionHandler: {granted in
                                if granted {
                                    callback()
                                }
                            })
                        }
                    })
                })
            case .Denied, .Restricted:
                presentPPRequest(controller, title: pTitle, message: pMessage, yesButtonText: pYes, noButtonText: pNo, yesCallback: {
                    AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {granted in
                        if granted {
                            presentRedirectRequest(controller, message: nil)
                        }
                    })
                })
            }
        case .Denied, .Restricted:
            switch micPermissionState {
            case .Authorized, .Denied, .Restricted:
                presentRedirectRequest(controller, message: nil)
                break
            case .NotDetermined:
                presentPPRequest(controller, title: pTitle, message: pMessage, yesButtonText: pYes, noButtonText: pNo, yesCallback: {
                    AVCaptureDevice.requestAccessForMediaType(AVMediaTypeAudio, completionHandler: {granted in
                        if granted {
                            presentRedirectRequest(controller, message: nil)
                        }
                    })
                })
            }
        }
    }
    //
    //    class func locationPPRequest(controller:UIViewController, yesCallback:()->Void, title:String?, message:String?, yesButtonText:String?, noButtonText:String?) {
    //        switch CLLocationManager.authorizationStatus() {
    //        case .AuthorizedAlways, .AuthorizedWhenInUse:
    //            break
    //        case .NotDetermined:
    //            // TODO: ask for permissions
    //            break
    //        case .Denied, .Restricted:
    //            // TODO: redirect to whatever
    //            break
    //        }
    //    }
    //
    //    class func pushPPRequest(controller:UIViewController, yesCallback:()->Void, title:String?, message:String?, yesButtonText:String?, noButtonText:String?) {
    //
    //    }
    //
    // MARK: Support Functions
    
    class func isAVPermissionStateCompromised(permissionState:AVAuthorizationStatus) -> Bool {
        return (permissionState == .Denied || permissionState == .Restricted)
    }
    
    class func executeAVAuthSwitchFlow(status:AVAuthorizationStatus, controller:UIViewController, title:String?, message:String?, yesButtonText:String?, noButtonText:String?, yesCallback:()->Void) {
        switch status {
        case .Authorized :
            yesCallback()
        case .NotDetermined :
            presentPPRequest(controller, title: title, message: message, yesButtonText: yesButtonText, noButtonText: noButtonText, yesCallback: yesCallback)
            break
        case .Denied, .Restricted :
            presentRedirectRequest(controller, message: nil)
            break
        }
    }
    
    class func presentPPRequest(controller:UIViewController, title:String?, message:String?, yesButtonText:String?, noButtonText:String?, yesCallback:()->Void) {
        // Set String values for alert
        let yesString = yesButtonText != nil ? yesButtonText : "Sure Thing!"
        let noString = noButtonText != nil ? noButtonText : "Not Right Now"
        let titleString = title != nil ? title : "Permission Request"
        let messageString = message != nil ? message : "This App requires your permission to use this feature"
        let PPAlertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .Alert)
        let declinePermissionAction = UIAlertAction(title: noString, style: .Default, handler:nil)
        let acceptPermissionAction = UIAlertAction(title: yesString, style: .Default) { (action) in yesCallback() }
        PPAlertController.addAction(declinePermissionAction)
        PPAlertController.addAction(acceptPermissionAction)
        controller.presentViewController(PPAlertController, animated: true, completion: nil)
    }
    
    class func presentRedirectRequest(controller:UIViewController, message:String!) {
        let messageString = message != nil ? message : "Please update your permission settings to use this feature"
        let redirectAlertController = UIAlertController(title: messageString, message:nil, preferredStyle: .Alert)
        let redirectAction = UIAlertAction(title:"Settings", style: .Cancel) { (action) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        let cancelRedirectAction = UIAlertAction(title: "Not Now", style: .Default) { (action) in }
        redirectAlertController.addAction(redirectAction)
        redirectAlertController.addAction(cancelRedirectAction)
        controller.presentViewController(redirectAlertController, animated: true, completion: nil)
    }
}

