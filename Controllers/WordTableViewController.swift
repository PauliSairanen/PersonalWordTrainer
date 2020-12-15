//
//  WordTableViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 14/12/20.
//

import UIKit
import CoreData

class WordTableViewController: UITableViewController {
	var wordPairArray = [WordPairs]()
	var selectedLanguages: LanguageItem? {
		didSet{
			loadItems()
		}
	}
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFirePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UINib(nibName: "WordTableViewCell", bundle: nil), forCellReuseIdentifier: "WordTableViewCell")
	
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
		return 100
	}
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath) as! WordTableViewCell
		cell.word1.text = wordPairArray[indexPath.item].word1
		cell.word2.text = wordPairArray[indexPath.item].word2
        return cell
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			context.delete(wordPairArray[indexPath.item])
			wordPairArray.remove(at: indexPath.item)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveItems()
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
	
	//MARK: - Buttons
	
	// Add new entries
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		// Perform segue to EditViewController to add text
		
		
		performSegue(withIdentifier: "goToEditScreen", sender: self)
		// When new items are created, you also need to set the parent category for the new item
	}
	// Edit existing entries
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToEditScreen", sender: self)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TextEditViewController
		if let indexpath = tableView.indexPathForSelectedRow {
			destinationVC.selectedWordPair = wordPairArray[indexpath.item]
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
	func loadItems(with request: NSFetchRequest<WordPairs> = WordPairs.fetchRequest()) {
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
	func childViewWillDismiss(editedText1: String, editedText2: String) {
		let newLanguage = LanguageItem(context: self.context)
		
		var newWordPair = WordPairs(context: self.context)
		newWordPair.word1 = editedText1
		newWordPair.word2 = editedText2
		newWordPair.parentLanguages = self.selectedLanguages
		wordPairArray.append(newWordPair)
		saveItems()
		tableView.reloadData()
	}
}



