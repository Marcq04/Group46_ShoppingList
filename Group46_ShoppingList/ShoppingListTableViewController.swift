//  ShoppingListTableViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-28.
//

import UIKit

class ShoppingListTableViewController: UITableViewController, AddItemDelegate, AddItemToCategoryDelegate, AddCategoryDelegate {

    var categories: [String] = []

    func didUpdateCategories(_ categories: [String]) {
        self.categories = categories
        updateCategoryStackView()
    }

    func didAddItemToCategory(itemName: String, price: Double) {
        print("✅ Item added to category: \(itemName) - $\(price)")
    }

    var shoppingList: [(name: String, price: Double, category: String?)] = [] // Added category

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddItem))
        view.addSubview(categoryStackView)
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc func goToAddItem(_ sender: Any?) {
        performSegue(withIdentifier: "goToAddItem", sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("🗑 Deleting item: \(shoppingList[indexPath.row].name)")
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            print("🗑 Swipe Delete item: \(self.shoppingList[indexPath.row].name)")
            self.shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddItem",
           let addItemVC = segue.destination as? AddItemViewController {
            addItemVC.delegate = self
        } else if segue.identifier == "goToAddCategory",
                  let addCategoryVC = segue.destination as? AddCategoryViewController,
                  let selectedItem = sender as? (name: String, price: Double, category: String?) {
            print("📂 Passing categories: \(categories)")
            addCategoryVC.categories = categories
            addCategoryVC.itemDelegate = self
            addCategoryVC.selectedItem = (selectedItem.name, selectedItem.price) // Create a tuple without category
        }
    }

    func didAddItem(name: String, price: Double, category: String) {
        print("🛒 Received item: \(name) - $\(price) - Category: \(category)")
        shoppingList.append((name, price, category))
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = shoppingList[indexPath.row]
        performSegue(withIdentifier: "goToAddCategory", sender: selectedItem)
    }

    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private func updateCategoryStackView() {
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for category in categories {
            let label = UILabel()
            label.text = category
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            categoryStackView.addArrangedSubview(label)
        }
    }
}
