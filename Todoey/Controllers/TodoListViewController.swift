//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()


        print(dataFilePath)

        let newItem = Item()
        newItem.title = "Find Mike"
        items.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        items.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        items.append(newItem3)

//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            self.items = items
//        }
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

        items[indexPath.row].done.toggle()

        saveItems()

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
                let newItem = Item()
                newItem.title = todoText
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }

        tableView.reloadData()
    }
}

