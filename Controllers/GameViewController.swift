//
//  GameViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 29/12/20.
//

import UIKit
import CoreData

class GameViewController: UIViewController {
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var language1Label: UILabel!
	@IBOutlet weak var questionTextField: UITextView!
	@IBOutlet weak var language2Label: UILabel!
	@IBOutlet weak var answerTextField: UITextView!
	@IBOutlet weak var feedbackImage: UIImageView!
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	var wordPairArray = [WordPairs]()
	var selectedLanguagesItem: LanguageItem?
	var correctAnswers = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadItems()
		language1Label.text = selectedLanguagesItem?.name1
		language2Label.text = selectedLanguagesItem?.name2
		questionTextField.text = wordPairArray[0].word1
		answerTextField.text = ""
	}
	
	//MARK: - Game functions
	
	func compareWords(index: Int) -> Bool {
		let wordFromStorage = wordPairArray[index].word2
		let userTypedWord = answerTextField.text
		if (wordFromStorage == userTypedWord) {
			return true
		} else {
			return false
		}
	}
	
	
	
	
	
	
	
	
	
	
	//MARK: - Buttons
	
	@IBAction func checkAnswer(_ sender: UIButton) {
		let answeredCorretly = compareWords(index: 0)
		if answeredCorretly == true {
			print("Answer is corret!")
			feedbackImage.image = UIImage(systemName: "hand.thumbsup.fill")
			feedbackImage.tintColor = #colorLiteral(red: 0.1203318441, green: 0.503712378, blue: 0.09756665541, alpha: 1)
			
		} else {
			feedbackImage.image = UIImage(systemName: "hand.thumbsdown.fill")
			feedbackImage.tintColor = .red
			print("Answer INCORRECT!")
			
			
		}
	}
	
	
	
	
	
	
	//MARK: - Data manipulation methods (Save, Read)
	func saveItems() {
		do {
			try context.save()
		} catch  {
			print("Error saving context \(error)")
		}
		
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
	}
	
}
