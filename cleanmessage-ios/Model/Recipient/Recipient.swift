//
//  Recipient.swift
//  cleanmessage-ios
//
//  Created by Adam Novak on 2023/01/30.
//

import Foundation

struct Recipient: Codable, Equatable {
    let contactProperty: String
    let firstName: String
    let lastName: String
    let imageData: Data?
}
