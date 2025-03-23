//
//  AddItemViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-15.
//

import UIKit

protocol AddItemDelegate: AnyObject {
    func didAddItem(name: String, price: Double)
}

class AddItemViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet var typeButtons: [UIButton]!

    weak var delegate: AddItemDelegate?

    var selectedCategory: String?
    var selectedCategoryColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        print("🔍 Debug: taxLabel is \(taxLabel == nil ? "NIL ❌" : "CONNECTED ✅")")
        print("🔍 Debug: fullPriceLabel is \(fullPriceLabel == nil ? "NIL ❌" : "CONNECTED ✅")")

        taxLabel?.text = "Tax: $0.00"
        fullPriceLabel?.text = "Full Price: $0.00"

        priceInput.addTarget(self, action: #selector(updatePriceDetails), for: .editingChanged)
        updateDropDownButton()
    }

    @objc func updatePriceDetails() {
        guard let priceText = priceInput.text, let price = Double(priceText), price > 0 else {
            taxLabel?.text = "Tax: $0.00"
            fullPriceLabel?.text = "Full Price: $0.00"
            return
        }

        let taxRate = 0.13
        let taxAmount = price * taxRate
        let totalPrice = price + taxAmount

        print("✅ Price: \(price), Tax: \(String(format: "%.2f", taxAmount)), Full Price: \(String(format: "%.2f", totalPrice))")

        taxLabel?.text = "Tax: $\(String(format: "%.2f", taxAmount))"
        fullPriceLabel?.text = "Full Price: $\(String(format: "%.2f", totalPrice))"
    }

    func showTypeButtons() {
        typeButtons.forEach { button in
            button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func dropDownAction(_ sender: Any) {
        showTypeButtons()
    }

    @IBAction func typeButtonAction(_ sender: UIButton) {
        selectedCategory = sender.currentTitle ?? "Category"
        selectedCategoryColor = sender.backgroundColor
        print("✅ selectedCategory set to: \(selectedCategory ?? "nil")")
        updateDropDownButton()
        showTypeButtons()
        print("✅ typeButtonAction called. Selected category: \(selectedCategory ?? "Unknown")")
        showCategorySelectedAlert() // Add this line
    }

    @IBAction func add_Item(_ sender: Any) {
        guard let name = nameInput.text, !name.isEmpty,
              let priceText = priceInput.text, let price = Double(priceText), price > 0 else {
            showAlert(message: "Please enter a valid item name and price.")
            return
        }

        let taxRate = 0.13
        let taxAmount = price * taxRate
        let totalPrice = price + taxAmount

        print("✅ Adding item: \(name) - Original Price: $\(price) | Tax: $\(String(format: "%.2f", taxAmount)) | Total Price: $\(String(format: "%.2f", totalPrice))")

        delegate?.didAddItem(name: name, price: totalPrice)
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func updateDropDownButton() {
        print("✅ updateDropDownButton called. Selected category: \(selectedCategory ?? "nil")")
        dropDownButton.setTitle(selectedCategory ?? "Select Category", for: .normal)

        if let category = selectedCategory {
            switch category {
            case "Meat":
                dropDownButton.backgroundColor = UIColor.red
            case "Vegetables":
                dropDownButton.backgroundColor = UIColor.green
            case "Drinks":
                dropDownButton.backgroundColor = UIColor.gray
            case "Dairy":
                dropDownButton.backgroundColor = UIColor.brown
            case "Bakery":
                dropDownButton.backgroundColor = UIColor.orange
            case "Snacks":
                dropDownButton.backgroundColor = UIColor.yellow
            case "Frozen Foods":
                dropDownButton.backgroundColor = UIColor.blue
            default:
                dropDownButton.backgroundColor = UIColor.gray
            }
        } else {
            dropDownButton.backgroundColor = UIColor.gray
        }
    }

    private func showCategorySelectedAlert() { // Add this function
        let alert = UIAlertController(title: "Category Selected", message: "Category successfully selected!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
