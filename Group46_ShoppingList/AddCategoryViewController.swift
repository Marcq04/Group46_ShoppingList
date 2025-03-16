//  AddCategoryViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-28.
//

import UIKit

protocol AddCategoryDelegate: AnyObject {
    func didAddCategory(_ category: String)
}

protocol AddItemToCategoryDelegate: AnyObject {
    func didAddItemToCategory(itemName: String, price: Double)
}


class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var categoryStackView: UIStackView! // Reference to StackView inside UIScrollView
    
    var categories: [String] = []
    
    // MARK: - Add Category Delegate
    func didAddCategory(_ category: String) {
        categories.append(category)
        
    }
    
    
    weak var delegate: AddCategoryDelegate?
    weak var itemDelegate: AddItemToCategoryDelegate?
    var selectedItem: (name: String, price: Double)? // Store the selected item
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if there's a selected item, and populate the stack view
        if let item = selectedItem {
            didAddItemToCategory(itemName: item.name, price: item.price)
        }

        // Populate stack view with categories if any
        for category in categories {
            addCategoryToScrollView(category)
        }
    }
    
    @IBAction func go_Back(_ sender: Any) {
        // Pass the updated categories list back to the delegate
        delegate?.didAddCategory(categories.joined(separator: ", ")) // Or send a more suitable data structure
        dismiss(animated: true, completion: nil)
    }


    @IBAction func add_Category(_ sender: Any) {
        guard let categoryName = categoryInput.text, !categoryName.isEmpty else {
            showAlert(message: "Please enter a category name.")
            return
        }

        print("Added category: \(categoryName)")
        // Add new category to the data model
        categories.append(categoryName)
        
        // Add new category to the ScrollView's StackView
        addCategoryToScrollView(categoryName)
        delegate?.didAddCategory(categoryName)
    }

    private func addCategoryToScrollView(_ categoryName: String) {
        guard let stackView = categoryStackView else {
            print("🚨 categoryStackView is nil when trying to add a category!")
            return
        }

        let categoryLabel = UILabel()
        categoryLabel.text = categoryName
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        categoryLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        categoryLabel.layer.cornerRadius = 5
        categoryLabel.clipsToBounds = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        stackView.addArrangedSubview(categoryLabel)
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }

    func didAddItemToCategory(itemName: String, price: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let stackView = self.categoryStackView else {
                print("🚨 categoryStackView is nil or ViewController was dismissed!")
                return
            }

            let itemLabel = UILabel()
            itemLabel.text = "\(itemName) - $\(String(format: "%.2f", price))"
            itemLabel.textAlignment = .center
            itemLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            itemLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
            itemLabel.layer.cornerRadius = 5
            itemLabel.clipsToBounds = true
            itemLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

            stackView.addArrangedSubview(itemLabel)
        }
    }
}

