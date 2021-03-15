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
	
	
	
	// MARK: - Navigation and Segues
	

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(identifier: "SelectCategoryTableViewController") as? SelectCategoryTableViewController {
			vc.selectedLanguagesItem = languageArray[indexPath.item]
			self.navigationController?.pushViewController(vc, animated: true)
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
	
}
