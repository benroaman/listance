//
//  EditTemplateViewController.swift
//  listance
//
//  Created by Ben Roaman on 4/28/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class ListViewController: TableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Segue Indentifiers
    
    let showItemDetailViewSegueIdentifier = "ShowItemDetailView"
    
    // MARK: Reuse Identifiers
    
    let itemTableViewCellReuseIdentifier = "ItemTableViewCell"
    
    // MARK: Instance Variables
    
    var list: ListSync?
    var items:[ItemSync] = [] {
        didSet {
            handleZeroItemView(items.count + sublists.count)
        }
    }
    var sublists:[ListSync] = [] {
        didSet {
            handleZeroItemView(items.count + sublists.count)
        }
    }
    var isInstance = false
    var itemToDetail: ItemSync?

    // MARK: Actions
    
    @IBAction func addAction(sender: AnyObject) {
        if let list = self.list {
            let addAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            addAlert.addAction(UIAlertAction(title: "Add Item", style: .Default, handler: { action in
                AlertUtils.generateTextInputAlert(self, title: "Create New Item", placeholder: "name", confirmTitle: "Create", callback: { text in
                    let indicator = IndicatorUtils.addScreenCoveringActivityIndicator(self, color: UIColor.withHexValue(AppColors.aqua))
                    SyncanoUtils.createItemWithName(text, parentList: list, success: { item in
                        self.items.append(item)
                        self.tableView.reloadData()
                        indicator.removeFromSuperview()
                        }, failure: { error in
                            indicator.removeFromSuperview()
                            self.dataCreateFailure(error)
                    })
                })
            }))
            addAlert.addAction(UIAlertAction(title: "Add Sublist", style: .Default, handler: { action in
                AlertUtils.generateTextInputAlert(self, title: "Create New Sublist", placeholder: "name", confirmTitle: "Create", callback: { text in
                    // Uncomment to enable sublist creation
                    //                    let indicator = IndicatorUtils.addScreenCoveringActivityIndicator(self, color: UIColor.withHexValue(AppColors.aqua))
                    //                    SyncanoUtils.createSublistWithName(text, parentList: list, success: { sublist in
                    //                        self.sublists.append(sublist)
                    //                        self.tableView.reloadData()
                    //                        indicator.removeFromSuperview()
                    //                        }, failure: { error in
                    //                            indicator.removeFromSuperview()
                    //                            self.dataCreateFailure(error)
                    //                    })
                })
            }))
            addAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(addAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zeroItemExplanationText = NSLocalizedString("listZeroItemViewExplanation", comment: "")
        zeroItemInstructionText = NSLocalizedString("listZeroItemViewInstruction", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.title = list?.name
        let indicator = IndicatorUtils.addScreenCoveringActivityIndicator(self, color: UIColor.withHexValue(AppColors.aqua))
        if let listId = self.list?.objectId {
            SyncanoUtils.getAllItemsForList(listId, success: { items in
                self.items = items
                SyncanoUtils.getAllSublistsForList(listId, success: { sublists in
                    self.sublists = sublists
                    self.tableView.reloadData()
                    indicator.removeFromSuperview()
                    }, failure: { error in
                        indicator.removeFromSuperview()
                        self.dataLoadFailure(indicator, error: error)
                })
                }, failure: { error in
                    indicator.removeFromSuperview()
                    self.dataLoadFailure(indicator, error: error)
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == showItemDetailViewSegueIdentifier {
            // TODO: Setup the item detail view
        }
    }
    
    // MARK: UITableViewDataSource Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + sublists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < items.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(itemTableViewCellReuseIdentifier) as! ItemTableViewCell
            cell.isInstance = isInstance
            cell.configure(self.items[indexPath.row])
            cell.onToggleItemChecked = {item, updatUI in
                if let item = item {
                    item.checked = !item.checked
                    let indicator = IndicatorUtils.addScreenCoveringActivityIndicator(self, color: UIColor.withHexValue(AppColors.aqua))
                    SyncanoUtils.updateItem(item, success: {
                        indicator.removeFromSuperview()
                        updatUI(item.checked)
                        }, failure: { error in
                            indicator.removeFromSuperview()
                            self.dataUpdateFailure(error)
                    })
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        transitionToEditViewForItem(items[indexPath.row])
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if indexPath.row < items.count {
            // Set up row actions for item rows
            let item = self.items[indexPath.row]
            let editAction = UITableViewRowAction.init(style: .Default, title: "Edit", handler: { action, indexPath in
                self.transitionToEditViewForItem(item)
            })
            editAction.backgroundColor = UIColor.withHexValue(AppColors.aqua)
            
            let deleteAction = UITableViewRowAction.init(style: .Normal, title: "Delete", handler: { action, indexPath in
                AlertUtils.generateConfirmationAlert(self, message: "Delete the item '" + item.name + "'?", callback: {
                    SyncanoUtils.deleteItem(item, success: { list in
                        self.items = self.items.filter({ $0 != item })
                        self.tableView.reloadData()
                        }, failure: { error in
                            self.dataDeleteFailure(error)
                    })
                })
            })
            
            deleteAction.backgroundColor = UIColor.withHexValue(AppColors.tomato)
            return [deleteAction, editAction]
        } else {
            // TODO: Set up row actions for sublist rows
            return [UITableViewRowAction()]
        }
    }
    
    // MARK: Private Functions
    
    private func transitionToEditViewForItem(item:ItemSync) {
        itemToDetail = item
        self.performSegueWithIdentifier(showItemDetailViewSegueIdentifier, sender: nil)
    }
    
    private func dataLoadFailure(indicator: UIView, error: NSError?) {
        indicator.removeFromSuperview()
        self.dataGetFailure(error)
    }
}
