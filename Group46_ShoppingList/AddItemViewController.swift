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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCustomCategory" {
            print("Navigating to custom category")
        }
        
        
    }
    
    
    @IBAction func add_Item(_ sender: Any) {
        
    }
    
    
    @IBAction func go_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
