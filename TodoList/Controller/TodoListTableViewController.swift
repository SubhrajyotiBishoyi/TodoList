//
//  ViewController.swift
//  TodoList
//
//  Created by Satyabrat on 30/05/18.
//  Copyright © 2018 Subhrajyoti. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController {
    
    var todoItems : Results<Items>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    //let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    
       // loadItems()
        
//        if let item = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = item
//
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - Tableview Datasource Methodss
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        
    //Below commented code are same as 1 line using ternary operator
        
       // cell.accessoryType = (item.done == true) ? .checkmark : .none
        
        if item.done == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        }
        else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Update data using Realm database
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item) //delete items from DB
                }
            } catch {
                print("Error in updating done status \(error)")
            }
        }
        tableView.reloadData()
        //print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        //This above will delete the todo list selected row
        
        //itemArray[indexPath.row].setValue("Updated", forKey: "title")
        //This above will update the selected row value with "Updated"
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add TodoList Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldValue = UITextField()
        
        let alert = UIAlertController(title: "Add New TodoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                try self.realm.write {
                    let newItem = Items()
                    newItem.title = textFieldValue.text!
                    newItem.createdDate = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textFieldValue = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
        tableView.reloadData()
    }

}
//MARK: - Search bar methods

extension TodoListTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
        

//        let request : NSFetchRequest<Items> = Items.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItems(With: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
