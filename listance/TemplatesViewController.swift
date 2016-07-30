//
//  TemplatesViewController.swift
//  listance
//
//  Created by Ben Roaman on 4/27/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class TemplatesViewController: TableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Segue Identifiers
    
    private let editTemplateSegueIdentifier = "EditTemplateSegueIdentifier"
    
    // MARK: Instance Variables
    
    private var templates: [ListSync] = [] {
        didSet {
            handleZeroItemView(templates.count)
        }
    }
    private var templateToEdit: ListSync?
    private var showingZeroItem = false
    
    // MARK: Actions
    
    @IBAction func addButtonAction(sender: AnyObject) {
        AlertUtils.generateTextInputAlert(self, title: "Create List Template", placeholder: "template name", confirmTitle: "Create") { text in
            SyncanoUtils.createTemplateList(text, success: { template in
                self.templates.append(template)
                self.tableView.reloadData()
                // TODO: Perform segue to newly created template edit view
                }, failure: { error in
                    if let e = error {
                        AlertUtils.generateSingleOptionAlert(self, title: "Uh Oh!", message: "Sorry, creation failed :(" + e.localizedDescription, actionTitle: "Okay", handler: nil)
                    }
            })
        }
    }
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zeroItemExplanationText = NSLocalizedString("templatesZeroItemViewExplanation", comment: "")
        zeroItemInstructionText = NSLocalizedString("templatesZeroItemViewInstruction", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        //        templatesTableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        let indicator = IndicatorUtils.addScreenCoveringActivityIndicator(self, color: UIColor.withHexValue(AppColors.aqua))
        SyncanoUtils.getAllTemplates({ results in
            self.templates = results
            self.tableView.reloadData()
            indicator.removeFromSuperview()
            }, failure: { error in
                indicator.removeFromSuperview()
                self.dataGetFailure(error)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == editTemplateSegueIdentifier {
            if let editTemplateViewController = segue.destinationViewController as? ListViewController {
                editTemplateViewController.list = templateToEdit
                editTemplateViewController.isInstance = false
            }
            //            let backButton = UIBarButtonItem(title: "Templates", style: .Plain, target: nil, action: nil)
            //            backButton.setTintc
            //            self.navigationItem.backBarButtonItem = backButton
        }
    }
    
    // MARK: UITableViewDataSource Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("TemplateTableViewCell") as? TemplateTableViewCell {
            cell.configure(templates[indexPath.row])
            cell.onInstantiate = { template in
                let indicator = IndicatorUtils.addScreenCoveringActivityIndicator(self, color: UIColor.withHexValue(AppColors.aqua))
                AlertUtils.generateConfirmationAlert(self, message: "Create an instance of the template '" + self.templates[indexPath.row].name + "'?", callback: {
                    SyncanoUtils.instantiateListFromTemplate(self.templates[indexPath.row], success: { instance in
                        AlertUtils.generateSingleOptionAlert(self, title: "Success!", message: "The template '" + self.templates[indexPath.row].name + "' has been instantiated!", actionTitle: "Great!", handler: { action in
                            indicator.removeFromSuperview()
                            // TODO: transition to instance detail view
                        })}, failure: { error in
                            indicator.removeFromSuperview()
                            self.dataCreateFailure(error)
                    })
                })
            }
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.transitionToEditViewForTemplate(self.templates[indexPath.row])
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction.init(style: .Default, title: "Edit", handler: { action, indexPath in
            self.transitionToEditViewForTemplate(self.templates[indexPath.row])
        })
        editAction.backgroundColor = UIColor.withHexValue(AppColors.aqua)
        
        let deleteAction = UITableViewRowAction.init(style: .Normal, title: "Delete", handler: { action, indexPath in
            let template = self.templates[indexPath.row]
            AlertUtils.generateConfirmationAlert(self, message: "Delete the template '" + template.name + "'?", callback: {
                SyncanoUtils.deleteList(template, success: { list in
                    self.templates = self.templates.filter({ $0 != list })
                    self.tableView.reloadData()
                    }, failure: { error in
                        self.dataDeleteFailure(error)
                })
            })
        })
        
        deleteAction.backgroundColor = UIColor.withHexValue(AppColors.tomato)
        return [deleteAction, editAction]
    }
    
    // MARK: Private Function
    
    private func transitionToEditViewForTemplate(template:ListSync) {
        self.templateToEdit = template
        self.performSegueWithIdentifier(self.editTemplateSegueIdentifier, sender: nil)
    }
}
