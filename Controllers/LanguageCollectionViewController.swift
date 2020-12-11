//
//  LanguageCollectionViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 10/12/20.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class LanguageCollectionViewController: UICollectionViewController {

	var languageArray = [LanguageItem]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	
    override func viewDidLoad() {
        super.viewDidLoad()

		print(dataFilePath)
		collectionView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellWithReuseIdentifier: "ReusableLanguageCell")

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		loadItems()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		return languageArray.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		return 1
    }
	
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableLanguageCell", for: indexPath) as! LanguageCell
//		cell.languageNameLabel1.text = languageArray[indexPath.row].name
//		cell.emojiLabel1.text = languageArray[indexPath.row].flag
//        return cell
//    }
	
	
	


	//MARK: - Add and Remove languages
	
	
	@IBAction func addButtonPressed(_ sender: Any) {
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
		self.collectionView.reloadData()
	}
	
	func loadItems(with request: NSFetchRequest<LanguageItem> = LanguageItem.fetchRequest()) {
		do {
			languageArray = try context.fetch(request)
		} catch  {
			print("Error fetching data from context \(error)")
		}
		self.collectionView.reloadData()
	}
	
}
