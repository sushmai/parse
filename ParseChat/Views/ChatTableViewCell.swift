//
//  ChatTableViewCell.swift
//  ParseChat
//
//  Created by Sanaz Khosravi on 9/23/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var chatCell: UILabel!
    
    @IBOutlet var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
