//
//  SyncanoServiceManager.swift
//  listance
//
//  Created by Ben Roaman on 4/27/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import syncano_ios

class SyncanoUtils: NSObject {
    
    // MARK: Get Lists
    
    class func getAllTemplates(success:([List])->Void, failure:(NSError)->Void) {
        getAllLists(true, success: success, failure: failure)
    }
    
    class func getAllListances(success:([List])->Void, failure:(NSError)->Void) {
        getAllLists(false, success: success, failure: failure)
    }
    
    class func getAllLists(getTemplates:Bool, success:([List])->Void, failure:(NSError)->Void) {
        let templatePredicate = SCPredicate.whereKey("isTemplate", isEqualToBool: getTemplates)
        List.please().giveMeDataObjectsWithPredicate(templatePredicate, parameters: nil) { results, error in
            if error == nil {
                let templates = results.map({ $0 as! List })
                success(templates)
            } else {
                failure(error)
            }
        }
    }
    
    class func getAllSublistsForList(parentListId:NSNumber, success:([List])->Void, failure:(NSError)->Void) {
        let templatePredicate = SCPredicate.whereKey("parentList", isEqualToNumber: parentListId)
        List.please().giveMeDataObjectsWithPredicate(templatePredicate, parameters: nil) { results, error in
            if error == nil {
                let templates = results.map({ $0 as! List })
                success(templates)
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Create Lists
    
    class func createTemplateList(name:String, success:(List)->Void, failure:(NSError)->Void) {
        let newTemplate = List()
        newTemplate.name = name
        newTemplate.info = "New Template"
        newTemplate.isTemplate = true
        newTemplate.saveWithCompletionBlock() { error in
            if error == nil {
                success(newTemplate)
            } else {
                failure(error)
            }
        }
    }
    
    class func createSublistWithName(name:String, parentList:List, success:(List)->Void, failure:(NSError)->Void) {
        let newSublist = List()
        newSublist.name = name
        newSublist.parentList = parentList
        newSublist.saveWithCompletionBlock() { error in
            if error == nil {
                success(newSublist)
            } else {
                failure(error)
            }
        }
    }
    
    class func instantiateListFromTemplate(list:List, success:(List)->Void, failure:(NSError)->Void) {
        let instance = List()
        instance.name = list.name
        instance.info = list.info
        instance.isTemplate = false
        instance.saveWithCompletionBlock() { error in
            getAllItemsForList(list.objectId, success: { items in
                let copies: [Item] = items.map({
                    let copy = Item()
                    copy.name = $0.name
                    copy.info = $0.info
                    copy.image = $0.image
                    copy.parentList = instance
                    return copy
                })
                saveItemsRecursively(copies, iterator: 0, completion: {
                    success(instance)
                    }, failure: { error in
                        failure(error)
                })
                }, failure: { error in
                    failure(error)
            })
        }
    }
    
    class func saveItemsRecursively(items:[Item], iterator: Int, completion:()->Void, failure:(NSError)->Void) {
        // TODO: Research batch save and/or putting this logic in cloud box
        if iterator < items.count {
            items[iterator].saveWithCompletionBlock() { error in
                if error == nil {
                    saveItemsRecursively(items, iterator: iterator + 1, completion: completion, failure: failure)
                } else {
                    failure(error)
                }
            }
        } else {
            completion()
        }
    }
    
    // MARK: Update Lists
    
    class func updateList(list:List, success:()->Void, failure:(NSError)->Void) {
        list.saveWithCompletionBlock() { error in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Delete Lists
    
    class func deleteList(list:List, success:(List)->Void, failure:(NSError)->Void) {
        list.deleteWithCompletion() { error in
            if error == nil {
                success(list)
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Get Items
    
    class func getAllItemsForList(parentListId:NSNumber, success:([Item])->Void, failure:(NSError)->Void) {
        let itemPredicate = SCPredicate.whereKey("parentList", isEqualToNumber: parentListId)
        Item.please().giveMeDataObjectsWithPredicate(itemPredicate, parameters: nil) { results, error in
            if error == nil {
                let items = results.map({ $0 as! Item })
                success(items)
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Create Items
    
    class func createItemWithName(name:String, parentList:List, success:(Item)->Void, failure:(NSError)->Void) {
        let newItem = Item()
        newItem.name = name
        newItem.info = "New Item"
        newItem.checked = false
        newItem.parentList = parentList
        newItem.saveWithCompletionBlock() { error in
            if error == nil {
                success(newItem)
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Update Items
    
    class func updateItem(item:Item, success:()->Void, failure:(NSError)->Void) {
        item.saveWithCompletionBlock() { error in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Delete Items
    
    class func deleteItem(item:Item, success:()->Void, failure:(NSError)->Void) {
        item.deleteWithCompletion() { error in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        }
    }
}
