//  AddCategoryViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-28.
//

import UIKit

protocol AddCategoryDelegate: AnyObject {
    func didUpdateCategories(_ categories: [String])
}

protocol AddItemToCategoryDelegate: AnyObject {
    func didAddItemToCategory(itemName: String, price: Double, category: String)
}

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var categoryStackView: UIStackView! // Reference to StackView inside UIScrollView
    
    var categories: [String] = []
    
    weak var delegate: AddCategoryDelegate?
    weak var itemDelegate: AddItemToCategoryDelegate?
    var selectedItem: (name: String, price: Double)? // Store the selected item
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 🧠 Load saved categories if available
        if let saved = UserDefaults.standard.stringArray(forKey: "savedCategories") {
            categories = saved
        }

        print("📂 Categories on load: \(categories)")

        if let item = selectedItem, let defaultCategory = categories.first {
            DispatchQueue.main.async {
                self.didAddItemToCategory(itemName: item.name, price: item.price, category: defaultCategory)
            }
        }

        for category in categories {
            addCategoryToScrollView(category)
        }
    }
    
    @IBAction func go_Back(_ sender: Any) {
        delegate?.didUpdateCategories(categories) // Send updated categories list
        dismiss(animated: true, completion: nil)
    }

    @IBAction func add_Category(_ sender: Any) {
        guard let categoryName = categoryInput.text, !categoryName.isEmpty else {
            showAlert(message: "Please enter a category name.")
            return
        }

        if !categories.contains(categoryName) {
            categories.append(categoryName)
            addCategoryToScrollView(categoryName)
            delegate?.didUpdateCategories(categories)

            // 🔒 Save to UserDefaults
            UserDefaults.standard.set(categories, forKey: "savedCategories")
            
            view.layoutIfNeeded()
        } else {
            showAlert(message: "Category already exists.")
        }
    }

    func addCategoryToScrollView(_ categoryName: String) {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill

        let categoryLabel = UILabel()
        categoryLabel.text = categoryName
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        categoryLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        categoryLabel.textAlignment = .center
        categoryLabel.layer.cornerRadius = 6
        categoryLabel.clipsToBounds = true
        categoryLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        categoryLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // Buttons
        let upButton = UIButton(type: .system)
        upButton.setTitle("⬆️", for: .normal)
        upButton.addTarget(self, action: #selector(moveViewUp(_:)), for: .touchUpInside)

        let downButton = UIButton(type: .system)
        downButton.setTitle("⬇️", for: .normal)
        downButton.addTarget(self, action: #selector(moveViewDown(_:)), for: .touchUpInside)

        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("🗑", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteCategory(_:)), for: .touchUpInside)

        // Compose
        horizontalStack.addArrangedSubview(categoryLabel)
        horizontalStack.addArrangedSubview(upButton)
        horizontalStack.addArrangedSubview(downButton)
        horizontalStack.addArrangedSubview(deleteButton)

        // Add to main stack
        categoryStackView.addArrangedSubview(horizontalStack)
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }

    func didAddItemToCategory(itemName: String, price: Double, category: String) {
        let itemStack = UIStackView()
        itemStack.axis = .horizontal
        itemStack.spacing = 6
        itemStack.alignment = .center

        let itemLabel = UILabel()
        itemLabel.text = "\(itemName) - $\(String(format: "%.2f", price))"
        itemLabel.font = UIFont.systemFont(ofSize: 14)
        itemLabel.textColor = .darkGray
        itemLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let upItemBtn = UIButton(type: .system)
        upItemBtn.setTitle("⬆️", for: .normal)
        upItemBtn.addTarget(self, action: #selector(moveViewUp(_:)), for: .touchUpInside)

        let downItemBtn = UIButton(type: .system)
        downItemBtn.setTitle("⬇️", for: .normal)
        downItemBtn.addTarget(self, action: #selector(moveViewDown(_:)), for: .touchUpInside)

        let deleteItemBtn = UIButton(type: .system)
        deleteItemBtn.setTitle("❌", for: .normal)
        deleteItemBtn.addTarget(self, action: #selector(deleteItem(_:)), for: .touchUpInside)

        itemStack.addArrangedSubview(itemLabel)
        itemStack.addArrangedSubview(upItemBtn)
        itemStack.addArrangedSubview(downItemBtn)
        itemStack.addArrangedSubview(deleteItemBtn)

        categoryStackView.addArrangedSubview(itemStack)
    }
    
    @objc private func deleteCategory(_ sender: UIButton) {
        guard let stack = sender.superview as? UIStackView,
              let label = stack.arrangedSubviews.first as? UILabel,
              let name = label.text else { return }

        let alert = UIAlertController(title: "Delete Category",
                                      message: "Delete \"\(name)\"?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.categoryStackView.removeArrangedSubview(stack)
            stack.removeFromSuperview()

            if let index = self.categories.firstIndex(of: name) {
                self.categories.remove(at: index)
                UserDefaults.standard.set(self.categories, forKey: "savedCategories")
                self.delegate?.didUpdateCategories(self.categories)
            }
        }))
        present(alert, animated: true)
    }

    @objc private func deleteItem(_ sender: UIButton) {
        guard let stack = sender.superview as? UIStackView else { return }
        categoryStackView.removeArrangedSubview(stack)
        stack.removeFromSuperview()
    }
    
    @objc private func moveViewUp(_ sender: UIButton) {
        guard let view = sender.superview as? UIStackView,
              let index = categoryStackView.arrangedSubviews.firstIndex(of: view),
              index > 0 else { return }

        categoryStackView.removeArrangedSubview(view)
        view.removeFromSuperview()
        categoryStackView.insertArrangedSubview(view, at: index - 1)
    }

    @objc private func moveViewDown(_ sender: UIButton) {
        guard let view = sender.superview as? UIStackView,
              let index = categoryStackView.arrangedSubviews.firstIndex(of: view),
              index < categoryStackView.arrangedSubviews.count - 1 else { return }

        categoryStackView.removeArrangedSubview(view)
        view.removeFromSuperview()
        categoryStackView.insertArrangedSubview(view, at: index + 1)
    }
}
