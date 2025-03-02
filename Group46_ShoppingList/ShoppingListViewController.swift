//
//  ShoppingListViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-15.
//

import UIKit

class ShoppingListViewController: UITableViewController, AddItemDelegate {

    var shoppingList: [(name: String, price: Double)] = [] // Stores shopping list items

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Update the table view to display the added items
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        let item = shoppingList[indexPath.row]
        cell.textLabel?.text = "\(item.name) - $\(String(format: "%.2f", item.price))"
        
        return cell
    }

    // Perform Segue to AddItemViewController
    @IBAction func toAddItem(_ sender: Any) {
        performSegue(withIdentifier: "additem", sender: self)
    }

    // Pass the delegate to AddItemViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "additem",
           let addItemVC = segue.destination as? AddItemViewController {
            addItemVC.delegate = self
        }
    }

    // Receive the added item from AddItemViewController
    func didAddItem(name: String, price: Double) {
        print("🛒 Received item: \(name) - $\(price)") // Debugging

        shoppingList.append((name, price))
        tableView.reloadData() // Refresh the table view
    }
}
