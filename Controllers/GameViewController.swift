//
//  GameViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 29/12/20.
//

import UIKit
import CoreData

class GameViewController: UIViewController {
	
	@IBOutlet weak var scoreLabel: UILabel!
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
	var totalQuestions: Int?
	var correctAnswers = 0
	var currentProgress = 0
	var isSwapped = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// call the 'keyboardWillShow' function when the view controller receive notification that keyboard is going to be shown
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:))), name: UIResponder.keyboardWillHideNotification, object: nil)
		

	
	
		
		loadItems()
		resetGame()
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
			// if keyboard size is not available for some reason, dont do anything
			return
		}
		// move the root view up by the distance of keyboard height
		self.view.frame.origin.y = 0 - keyboardSize.height
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		// move back the root view origin to zero
		self.view.frame.origin.y = 0
	}
	
	
	
	
	
	//MARK: - Game functions
	func resetGame() {
		correctAnswers = 0
		currentProgress = 0
		language1Label.text = selectedLanguagesItem?.name1
		language2Label.text = selectedLanguagesItem?.name2
		questionTextField.text = wordPairArray[0].word1
		answerTextField.text = ""
		totalQuestions = wordPairArray.count
		progressBar.setProgress(Float(0.0), animated: true)
		feedbackImage.isHidden = true
		scoreLabel.text = "0 / \(wordPairArray.count)"
	}
	
	func updateProgressBar() {
		if correctAnswers == 0 {
			progressBar.setProgress(Float(0.0), animated: true)
		}
		else {
			if let amountOfQuestion = totalQuestions {
				scoreLabel.text = "\(correctAnswers) / \(amountOfQuestion)"
				print("Correct Answers inside updateProgressbar: \(correctAnswers)")
				print("Total questions inside progress bar: \(amountOfQuestion)")
				let currentProgress = (Float(correctAnswers) / Float(amountOfQuestion))
				print(currentProgress)
				progressBar.setProgress(Float(currentProgress), animated: true)
			}}}
	
	func updateUI(){
		updateProgressBar()
		// IF all questions are done, show that game is over
		if (currentProgress == totalQuestions) {
			if let amountOfQuestions = totalQuestions {
				let alert = UIAlertController(title: "Total score: \(correctAnswers) / \(amountOfQuestions)", message: "Practice again?", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(UIAlertAction) in
					self.navigationController?.popViewController(animated: true)
				}))
				alert.addAction((UIAlertAction(title: "Yes!", style: .default, handler: { (UIAlertAction) in
					self.resetGame()
				})))
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					self.present(alert, animated: true, completion: nil)
				}}}
		else {
			// Animate the next words after a brief delay
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self.questionTextField.text = self.wordPairArray[self.currentProgress].word1
				self.answerTextField.text = ""
				self.feedbackImage.isHidden = true
			}}}
	
	func compareWords(index: Int) -> Bool {
		let wordFromStorage = wordPairArray[index].word2
		let userTypedWord = answerTextField.text
		if (wordFromStorage == userTypedWord) {
			currentProgress += 1
			correctAnswers += 1
			return true
		}
		else {
			currentProgress += 1
			return false
		}}
	
	
	
	
	
	
	//MARK: - Buttons
	
	@IBAction func checkAnswer(_ sender: UIButton) {
		let answeredCorrectly = compareWords(index: currentProgress)
		if answeredCorrectly == true {
			updateUI()
			print("Answer is correct!")
			feedbackImage.isHidden = false
			feedbackImage.image = UIImage(systemName: "hand.thumbsup.fill")
			feedbackImage.tintColor = #colorLiteral(red: 0.1203318441, green: 0.503712378, blue: 0.09756665541, alpha: 1)
			
		} else {
			updateUI()
			feedbackImage.isHidden = false
			feedbackImage.image = UIImage(systemName: "hand.thumbsdown.fill")
			feedbackImage.tintColor = .red
			print("Answer INCORRECT!")
		}}
	
	@IBAction func swapLanguages(_ sender: UIButton) {
		let alert = UIAlertController(title: "Swapping languages will reset practice", message: "Swap languages?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(UIAlertAction) in
			for index in 0...self.totalQuestions!-1 {
				swap(&self.wordPairArray[index].word1, &self.wordPairArray[index].word2)
			}
			self.resetGame()
		}))
		alert.addAction((UIAlertAction(title: "No", style: .default, handler: nil)))
		self.present(alert, animated: true, completion: nil)
	}
	
	
	
	
	
	
	//MARK: - Data manipulation methods (Save, Read)
	func saveItems() {
		do {
			try context.save()
		} catch  {
			print("Error saving context \(error)")
		}}
	
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
		}}
	
}
