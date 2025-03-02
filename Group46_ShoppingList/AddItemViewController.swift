//
//  AddItemViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-15.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet var typeButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddCategory))
    }
    
    
    @objc func goToAddCategory(_ sender: Any) {
        performSegue(withIdentifier: "goToAddCategory", sender: self)
    }
    
    func showTypeButtons() {
        typeButtons.forEach { button in button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func dropDownAction(_ sender: Any) {
        showTypeButtons( )
    }
    
    @IBAction func typeButtonAction(_ sender: UIButton) {
        showTypeButtons( )
    }
    
    
    
    @IBAction func add_Item(_ sender: Any) {
        
    }
    
    
    @IBAction func go_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
