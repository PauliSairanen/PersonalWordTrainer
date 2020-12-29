//
//  WordTableViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 14/12/20.
//

import UIKit
import CoreData

class WordTableViewController: UITableViewController {
	var textEditView = TextEditViewController()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	var wordPairArray = [WordPairs]()
	var selectedLanguagesItem: LanguageItem? {
		didSet{
			loadItems()
		}
	}
	var lastSelectedIndexPath: IndexPath?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UINib(nibName: "WordTableViewCell", bundle: nil), forCellReuseIdentifier: "WordTableViewCell")
		textEditView.delegate = self
	}
	
	// MARK: - Table view Methods
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return wordPairArray.count
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath) as! WordTableViewCell
		cell.word1.text = wordPairArray[indexPath.item].word1
		cell.word2.text = wordPairArray[indexPath.item].word2
		return cell
	}
	// Remove Item from table + storage
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			context.delete(wordPairArray[indexPath.item])
			wordPairArray.remove(at: indexPath.item)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveItems()
			// Delete the row from the data source
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}
	
	//MARK: - Buttons
	
	// Add new entries
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		// Perform segue to EditViewController to add text
		if let vc = storyboard?.instantiateViewController(identifier: "TextEditViewController") as? TextEditViewController {
			vc.delegate = self
			vc.selectedLangagesItem = selectedLanguagesItem
			vc.newEntry = true
			self.navigationController?.pushViewController(vc, animated: true)
		}
		//		performSegue(withIdentifier: "goToEditScreen", sender: self)
		// When new items are created, you also need to set the parent category for the new item
	}
	// Edit existing entries
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		lastSelectedIndexPath = indexPath
		if let vc = storyboard?.instantiateViewController(identifier: "TextEditViewController") as? TextEditViewController {
			vc.delegate = self
			vc.selectedLangagesItem = selectedLanguagesItem
			vc.selectedWordPair = wordPairArray[indexPath.item]
			vc.newEntry = false
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	
//	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//
//		performSegue(withIdentifier: "goToEditScreen", sender: self)
//	}
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		let destinationVC = segue.destination as! TextEditViewController
//		if let indexpath = tableView.indexPathForSelectedRow {
//			destinationVC.selectedLangagesItem = selectedLanguagesItem
//			destinationVC.selectedWordPair = wordPairArray[indexpath.item]
//		}
//	}
	
	//MARK: - Data manipulation methods (Save, Read)
	func saveItems() {
		do {
			try context.save()
		} catch  {
			print("Error saving context \(error)")
		}
		self.tableView.reloadData()
	}
	func loadItems(with request: NSFetchRequest<WordPairs> = WordPairs.fetchRequest(), predicate: NSPredicate? = nil) {
		
		// Predicate for DB query is created, which will sort the results
		let languageItemPredicate = NSPredicate(format: "parentLanguageItem.name1 MATCHES %@ AND parentLanguageItem.name2 MATCHES %@", selectedLanguagesItem!.name1!, selectedLanguagesItem!.name2! )
		
		// Check if predicate from parameter exists and use both predicates
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [languageItemPredicate, additionalPredicate])
			// Else use only the predicate defined earlier
		} else {
			request.predicate = languageItemPredicate
		}
		// Use request to fetch data using Core Data
		do {
			wordPairArray = try context.fetch(request)
		} catch  {
			print("Error fetching data from context \(error)")
		}
		self.tableView.reloadData()
	}
}

//MARK: - Extensions

// ToDo Set parent as delegate to the child to recevie data
extension WordTableViewController: EditDataInModalDelegate {
	func childViewWillDismiss(editedText1: String, editedText2: String, isNewEntry: Bool) {
		print("Data received on WordTableViewScreen: Word 1 = \(editedText1), word2 = \(editedText2)")
		if isNewEntry {
			let newWordPair = WordPairs(context: self.context)
			newWordPair.word1 = editedText1
			newWordPair.word2 = editedText2
			newWordPair.parentLanguageItem = self.selectedLanguagesItem
			wordPairArray.append(newWordPair)
			saveItems()
			self.navigationController?.popViewController(animated: true)
			tableView.reloadData()
		} else {
			var editedWordPair = wordPairArray[lastSelectedIndexPath!.item]
			editedWordPair.word1 = editedText1
			editedWordPair.word2 = editedText2
			saveItems()
			self.navigationController?.popViewController(animated: true)
			tableView.reloadData()
		}
	}
}



