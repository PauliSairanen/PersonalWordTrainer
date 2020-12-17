//
//  TextEditViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 15/12/20.
//

import UIKit

protocol EditDataInModalDelegate {
	func childViewWillDismiss(editedText1: String, editedText2: String)
}

class TextEditViewController: UIViewController {

	@IBOutlet weak var languageLabel1: UILabel!
	@IBOutlet weak var textEditField1: UITextField!
	@IBOutlet weak var languageLabel2: UILabel!
	@IBOutlet weak var textEditField2: UITextField!
	
	var delegate:EditDataInModalDelegate?
		
	var selectedWordPair: WordPairs? {
		didSet{
			print("Received Word Pair from WordTableViewController")
		}
	}
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let dataFirePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func AcceptTextEditPressed(_ sender: UIButton) {
		guard let Text1 = textEditField1.text, let Text2 = textEditField2.text else {
			print("Nil found in textfields")
			return
		}
			print(Text1, Text2)
			delegate?.childViewWillDismiss( editedText1: Text1,  editedText2: Text2)
	}
	
	@IBAction func DeclineTextEditPressed(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	//MARK: - Data manipulation methods (Save, Read)
}
