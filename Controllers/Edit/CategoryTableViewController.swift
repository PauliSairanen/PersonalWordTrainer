//
//  CategoryTableViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 29/1/21.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
		
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	var selectedLanguagesItem: LanguageItem? {
		didSet {
//			loadItems(language1: (selectedLanguagesItem?.name1!)!, language2: (selectedLanguagesItem?.name2!)!)
			print(selectedLanguagesItem!.name1!)
			print(selectedLanguagesItem!.name2!)
			loadItems()
		}
	}
	var categoryArray = [Category]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
	}
	
	
	
	// MARK: ----- Table view data source -----
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoryArray.count
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
		cell.categoryLabel.text = categoryArray[indexPath.item].categoryName
		return cell
	}
	
	
	
	
	//MARK: ------ Buttons -----
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var categoryNameField = UITextField()
		
		
		let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
			let newCategory = Category(context: self.context)
			newCategory.categoryName = categoryNameField.text
		
			self.categoryArray.append(newCategory)
			self.saveItems()
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
			alert.dismiss(animated: true, completion: nil)
		}))
		alert.addTextField { (categoryName) in
			categoryNameField.placeholder = "Name of the category"
			categoryNameField = categoryName
		}
		present(alert, animated: true, completion: nil)
	}
	
	
	
	//MARK: ----- Navigation -----
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Sending this category to next screen: \(categoryArray[indexPath.item].categoryName)")
		performSegue(withIdentifier: "goToWordTableView", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! WordTableViewController
		// Pasing on value to the next ViewController
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedLanguagesItem = selectedLanguagesItem
			destinationVC.selectedCategory = categoryArray[indexPath.item]
			
		}
	}
	
	
	
	//MARK: ------ Data manipulation methods (Save, Read) -----
	func saveItems() {
		do {
			try context.save()
		} catch  {
			print("Error saving context \(error)")
		}
		self.tableView.reloadData()
	}
	
	
	// Does not work for some reason!!!
	

	
	func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
		let categoryPredicate = NSPredicate(format: "parentLanguageItem.name1 == %@ AND parentLanguageItem.name2 == %@", selectedLanguagesItem!.name1!, selectedLanguagesItem!.name2!)
		request.predicate = categoryPredicate
		do {
			categoryArray = try context.fetch(request)
			print(categoryArray)
		} catch  {
			print("Error fetching data from context \(error)")
		}
		self.tableView.reloadData()
	}
	

	
}


