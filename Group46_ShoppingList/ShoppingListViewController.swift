//
//  ShoppingListViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-15.
//

import UIKit

class ShoppingListViewController: UITableViewController, AddItemDelegate {

    var shoppingList: [(name: String, price: Double, category: String?)] = [] // Added category

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)

        let item = shoppingList[indexPath.row]
        if let category = item.category {
            cell.textLabel?.text = "\(item.name) - $\(String(format: "%.2f", item.price)) - \(category)"
        } else {
            cell.textLabel?.text = "\(item.name) - $\(String(format: "%.2f", item.price))"
        }

        return cell
    }

    @IBAction func toAddItem(_ sender: Any) {
        performSegue(withIdentifier: "additem", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "additem",
           let addItemVC = segue.destination as? AddItemViewController {
            addItemVC.delegate = self
        }
    }

    func didAddItem(name: String, price: Double, category: String) { // Added category
        print("🛒 Received item: \(name) - $\(price) - Category: \(category)")
        shoppingList.append((name, price, category))
        tableView.reloadData()
    }
}
