//
//  RecipientsService.swift
//  cleanmessage-ios
//
//  Created by Adam Novak on 2023/01/30.
//

import Foundation
import Contacts

class RecipientsService: NSObject {
    
    static var shared = RecipientsService()
    private let LOCAL_FILE_APPENDING_PATH = "recipients.json"
    private var localFileLocation: URL!
    private var recipients: [Recipient] = []
    
    //MARK: - Initializer
    
    //private initializer because there will only ever be one instance of UserService, the singleton
    private override init() {
        super.init()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        localFileLocation = documentsDirectory.appendingPathComponent(LOCAL_FILE_APPENDING_PATH)
        if FileManager.default.fileExists(atPath: localFileLocation.path) {
            loadFromFilesystem()
        } else {
            Task { await saveToFilesystem() }
        }
    }
    
    //MARK: - Getters
    
    func getRecipients() -> [Recipient] { return recipients }
    
    //MARK: - Setters
    
    func updateRecipients(to newRecipients: [Recipient]) {
        recipients = newRecipients
        Task { await saveToFilesystem() }
    }
    
    //MARK: - Filesystem
    
    func saveToFilesystem() async {
        do {
            let encoder = JSONEncoder()
            let data: Data = try encoder.encode(recipients)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: self.localFileLocation, atomically: true, encoding: .utf8)
        } catch {
            print("COULD NOT SAVE: \(error)")
        }
    }

    func loadFromFilesystem() {
        do {
            let data = try Data(contentsOf: self.localFileLocation)
            recipients = try JSONDecoder().decode([Recipient].self, from: data)
        } catch {
            print("COULD NOT LOAD: \(error)")
        }
    }
    
    func eraseData() {
        do {
            try FileManager.default.removeItem(at: self.localFileLocation)
        } catch {
            print("\(error)")
        }
    }
}
