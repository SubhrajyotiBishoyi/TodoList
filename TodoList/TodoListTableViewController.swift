//
//  ViewController.swift
//  TodoList
//
//  Created by Satyabrat on 30/05/18.
//  Copyright © 2018 Subhrajyoti. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var itemArray = ["First Item","Second Item","Third Item"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemArray = defaults.array(forKey: "TodoListArray") as! [String]
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK Add TodoList Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldValue = UITextField()
        
        let alert = UIAlertController(title: "Add New TodoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.itemArray.append(textFieldValue.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textFieldValue = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
}

