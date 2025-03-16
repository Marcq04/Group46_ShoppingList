//  ShoppingListTableViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-28.
//

import UIKit

class ShoppingListTableViewController: UITableViewController, AddItemDelegate, AddItemToCategoryDelegate {
    func didAddItemToCategory(itemName: String, price: Double) {
        print("✅ Item added to category: \(itemName) - $\(price)")
    }
    

    var shoppingList: [(name: String, price: Double)] = [] // Store shopping list items

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddItem))
    }

    @objc func goToAddItem(_ sender: Any?) {
        performSegue(withIdentifier: "goToAddItem", sender: self)
    }
    
    
    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Ensure there's at least 1 section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count // Show the correct number of items
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) // ✅ Updated Identifier
        
        let item = shoppingList[indexPath.row]
        cell.textLabel?.text = "\(item.name) - $\(String(format: "%.2f", item.price))"
        
        return cell
    }

    // ✅ MARK: - Enable Swipe-to-Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("🗑 Deleting item: \(shoppingList[indexPath.row].name)") // Debugging

            // Remove item from the shopping list
            shoppingList.remove(at: indexPath.row)
            
            // Delete row from table view with animation
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // ✅ MARK: - Alternative: Swipe Delete Button
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            print("🗑 Swipe Delete item: \(self.shoppingList[indexPath.row].name)") // Debugging
            
            // Remove item from array
            self.shoppingList.remove(at: indexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // MARK: - Delegate Connection

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddItem",
           let addItemVC = segue.destination as? AddItemViewController {
            addItemVC.delegate = self
        } else if segue.identifier == "goToAddCategory",
                  let addCategoryVC = segue.destination as? AddCategoryViewController,
                  let selectedItem = sender as? (name: String, price: Double) {
            addCategoryVC.itemDelegate = self
            addCategoryVC.selectedItem = selectedItem // Pass the selected item
        }
    }


    // MARK: - Receive Added Item
    func didAddItem(name: String, price: Double) {
        print("🛒 Received item: \(name) - $\(price)") // Debugging

        shoppingList.append((name, price)) // Add item to list
        tableView.reloadData() // Refresh table view
    }
    // MARK: - goToAddCategory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = shoppingList[indexPath.row]
            performSegue(withIdentifier: "goToAddCategory", sender: selectedItem)
        /*
        let itemName = selectedItem.name
        let itemPrice = selectedItem.price

        print("🛍 Selected item: \(itemName) - $\(itemPrice)")

        if let addCategoryVC = storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as? AddCategoryViewController {
                addCategoryVC.itemDelegate = self
                addCategoryVC.didAddItemToCategory(itemName: itemName, price: itemPrice) // ✅ Add item immediately
                navigationController?.pushViewController(addCategoryVC, animated: true)
            }
         */
    }
}
