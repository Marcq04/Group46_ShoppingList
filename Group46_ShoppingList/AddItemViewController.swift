//
//  AddItemViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-15.
//

import UIKit

class AddItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func go_to_AddCategory(_ sender: Any) {
        performSegue(withIdentifier: "goToAddCategory", sender: self)
    }
    
    
    @IBAction func add_Item(_ sender: Any) {
        
    }
    
    
    @IBAction func go_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
