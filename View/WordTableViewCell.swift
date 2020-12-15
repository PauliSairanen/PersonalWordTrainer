//
//  WordTableViewCell.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 14/12/20.
//

import UIKit

class WordTableViewCell: UITableViewCell {

	@IBOutlet weak var word1: UILabel!
	@IBOutlet weak var word2: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
