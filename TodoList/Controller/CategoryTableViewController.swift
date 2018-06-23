//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by Satyabrat on 22/06/18.
//  Copyright © 2018 Subhrajyoti. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Add Category Method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldValue = UITextField()
        
        let alert = UIAlertController(title: "Add New TodoList Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textFieldValue.text!
            
            self.categoryArray.append(newCategory)
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textFieldValue = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    func saveCategories(){
        
        do{
            try context.save()
        } catch {
            print("Error saving context , \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadCategories(With request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        //let request : NSFetchRequest<Items> = Items.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Data MAnipulation Methods
}
