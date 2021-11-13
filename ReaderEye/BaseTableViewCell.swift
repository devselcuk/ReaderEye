//
//  BaseTableViewCell.swift
//  ReaderEye
//
//  Created by MacMini on 7.10.2021.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var wordlabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
