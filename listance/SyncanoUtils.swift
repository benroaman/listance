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
    
    class func getAllTemplates(success:([ListSync])->Void, failure:(NSError?)->Void) {
        getAllLists(true, success: success, failure: failure)
    }
    
    class func getAllListances(success:([ListSync])->Void, failure:(NSError?)->Void) {
        getAllLists(false, success: success, failure: failure)
    }
    
    class func getAllLists(getTemplates:Bool, success:([ListSync])->Void, failure:(NSError?)->Void) {
        let templatePredicate = SCPredicate.whereKey("isTemplate", isEqualToBool: getTemplates)
        ListSync.please().giveMeDataObjectsWithPredicate(templatePredicate, parameters: nil) { results, error in
            if let resultsUnwrapped = results where error == nil {
                let templates = resultsUnwrapped.map({ $0 as! ListSync })
                success(templates)
            } else {
                failure(error)
            }
        }
    }
    
    class func getAllSublistsForList(parentListId:NSNumber, success:([ListSync])->Void, failure:(NSError?)->Void) {
        let templatePredicate = SCPredicate.whereKey("parentList", isEqualToNumber: parentListId)
        ListSync.please().giveMeDataObjectsWithPredicate(templatePredicate, parameters: nil) { results, error in
            if let resultsUnwrapped = results where error == nil {
                let templates = resultsUnwrapped.map({ $0 as! ListSync })
                success(templates)
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Create Lists
    
    class func createTemplateList(name:String, success:(ListSync)->Void, failure:(NSError?)->Void) {
        let newTemplate = ListSync()
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
    
    class func createSublistWithName(name:String, parentList:ListSync, success:(ListSync)->Void, failure:(NSError?)->Void) {
        let newSublist = ListSync()
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
    
    class func instantiateListFromTemplate(list:ListSync, success:(ListSync)->Void, failure:(NSError?)->Void) {
        let instance = ListSync()
        instance.name = list.name
        instance.info = list.info
        instance.isTemplate = false
        if let listId = list.objectId {
            instance.saveWithCompletionBlock() { error in
                getAllItemsForList(listId, success: { items in
                    let copies: [ItemSync] = items.map({
                        let copy = ItemSync()
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
    }
    
    class func saveItemsRecursively(items:[ItemSync], iterator: Int, completion:()->Void, failure:(NSError?)->Void) {
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
    
    class func updateList(list:ListSync, success:()->Void, failure:(NSError?)->Void) {
        list.saveWithCompletionBlock() { error in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Delete Lists
    
    class func deleteList(list:ListSync, success:(ListSync)->Void, failure:(NSError?)->Void) {
        list.deleteWithCompletion() { error in
            if error == nil {
                success(list)
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Get Items
    
    class func getAllItemsForList(parentListId:NSNumber, success:([ItemSync])->Void, failure:(NSError?)->Void) {
        let itemPredicate = SCPredicate.whereKey("parentList", isEqualToNumber: parentListId)
        ItemSync.please().giveMeDataObjectsWithPredicate(itemPredicate, parameters: nil) { results, error in
            if let resultsUnwrapped = results where error == nil {
                let items = resultsUnwrapped.map({ $0 as! ItemSync })
                success(items)
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Create Items
    
    class func createItemWithName(name:String, parentList:ListSync, success:(ItemSync)->Void, failure:(NSError?)->Void) {
        let newItem = ItemSync()
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
    
    class func updateItem(item:ItemSync, success:()->Void, failure:(NSError?)->Void) {
        item.saveWithCompletionBlock() { error in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    // MARK: Delete Items
    
    class func deleteItem(item:ItemSync, success:()->Void, failure:(NSError?)->Void) {
        item.deleteWithCompletion() { error in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        }
    }
}
