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
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet var typeButtons: [UIButton]!
    
    weak var delegate: AddItemDelegate?  // Delegate to pass data back

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCategory))
    }
    
    @objc func goToAddCategory(_ sender: Any) {
        performSegue(withIdentifier: "goToAddCategory", sender: self)
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
              let priceText = priceInput.text, let price = Double(priceText) else {
            showAlert(message: "Please enter valid item details.")
            return
        }
        
        print("✅ Adding item: \(name) - $\(price)") // Debugging
        
        // Pass the data back using delegate
        delegate?.didAddItem(name: name, price: price)
        
        // Navigate back to Shopping List screen
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
