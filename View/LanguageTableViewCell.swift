//
//  LanguageTableViewCell.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 11/12/20.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

	@IBOutlet weak var languageName1: UILabel!
	@IBOutlet weak var languageEmoji1: UILabel!
	
	@IBOutlet weak var languageName2: UILabel!
	@IBOutlet weak var languageEmoji2: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
