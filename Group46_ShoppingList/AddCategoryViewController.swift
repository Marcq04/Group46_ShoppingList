//
//  AddCategoryViewController.swift
//  Group46_ShoppingList
//
//  Created by Marcus Quitiquit on 2025-02-16.
//  David Commit
//

import UIKit

class AddCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryTableView: UITableView!
    
    var categories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    @IBAction func saveCategory(_ sender: UIButton) {
        guard let category = categoryTextField.text, !category.isEmpty else { return }
        
        categories.append(category)
        categoryTextField.text = ""
        categoryTableView.reloadData()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        
        // Added X button to delete
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("X", for: .normal)
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: #selector(deleteCategory(_:)), for: .touchUpInside)
        cell.accessoryView = deleteButton
        
        return cell
    }
    
    @objc func deleteCategory(_ sender: UIButton) {
        categories.remove(at: sender.tag)
        categoryTableView.reloadData()
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
