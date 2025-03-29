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

        if let item = selectedItem {
            didAddItemToCategory(itemName: item.name, price: item.price)
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

    private func addCategoryToScrollView(_ categoryName: String) {
        guard let stackView = categoryStackView else {
            print("🚨 categoryStackView is nil when trying to add a category!")
            return
        }

        print("✅ Adding category to StackView: \(categoryName)") // Debugging

        let categoryLabel = UILabel()
        categoryLabel.text = categoryName
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        categoryLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        categoryLabel.layer.cornerRadius = 5
        categoryLabel.clipsToBounds = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        categoryLabel.isUserInteractionEnabled = true // Enable taps

        // 👇 Add Tap Gesture for deleting
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCategoryTap(_:)))
        categoryLabel.addGestureRecognizer(tapGesture)

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
    
    @objc private func handleCategoryTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let categoryName = label.text else { return }

        let alert = UIAlertController(
            title: "Delete Category",
            message: "Are you sure you want to delete \"\(categoryName)\"?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // 🧹 Remove from UI
            self.categoryStackView.removeArrangedSubview(label)
            label.removeFromSuperview()

            // 🧠 Remove from array
            if let index = self.categories.firstIndex(of: categoryName) {
                self.categories.remove(at: index)
            }

            // 💾 Update UserDefaults
            UserDefaults.standard.set(self.categories, forKey: "savedCategories")
            
            // 🔁 Inform delegate (if needed)
            self.delegate?.didUpdateCategories(self.categories)
        }))

        present(alert, animated: true)
    }
}
