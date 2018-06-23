//
//  ViewController.swift
//  TodoList
//
//  Created by Satyabrat on 30/05/18.
//  Copyright © 2018 Subhrajyoti. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    
    var itemArray = [Items]()
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
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
    //Below commented code are same as 1 line using ternary operator
        
       // cell.accessoryType = (item.done == true) ? .checkmark : .none
        
        if item.done == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        //This above will delete the todo list selected row
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //itemArray[indexPath.row].setValue("Updated", forKey: "title")
        //This above will update the selected row value with "Updated"
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add TodoList Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldValue = UITextField()
        
        let alert = UIAlertController(title: "Add New TodoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            
            let newItem = Items(context: self.context)
            newItem.title = textFieldValue.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
           // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textFieldValue = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    func saveItems(){
        
        do{
            try context.save()
        } catch {
            print("Error saving context , \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadItems(With request : NSFetchRequest<Items> = Items.fetchRequest(), predicate : NSPredicate? = nil){
        
        //let request : NSFetchRequest<Items> = Items.fetchRequest()
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let additionalPredicate = predicate {
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
//MARK: - Search bar methods

extension TodoListTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(With: request, predicate: predicate)
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
