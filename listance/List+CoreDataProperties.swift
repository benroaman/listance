//
//  List+CoreDataProperties.swift
//  listance
//
//  Created by Ben Roaman on 7/9/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension List {

    @NSManaged var name: String?
    @NSManaged var isTemplate: NSNumber?
    @NSManaged var image: NSNumber?
    @NSManaged var createdAt: NSDate?
    @NSManaged var modifiedAt: NSDate?
    @NSManaged var info: String?
    @NSManaged var parentList: List?

}
