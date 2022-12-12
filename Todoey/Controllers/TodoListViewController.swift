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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        loadItems()
    }
}

// MARK: - TV Datasource Methods

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

// MARK: - TV Delegate Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        deleteItem(at: indexPath.row)
        toggleItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Add New Items

extension TodoListViewController: Alertable {
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presentAddActionAlert(called: "Add Item", placeholder: "What do you need to do?") { itemText in
            self.addTodo(itemText)
        }
    }

    private func addTodo(_ todoTitle: String) {
        let newItem = Item(context: self.context)
        newItem.title = todoTitle
        newItem.done = false
        items.append(newItem)
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

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            // array of items that are in our container
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }

        tableView.reloadData()
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

// MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request)
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
