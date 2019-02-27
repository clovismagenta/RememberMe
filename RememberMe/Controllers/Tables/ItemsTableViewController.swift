//
//  ItemsTableViewController.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift
import DropDown

class ItemsTableViewController: SwipeCellTableViewController {

    var selectedTicket : Tickets? {
        didSet{
            loadItem()
        }
    }
    
    private var itemsList : Results<Item>?
    private var pressureRecognize : UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        pressureRecognize = UILongPressGestureRecognizer(target: self, action: #selector( pressureCellAction( sender:) ))
        
//        tableView.addGestureRecognizer(pressureRecognize)

    }

    // MARK : Gesture Functions
    @objc func pressureCellAction( sender : UILongPressGestureRecognizer ) {
        
        let state = sender.state
        let tappedPoint = sender.location(in: tableView)
        
        switch state {
        case .began:
            showOptions( atPoint: tappedPoint )
        default:
            break
        }
        
    }
    
    func showOptions( atPoint : CGPoint ) {
        
        let dropdown = DropDown()
        let centerPoint = CGPoint(x: tableView.center.x, y: atPoint.y)
        
        dropdown.dataSource = ["Details", "Edit", "Delete"]
        dropdown.anchorView = tableView
        dropdown.bottomOffset = centerPoint
        DropDown.appearance().cornerRadius = 10
        dropdown.show()
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsList?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let swipeCell = super.tableView(tableView, cellForRowAt: indexPath)

        if let actualItem = itemsList?[indexPath.row] {

            swipeCell.textLabel?.text = actualItem.itemDescription
            swipeCell.accessoryType = actualItem.itemDone ? .checkmark : .none
        }
        swipeCell.addGestureRecognizer(pressureRecognize)
        
        return swipeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let itemPos = itemsList?[indexPath.row] {
            let cell = tableView.cellForRow(at: indexPath)
            
            updateModel(atIndexPath: indexPath, withOption: "M") // M = Mark
            cell?.accessoryType = itemPos.itemDone ? .checkmark : .none
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
        }
        
    }
    
    // MARK: - RealmDB interaction Methods

    private func commitItem( thisItem : Item ) {
        
        do {
            try realmConnection.write {
                realmConnection.add( thisItem )
                self.selectedTicket?.myItems.append( thisItem )
            }
        } catch {
            print("Error during creating an Item: \(error)")
        }
    }
    
    private func deleteItem( thisItem : Item ) {
        
        do {
            try realmConnection.write {
                realmConnection.delete( thisItem )
            }
        } catch {
            print("Error trying to delete an Item: \(error)")
        }
        
    }
    override func updateModel(atIndexPath: IndexPath, withOption : String ) {
        
        guard let item = itemsList?[atIndexPath.row] else { fatalError("item not founded on UPDATE process") }

        if withOption == "D" {
            
            deleteItem(thisItem: item)
            loadItem()
        } else if withOption == "M" {
            
            do {
                try realmConnection.write {
                    item.itemDone = !item.itemDone
                }
            } catch {
                print("Erro on MARK an Item row at click: \(error)")
            }
        }
    }
    
    private func loadItem() {
        
        if let ticket = selectedTicket {
            itemsList = ticket.myItems.sorted(byKeyPath: "itemDescription", ascending: true)
        }

        tableView.reloadData()

    }

    // MARK: - IBAction "+"
    
    @IBAction func addItemPressed(_ sender: Any) {
        
        var globalUIText = UITextField()
        
        let itemAlert = UIAlertController(title: "New Item", message: "What do you need to remember?", preferredStyle: .alert)
        
        let itemAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            
            if let descri = globalUIText.text {
                
                if !descri.isEmpty {
                    let newItem = Item()
                    newItem.itemDescription = descri
                    newItem.itemDone = false
                    newItem.dateCreated = Date()
                    
                    self.commitItem(thisItem: newItem)
                    self.loadItem()
                }
            }
            
        }
        
        itemAlert.addTextField { (textField) in
            
            textField.placeholder = "Type here..."
            globalUIText = textField
        }
        
        itemAlert.addAction(itemAction)
        
        present(itemAlert, animated: true)
        
    }
    
}
