//
//  TableViewController.swift
//  listance
//
//  Created by Ben Roaman on 7/29/16.
//  Copyright © 2016 Ben Roaman. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    // MARK: Instance Variables
    
    var zeroItemExplanationText = ""
    var zeroItemInstructionText = ""
    var showingZeroItemView = false
    
    // MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: Public Functions
    
    func handleZeroItemView(count:Int) {
        switch count {
        case 0:
            if !showingZeroItemView {
                if let zeroItemView = NSBundle.mainBundle().loadNibNamed("ZeroItemView", owner: self, options: nil)[0] as? ZeroItemView {
                    zeroItemView.explainLabel.text = zeroItemExplanationText
                    zeroItemView.instructionLabel.text = zeroItemInstructionText
                    tableView.backgroundView = zeroItemView
                    tableView.separatorStyle = .None
                    showingZeroItemView = true
                }                
            }
        default:
            if showingZeroItemView {
                tableView.backgroundView = UIView()
                tableView.separatorStyle = .SingleLine
                showingZeroItemView = false
            }
        }
    }
}
