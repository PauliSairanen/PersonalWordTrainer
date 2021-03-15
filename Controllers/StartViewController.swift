//
//  ViewController.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 9/12/20.
//

import UIKit

class StartViewController: UIViewController {

	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

	
	override func viewDidLoad() {
		super.viewDidLoad()
		print(dataFilePath)
	}
}

