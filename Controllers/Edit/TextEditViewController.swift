//
//  TextEditViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 15/12/20.
//

import UIKit

protocol EditDataInModalDelegate {
	func childViewWillDismiss(editedText1: String, editedText2: String, isNewEntry: Bool)
}

class TextEditViewController: UIViewController {
	@IBOutlet weak var languageLabel1: UILabel!
	@IBOutlet weak var languageLabel2: UILabel!
	@IBOutlet weak var textEditField1: UITextView!
	@IBOutlet weak var textEditField2: UITextView!
	
	
	var delegate:EditDataInModalDelegate?
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFirePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	
	var selectedWordPair: WordPairs?
	var selectedLangagesItem: LanguageItem?
	var newEntry: Bool?
	
    override func viewDidLoad() {
        super.viewDidLoad()		
		languageLabel1.text = selectedLangagesItem?.name1
		languageLabel2.text = selectedLangagesItem?.name2
		textEditField1.text = selectedWordPair?.word1
		textEditField2.text = selectedWordPair?.word2
    }
	
	
	@IBAction func acceptButtonPressed(_ sender: UIButton) {
		guard let Text1 = textEditField1.text, let Text2 = textEditField2.text else {
			print("Nil found in textfields")
			return
		}
		print(Text1, Text2)
		delegate?.childViewWillDismiss( editedText1: Text1,  editedText2: Text2, isNewEntry: newEntry!)
	}
	
	@IBAction func declineButtonPressed(_ sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}
	
	
	//MARK: - Data manipulation methods (Save, Read)
}

extension TextEditViewController {
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}
