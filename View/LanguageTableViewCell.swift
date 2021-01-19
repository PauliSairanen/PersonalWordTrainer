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
		
//		backgroundColor = .clear
//		layer.masksToBounds = false
//		layer.shadowOpacity = 0.23
//		layer.shadowRadius = 4
//		layer.shadowOffset = CGSize(width: 0, height: 0)
//		layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//		
//		contentView.backgroundColor = .white
//		contentView.layer.cornerRadius = 8
		
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
