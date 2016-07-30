//
//  List.swift
//  listance
//
//  Created by Ben Roaman on 4/27/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import syncano_ios

class ListSync: SCDataObject {
    var name = ""
    var info = ""
    var isTemplate = false
    var parentList: ListSync?
}
