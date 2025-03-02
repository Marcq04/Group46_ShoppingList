//
//  AddItemViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-15.
//

import UIKit

class AddItemViewController: UIViewController {
    
    // Outlets for Text Fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add button to the navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCategory))
    }
    
    @objc func goToAddCategory(_ sender: Any) {
        performSegue(withIdentifier: "goToAddCategory", sender: self)
    }
    
    // "Add" Button Action
    @IBAction func add_Item(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let priceString = priceTextField.text, let price = Double(priceString),
              let type = typeTextField.text, !type.isEmpty,
              let taxString = taxTextField.text, let tax = Double(taxString) else {
            showAlert(message: "Please fill in all fields correctly.")
            return
        }
        
        let fullPrice = price + (price * tax / 100) // Calculating final price
        
        print("Added Item:")
        print("Name: \(name), Price: \(price), Type: \(type), Tax: \(tax), Full Price: \(fullPrice)")
        
        // If you want to pass data back to the previous screen, use delegation or NotificationCenter
        dismiss(animated: true, completion: nil)
    }
    
    // "Go Back" Button Action
    @IBAction func go_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Helper function to show alerts
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

