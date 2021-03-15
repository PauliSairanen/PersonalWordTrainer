//
//  LanguageTableViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 11/12/20.
//

import UIKit
import CoreData

class LanguageTableViewController: UITableViewController {
	
	var languageArray = [LanguageItem]()	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print(dataFilePath)
		tableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "LanguageTableViewCell")
		loadItems()
	}
	
	
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return languageArray.count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as! LanguageTableViewCell
		cell.languageName1.text = languageArray[indexPath.item].name1
		cell.languageEmoji1.text = languageArray[indexPath.item].flag1
		cell.languageName2.text = languageArray[indexPath.item].name2
		cell.languageEmoji2.text = languageArray[indexPath.item].flag2
		cell.contentView.layer.masksToBounds = true
		return cell
	}
	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			context.delete(languageArray[indexPath.item])
			languageArray.remove(at: indexPath.item)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveItems()
			
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}
	
	
	
	
	
	
	// MARK: - Navigation and Segues
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToCategoryView", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! CategoryTableViewController
		// Pasing on value to the next ViewController
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedLanguagesItem = languageArray[indexPath.item]
		}
	}
	
	
	
	
	
	
	//MARK: - Buttons
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var nameField1 = UITextField()
		var emojiField1 = UITextField()
		var nameField2 = UITextField()
		var emojiField2 = UITextField()
		
		let alert = UIAlertController(title: "Add new Language Pair", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
			let newLanguage = LanguageItem(context: self.context)
			newLanguage.name1 = nameField1.text
			newLanguage.flag1 = emojiField1.text
			
			newLanguage.name2 = nameField2.text
			newLanguage.flag2 = emojiField2.text
			self.languageArray.append(newLanguage)
			self.saveItems()
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
			alert.dismiss(animated: true, completion: nil)
		}))
		alert.addTextField { (languageNameField1) in
			languageNameField1.placeholder = "Name of the language"
			nameField1 = languageNameField1
		}
		alert.addTextField { (flagEmojiField1) in
			flagEmojiField1.placeholder = "Add a flag emoji here"
			emojiField1 = flagEmojiField1
		}
		alert.addTextField { (languageNameField2) in
			languageNameField2.placeholder = "Name of the language"
			nameField2 = languageNameField2
		}
		alert.addTextField { (flagEmojiField2) in
			flagEmojiField2.placeholder = "Add a flag emoji here"
			emojiField2 = flagEmojiField2
		}
		present(alert, animated: true, completion: nil)
	}
	
	
	
	
	
	
	//MARK: - Data manipulation methods (Save, Read)
	func saveItems() {
		do {
			try context.save()
		} catch  {
			print("Error saving context \(error)")
		}
		self.tableView.reloadData()
	}
	
	func loadItems(with request: NSFetchRequest<LanguageItem> = LanguageItem.fetchRequest()) {
		do {
			languageArray = try context.fetch(request)
		} catch  {
			print("Error fetching data from context \(error)")
		}
		self.tableView.reloadData()
	}
	
}

//MARK: - Extensions



