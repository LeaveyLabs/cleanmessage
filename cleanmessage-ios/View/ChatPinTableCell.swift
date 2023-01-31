//
//  ChatPinTableCell.swift
//  cleanmessage-ios
//
//  Created by Adam Novak on 2023/01/30.
//

import UIKit

class ChatPinTableCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var profileImageView2: UIImageView!
    @IBOutlet var nameLabel2: UILabel!
    
    @IBOutlet var profileImageView3: UIImageView!
    @IBOutlet var nameLabel3: UILabel!
    
    var viewPairs: [(UIImageView, UILabel)] {
        [(profileImageView, nameLabel),
         (profileImageView2, nameLabel2),
         (profileImageView3, nameLabel3),]
    }
    
    func configure(recipients: [Recipient]) {
        profileImageView.isHidden = true
        nameLabel.isHidden = true
        profileImageView2.isHidden = true
        nameLabel2.isHidden = true
        profileImageView3.isHidden = true
        nameLabel3.isHidden = true
        
        for x in 0..<recipients.count {
            let recipient = recipients[x]
            let viewPair = viewPairs[x]
            
            viewPair.0.removeInitials()
            if let data = recipient.imageData {
                viewPair.0.image = UIImage(data: data)
            } else {
                viewPair.0.becomeInitialsImage(first: recipient.firstName, last: recipient.lastName)
            }
            viewPair.0.becomeProfilePicImageView(with: viewPair.0.image)
            viewPair.1.text = "\(recipient.firstName) \(recipient.lastName)"
            viewPair.0.isHidden = false
            viewPair.1.isHidden = false
        }
        
    }
    
}
