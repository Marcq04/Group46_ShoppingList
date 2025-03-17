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
    @IBOutlet weak var taxLabel: UILabel! // Label for tax amount
    @IBOutlet weak var fullPriceLabel: UILabel! // Label for full price
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet var typeButtons: [UIButton]!
    
    weak var delegate: AddItemDelegate?  // Delegate to pass data back

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debugging: Check if taxLabel and fullPriceLabel are nil
        print("🔍 Debug: taxLabel is \(taxLabel == nil ? "NIL ❌" : "CONNECTED ✅")")
        print("🔍 Debug: fullPriceLabel is \(fullPriceLabel == nil ? "NIL ❌" : "CONNECTED ✅")")

        // Ensure tax and full price labels are set to default values
        taxLabel?.text = "Tax: $0.00"
        fullPriceLabel?.text = "Full Price: $0.00"
        
        // Add target to update price details dynamically as user types
        priceInput.addTarget(self, action: #selector(updatePriceDetails), for: .editingChanged)
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

        // Update the labels separately
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
        showTypeButtons()
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

        // Pass the data back using delegate with updated total price
        delegate?.didAddItem(name: name, price: totalPrice)
        
        // Navigate back to Shopping List screen
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
