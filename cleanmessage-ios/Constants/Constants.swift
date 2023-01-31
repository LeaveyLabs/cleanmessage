//
//  Constants.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import Foundation

enum Constants {
    
    static let maxPasswordLength = 1000
    
    struct Filesystem {
        static let AccountPath: String = "myaccount.json"
    }
    
    struct UserDefaultsKeys {
        static let isOnWaitList: String = "isOnWaitList"
    }

    static let appDisplayName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
    static let appTechnicalName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String

    static let defaultMailLink = URL(string: "mailto://")!
    static let gmailLink = URL(string: "googlegmail://")!
//    static let faqLink = URL(string: "https://scdatingclub.com/faq")!
    static let appStoreLink = URL(string: "https://apps.apple.com/app/apple-store/")!
//    static let landingPageLink = URL(string: "https://scdatingclub.com")!
//    static let privacyPageLink = URL(string: "https://scdatingclub.com/privacy")!
//    static let termsLink = URL(string: "https://scdatingclub.com/terms")!
//    static let feedbackLink = URL(string: "https://forms.gle/151vRvEa11Tnn3CC7")!
//    static let contactLink = URL(string: "mailto:leaveylabs@gmail.com")!

    // Note: all nib names should be the same ss their storyboard ID
    struct SBID {
        struct View {
            
        }
        struct SB {
            static let Main = "Main"
            static let Launch = "Launch"
        }
        struct Cell {
            static let ChatTableCell = "ChatTableCell"
            static let ChatAddTableCell = "ChatAddTableCell"
            static let ChatPinTableCell = "ChatPinTableCell"
        }
        struct VC {
            //Home
            static let Chats = "ChatsVC"
            
        }
        struct Segue {
            static let ToExplain = "ToExplain"
        }
    }
    
}
