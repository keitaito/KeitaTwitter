//
//  SendingMessageCell.swift
//  KeitaTwitter
//
//  Created by Keita on 8/7/15.
//  Copyright (c) 2015 Keita Ito. All rights reserved.
//

import UIKit

class SendingMessageCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
