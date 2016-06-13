//
//  ListanceViewController.swift
//  listance
//
//  Created by Ben Roaman on 5/1/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class ListancesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Reuse Identifiers
    
    let listanceTableViewCellReuseIdentifier = "ListanceTableViewCell"
    
    // MARK: Segue Identifiers
    
    let viewListanceSegueIdentifier = "ViewListanceSegueIdentifier"
    
    // MARK: Instance Variables

    var listances: [List] = []
    private var listanceToEdiit: List?
    
    // MARK: Outlets
    
    @IBOutlet var listancesTableView: UITableView!
    
    // MARK: Actions
    
    @IBAction func addAction(sender: AnyObject) {
        
    }
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listancesTableView.dataSource = self
        listancesTableView.delegate = self
        //        templatesTableView.allowsSelection = false
        listancesTableView.allowsMultipleSelectionDuringEditing = false
        let indicator = IndicatorUtils.addScreenCoveringActivityIndicator(self, color: UIColor.withHexValue(AppColors.aqua))
        SyncanoUtils.getAllListances({ results in
            self.listances = results
            self.listancesTableView.reloadData()
            indicator.removeFromSuperview()
            }, failure: { error in
                indicator.removeFromSuperview()
                self.dataGetFailure(error)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == viewListanceSegueIdentifier {
            if let viewListanceViewController = segue.destinationViewController as? ListViewController {
                viewListanceViewController.list = listanceToEdiit
                viewListanceViewController.isInstance = true
            }
        }
    }
    
    // MARK: UITableViewDataSource Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listances.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(listanceTableViewCellReuseIdentifier) as? ListanceTableViewCell {
            cell.configure(listances[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: UITableViewDelefate Functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.transitionToViewViewForListance(listances[indexPath.row])
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction()]
    }
    
    // MARK: Private Functions
    
    func transitionToViewViewForListance(listance:List) {
        self.listanceToEdiit = listance
        self.performSegueWithIdentifier(self.viewListanceSegueIdentifier, sender: nil)
    }
}
