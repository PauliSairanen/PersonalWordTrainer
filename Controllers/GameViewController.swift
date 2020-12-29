//
//  GameViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 29/12/20.
//

import UIKit

class GameViewController: UIViewController {

	var selectedLanguagesItem: LanguageItem? {
		didSet {
			loadView()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    

}
