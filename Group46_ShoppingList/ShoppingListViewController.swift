//
//  ShoppingListViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-15.
//

import UIKit

class ShoppingListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func toAddItem(_ sender: Any) {
        performSegue(withIdentifier: "additem", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

