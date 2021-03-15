//
//  CategoryTableViewCell.swift
//  Personal Word Trainer
//
//  Created by Pauli Sairanen on 29/1/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

	@IBOutlet weak var categoryLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
