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
        loadCategories()

    }
}

// MARK: - Add New Categories

extension CategoryViewController: Alertable {

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        presentAddActionAlert(called: "Add category", placeholder: "Create a new category") { categoryText in
            self.addCategory(called: categoryText)
        }
    }

    private func addCategory(called categoryName: String) {
        let newCategory = Category(context: self.context)
        newCategory.name = categoryName
        categories.append(newCategory)
        saveCategories()
    }
}

// MARK: - Data Manipulation Methods

extension CategoryViewController {

    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }

        tableView.reloadData()
    }

    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching categories from context: \(error)")
        }

        tableView.reloadData()
    }
}

// MARK: - TV Datasource Methods

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]

        cell.textLabel?.text = category.name
        return cell
    }
}

// MARK: - TV Delegate Methods

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}
