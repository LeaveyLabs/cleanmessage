//
//  ChatTableCell.swift
//  cleanmessage-ios
//
//  Created by Adam Novak on 2023/01/30.
//

import UIKit

class ChatTableCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        profileImageView.frame = .init(x: 0, y: 0, width: 70, height: 70) //so become round works properly
        profileImageView.becomeRound()
    }
    
    func configure(image: UIImage?, firstName: String, lastName: String?) {
        profileImageView.removeInitials()
        if let image {
            profileImageView.image = image
        } else {
            profileImageView.becomeInitialsImage(first: firstName, last: lastName)
        }
        profileImageView.becomeProfilePicImageView(with: profileImageView.image)
        nameLabel.text = "\(firstName) \(lastName ?? "")"
    }
    
}
