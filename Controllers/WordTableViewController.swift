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
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFirePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UINib(nibName: "WordTableViewCell", bundle: nil), forCellReuseIdentifier: "WordTableViewCell")
		loadItems()
		
    }

    // MARK: - Table view data source

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
	
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
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
