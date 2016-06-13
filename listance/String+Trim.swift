//
//  String+Trim.swift
//  listance
//
//  Created by Ben Roaman on 4/30/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
