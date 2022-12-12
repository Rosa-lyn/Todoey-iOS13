//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rosalyn Land on 12/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Create a new category"
        }

        let addCategoryAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            guard let textFields = alertController?.textFields else { return }
            if let categoryText = textFields.first?.text {

                let newCategory = Category(context: self.context)
                newCategory.name = categoryText
                self.addCategory(newCategory)
            }
        }

        alertController.addAction(addCategoryAction)

        present(alertController, animated: true)
    }

    private func addCategory(_ category: Category) {
        categories.append(category)
        print(categories)
    }

    // MARK: - TV Datasource Methods


    // MARK: - Data Manipulation Methods
        // save and load data

    // MARK: - TV Delegate Methods

}
