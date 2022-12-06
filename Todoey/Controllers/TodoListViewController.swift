//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var items = [Item]()
    let defaults = UserDefaults.standard

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)

        loadItems()
    }
}

// MARK: - TableView Datasource Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

// MARK: - TableView Delegate Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        deleteItem(at: indexPath.row)
        toggleItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Add New Items

extension TodoListViewController {
    @IBAction func addButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "What do you need to do?"
        }
        
        let addTodoAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            guard let textFields = alertController?.textFields else { return }
            if let todoText = textFields.first?.text {

                let newItem = Item(context: self.context)
                newItem.title = todoText
                newItem.done = false
                self.addTodo(newItem)
            }
        }

        alertController.addAction(addTodoAction)

        present(alertController, animated: true)
    }

    private func addTodo(_ item: Item) {
        items.append(item)

        saveItems()

    }
}

// MARK: - Model Manipulation Methods

extension TodoListViewController {
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }

        tableView.reloadData()
    }

    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // array of items that are in our container
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }

    func toggleItem(at index: Int) {
        items[index].done.toggle()
        saveItems()
    }

    func deleteItem(at index: Int) {
        // must call context.delete first to access the item array
        context.delete(items[index])
        items.remove(at: index)
        saveItems()
    }
}

