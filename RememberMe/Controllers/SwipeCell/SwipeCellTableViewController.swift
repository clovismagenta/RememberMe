//
//  SwipeCellTableViewController.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class SwipeCellTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var sourceIndexPath : IndexPath!
    let realmConnection = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none

    }
    
    // MARK: - Swipe Delegate Method
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, swipeIndexPath) in
            
            self.updateModel(atIndexPath: swipeIndexPath, withOption: "D")

        }
        
        return [deleteAction]
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let swipeCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        
        swipeCell.delegate = self
        
        return swipeCell
    }
    
    func updateModel( atIndexPath: IndexPath, withOption : String) {
        
    }
}
