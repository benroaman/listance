//
//  List.swift
//  listance
//
//  Created by Ben Roaman on 7/9/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import Foundation
import CoreData


class List: NSManagedObject {
    
    func newSublist() -> List {
        let list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: CoreDataUtil.managedObjectContext) as! List
        list.isTemplate = self.isTemplate
        list.parentList = self
        return list
    }
    
    func newItem() -> Item {
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: CoreDataUtil.managedObjectContext) as! Item
        item.checked = false
        item.parentList = self
        return item
    }
}
