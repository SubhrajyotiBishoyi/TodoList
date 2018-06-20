//
//  ViewController.swift
//  TodoList
//
//  Created by Satyabrat on 30/05/18.
//  Copyright © 2018 Subhrajyoti. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
    
        loadItems()
        
//        if let item = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = item
//
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK Tableview Datasource Methodss
    
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
    
    //MARK Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK Add TodoList Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldValue = UITextField()
        
        let alert = UIAlertController(title: "Add New TodoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textFieldValue.text!
            
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Error in encoding Items , \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
        let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Item].self, from: data)
        } catch{
            print("Error in decoding Items , \(error)")
            }
        }
        
    }
    
}
