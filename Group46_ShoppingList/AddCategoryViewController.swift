import UIKit

protocol AddCategoryDelegate: AnyObject {
    func didAddCategory(_ category: String)
}

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var categoryStackView: UIStackView! // Reference to StackView inside UIScrollView
    
    weak var delegate: AddCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func go_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func add_Category(_ sender: Any) {
        guard let categoryName = categoryInput.text, !categoryName.isEmpty else {
            showAlert(message: "Please enter a category name.")
            return
        }

        print("Added category: \(categoryName)")
        
        // Add new category to the ScrollView's StackView
        addCategoryToScrollView(categoryName)
        
        delegate?.didAddCategory(categoryName)
    }

    private func addCategoryToScrollView(_ categoryName: String) {
        let categoryLabel = UILabel()
        categoryLabel.text = categoryName
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        categoryLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        categoryLabel.layer.cornerRadius = 5
        categoryLabel.clipsToBounds = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        categoryStackView.addArrangedSubview(categoryLabel) // Add label to StackView
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
