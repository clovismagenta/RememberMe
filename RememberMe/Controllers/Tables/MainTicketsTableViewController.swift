//
//  MainTicketsTableViewController.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import DropDown

class MainTicketsTableViewController: SwipeCellTableViewController {

    private var ticketsList : Results<Tickets>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        loadTickets()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketsList?.count ?? 1
    }

    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let posCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        posCell.textLabel?.text = ticketsList?[indexPath.row].ticketDescription ?? "There is nothing to show"

        return posCell
    }
    
    // MARK: - Segue preparation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let itemView = segue.destination as! ItemsTableViewController
        
        if let indexLineSelected = tableView.indexPathForSelectedRow {
            itemView.selectedTicket = ticketsList?[indexLineSelected.row]
        }
        
    }
    // MARK: - Data manipulation Methods - on RealmDB
    
    private func commitTicket( thisTicket : Tickets ) {
        
        do {
            try realmConnection.write {
                realmConnection.add(thisTicket)
            }
        } catch {
            print("erro during commit Ticket: \(error)")
        }

    }
    
    private func deleteTicket( thisTicket : Tickets ) {
        
        do {
            try realmConnection.write {
                realmConnection.delete(thisTicket)
            }
        } catch {
            print("error during deletion process: \(error)")
        }
        
    }
    
    override func updateModel(atIndexPath : IndexPath, withOption : String) {
        
        if withOption == "D" {
            guard let ticketPos = ticketsList?[atIndexPath.row] else { fatalError("Cell without value! - Empty") }
            
            let numOfItems = ticketPos.myItems.count
            // Here we need to valid if this Ticket has one or more Items inside. User must to confirm deletion
            if numOfItems > 0 {
            
                let deleteAlert = UIAlertController(title: "Atenttion!", message: "This ticket has items. Proceed with deletion?", preferredStyle: .alert)
                let positiveAction = UIAlertAction(title: "Confirm", style: .default) { (confirmAlert) in
                    
                    for item in ticketPos.myItems {
                        self.deleteSubItem( thisItem : item )
                    }
                    self.deleteTicket(thisTicket: ticketPos )
                    self.loadTickets()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancAction) in
                    
                }
                
                deleteAlert.addAction(positiveAction)
                deleteAlert.addAction(cancelAction)
                
                present(deleteAlert, animated: true)
                
            } else {
                self.deleteTicket(thisTicket: ticketPos )
                self.loadTickets()
            }
        }
    }
    
    private func loadTickets() {

        ticketsList = realmConnection.objects( Tickets.self )
        tableView.reloadData()
        
    }
    
    private func deleteSubItem(thisItem: Item) {
        
        do {
            try realmConnection.write {
                realmConnection.delete( thisItem )
            }
        } catch {
            print("Error - Cannot delete subItems: \(error)")
        }
    }
    // MARK: - IBAction
    
    @IBAction func addTicket(_ sender: Any) {
        
        var outTextField = UITextField()
        
        let alert = UIAlertController(title: "New Ticket", message: "Please inform your new Ticket's Name", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textfield) in
            textfield.placeholder = "New Ticket Description"
            outTextField = textfield
        })
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newTicket = Tickets()
            
            if let descr = outTextField.text {
                newTicket.ticketDescription = descr
                newTicket.ticketDone = false
                
                self.commitTicket(thisTicket: newTicket)
                self.loadTickets()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
}
