//
//  SelectGameTableViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 29/12/20.
//

import UIKit
import CoreData

class SelectGameTableViewController: UITableViewController {
	
	var languageArray = [LanguageItem]()
	var wordPairArray = [WordPairs]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
		return 70
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as! LanguageTableViewCell
		cell.languageName1.text = languageArray[indexPath.item].name1
		cell.languageName2.text = languageArray[indexPath.item].name2
		cell.languageEmoji1.text = languageArray[indexPath.item].flag1
		cell.languageEmoji2.text = languageArray[indexPath.item].flag2
		return cell
	}
	
	
	
	
	
	
	//MARK: - Navigation and Segues
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// If there are no words added, don´t enter practice mode
		loadWordPairs(language1: languageArray[indexPath.item].name1!, language2: languageArray[indexPath.item].name2!)
		
		if wordPairArray.isEmpty {
			let alert = UIAlertController(title: "No words to practice", message: "Go add some words! ", preferredStyle: .alert)
			alert.addAction((UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
				self.dismiss(animated: true, completion: nil)
			})))
			self.present(alert, animated: true, completion: nil)
		} else {
			if let vc = storyboard?.instantiateViewController(identifier: "GameViewController") as? GameViewController {
				vc.selectedLanguagesItem = languageArray[indexPath.item]
				self.navigationController?.pushViewController(vc, animated: true)
			}
		}
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
	
	func loadWordPairs(with request: NSFetchRequest<WordPairs> = WordPairs.fetchRequest(), predicate: NSPredicate? = nil, language1: String, language2: String) {
		// Predicate for DB query is created, which will sort the results
		let languageItemPredicate = NSPredicate(format: "parentLanguageItem.name1 MATCHES %@ AND parentLanguageItem.name2 MATCHES %@", language1, language2 )
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
