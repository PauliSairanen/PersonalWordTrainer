//
//  GameViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 29/12/20.
//

import UIKit
import CoreData

class GameViewController: UIViewController, UITextViewDelegate {
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var language1Label: UILabel!
	@IBOutlet weak var questionTextField: UITextView!
	@IBOutlet weak var language2Label: UILabel!
	@IBOutlet weak var answerTextField: UITextView!
	@IBOutlet weak var feedbackImage: UIImageView!
	@IBOutlet weak var flag1Label: UILabel!
	@IBOutlet weak var flag2Label: UILabel!
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	var wordPairArray = [WordPairs]()
	var wordPairArrayInOrder = [WordPairs]()
	var selectedLanguagesItem: LanguageItem?
	var totalQuestions: Int?
	var correctAnswers = 0
	var currentProgress = 0
	var isSwapped = false
	var isShuffled = false
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadItems()
		wordPairArrayInOrder = wordPairArray // Store the original order
		resetGame()
		self.answerTextField.delegate = self
		questionTextField.isEditable = false
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		checkAnswer()
	}
	
	// Before exiting the game, reset state to default
	override func viewWillDisappear(_ animated: Bool) {
		if self.isMovingFromParent {
			if isSwapped == true {
				swapLanguages()
			}
			if isShuffled == true {
				wordPairArray = wordPairArrayInOrder
			}
		}
	}
	
	
	
	//MARK: - Game functions
	func resetGame() {
		correctAnswers = 0
		currentProgress = 0
		if isSwapped {
			language1Label.text = selectedLanguagesItem?.name2
			language2Label.text = selectedLanguagesItem?.name1
			flag1Label.text = selectedLanguagesItem?.flag2
			flag2Label.text = selectedLanguagesItem?.flag1
		} else {
			language1Label.text = selectedLanguagesItem?.name1
			language2Label.text = selectedLanguagesItem?.name2
			flag1Label.text = selectedLanguagesItem?.flag1
			flag2Label.text = selectedLanguagesItem?.flag2
			
		}
		if isShuffled {
			wordPairArray = wordPairArray.shuffled()
		} else {
			wordPairArray = wordPairArrayInOrder
		}
		
		guard let textToAnimate = wordPairArray[0].word1 else {return}
		questionTextField.setTextAnimated(text: textToAnimate)
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
			}
		}
	}
	
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
		}
	}
	
	func checkAnswer() {
		let answeredCorrectly = compareWords(index: currentProgress)
		if answeredCorrectly == true {
			updateProgressBar()
			print("Answer is correct!")
			feedbackImage.isHidden = false
			feedbackImage.image = UIImage(systemName: "hand.thumbsup.fill")
			feedbackImage.tintColor = #colorLiteral(red: 0.1203318441, green: 0.503712378, blue: 0.09756665541, alpha: 1)
			ifGameHasEnded()
		} else {
			// Show correct answer in alert
			guard let answer = wordPairArray[currentProgress-1].word2 else {return}
			let alert = UIAlertController(title: "Incorrect answer", message: "Correct answer: \(answer) ", preferredStyle: .alert)
			alert.addAction((UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
				self.dismiss(animated: true, completion: nil)
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					self.ifGameHasEnded()
				}
			})))
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.present(alert, animated: true, completion: nil)
			}
			updateProgressBar()
			feedbackImage.isHidden = false
			feedbackImage.image = UIImage(systemName: "hand.thumbsdown.fill")
			feedbackImage.tintColor = .red
			print("Answer INCORRECT!")
		}
	}
	
	func ifGameHasEnded() {
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
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				guard let textToAnimate = self.wordPairArray[self.currentProgress].word1 else {return}
				self.questionTextField.setTextAnimated(text: textToAnimate)
				self.answerTextField.text = ""
				self.feedbackImage.isHidden = true
			}}
	}
	
	func swapLanguages() {
		for index in 0...self.totalQuestions!-1 {
			swap(&self.wordPairArray[index].word1, &self.wordPairArray[index].word2)
		}
	}
	

	
	//MARK: - Buttons
	
	@IBAction func checkAnswer(_ sender: UIButton) {
		checkAnswer()
	}
	
	@IBAction func swapLanguages(_ sender: UIButton) {
		let alert = UIAlertController(title: "Swapping languages will reset practice", message: "Swap languages?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(UIAlertAction) in
			self.swapLanguages()
			self.isSwapped = !self.isSwapped
			self.resetGame()
		}))
		alert.addAction((UIAlertAction(title: "No", style: .default, handler: nil)))
		self.present(alert, animated: true, completion: nil)
	}
	
	
	@IBAction func switchPressed(_ sender: UISwitch) {
		if sender.isOn {
			let alert = UIAlertController(title: "Shuffling languages will reset practice", message: "Shuffle languages?", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(UIAlertAction) in
				self.isShuffled = !self.isShuffled
				self.resetGame()
			}))
			alert.addAction((UIAlertAction(title: "No", style: .default, handler: nil)))
			self.present(alert, animated: true, completion: nil)
		}
		else {
			self.isShuffled = !self.isShuffled
			resetGame()
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




//MARK: - Extensions

// Touch anywhere to hide keyboard
extension GameViewController {
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

// Animation function for text
extension UITextView {
	func setTextAnimated(text: String, characterDelay: TimeInterval = 5.0) {
		self.text = ""
		
		let writingTask = DispatchWorkItem{ [weak self] in
			text.forEach { (character) in
				DispatchQueue.main.async {
					self?.text?.append(character)
				}
				Thread.sleep(forTimeInterval: characterDelay/100)
			}
		}
		let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
		queue.asyncAfter(deadline: .now() + 0.05, execute: writingTask)
	}
}
