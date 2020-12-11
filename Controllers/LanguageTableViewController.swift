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
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "LanguageTableViewCell")
		loadItems()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return languageArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as! LanguageTableViewCell
		cell.languageName1.text = languageArray[indexPath.row].name
		cell.languageEmoji1.text = languageArray[indexPath.row].flag
        // Configure the cell...

        return cell
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


  
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var nameField = UITextField()
		var emojiField = UITextField()
		let alert = UIAlertController(title: "Add new Language", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Language", style: .default) { (action) in
			if let textToAdd = nameField.text {
				let newLanguage = LanguageItem(context: self.context)
				newLanguage.name = nameField.text
				newLanguage.flag = emojiField.text
				self.languageArray.append(newLanguage)
				self.saveItems()
			}
		}
		alert.addTextField { (languageNameField) in
			languageNameField.placeholder = "Name of the language"
			nameField = languageNameField
		}
		alert.addTextField { (flagEmojiField) in
			flagEmojiField.placeholder = "Add a flag emoji here"
			emojiField = flagEmojiField
		}
		alert.addAction(action)
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


