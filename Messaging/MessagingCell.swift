//
//  MessagingCell.swift
//  Messaging
//
//  Created by Grant Maloney on 10/15/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class MessagingCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactDescription: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
