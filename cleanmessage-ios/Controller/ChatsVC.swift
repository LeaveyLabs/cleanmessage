//
//  ViewController.swift
//  cleanmessage-ios
//
//  Created by Adam Novak on 2023/01/30.
//

import UIKit
import Contacts
import ContactsUI

class ChatsVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let messageComposer = MessageComposer() //need to hold a storng reference so the delegate will be called
    let contactStore = CNContactStore()

    var allContacts: [CNContact] = []
    var potentialRecipients: [Recipient] = RecipientsService.shared.getRecipients() {
        didSet {
            RecipientsService.shared.updateRecipients(to: potentialRecipients)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        handleContactsAccess()
    }
    
    //MARK: - Setup
    
    func handleContactsAccess() {
        ContactsManager.requestContactsIfNecessary(onController: self) { approved in
            if approved {
                Task {
                    await ContactsManager.fetchAllContacts()
                    self.allContacts = ContactsManager.allContacts.filter {
                        return $0.bestPhoneNumberE164 != nil && !$0.givenName.isEmpty
                    }
//                    self.potentialRecipients = potentialContacts.map {
//                        return User(id: "", firstName: $0.givenName, lastName: $0.familyName, username: "from contacts", phoneNumber: $0.bestPhoneNumberE164!, profilePicPath: nil)
//                    }.sorted(by: { $0.firstName < $1.firstName })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        self.filterRecipients()
                        self.tableView.reloadData()
                    }
                }
            } else {
                //do nothing?
            }
        }
    }
    
    func setupTableView() {
        tableView.delaysContentTouches = false //responsive button highlight
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.edit
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = .none
//        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 15))

        tableView.register(UINib(nibName: Constants.SBID.Cell.ChatTableCell, bundle: nil), forCellReuseIdentifier: Constants.SBID.Cell.ChatTableCell)
        tableView.register(UINib(nibName: Constants.SBID.Cell.ChatAddTableCell, bundle: nil), forCellReuseIdentifier: Constants.SBID.Cell.ChatAddTableCell)
        tableView.register(UINib(nibName: Constants.SBID.Cell.ChatPinTableCell, bundle: nil), forCellReuseIdentifier: Constants.SBID.Cell.ChatPinTableCell)
    }
    
    //MARK: - User Interaction
    
    @IBAction func composeButtonPressed() {
        sendMessageTo([])
    }
    
    @IBAction func moreButtonPressed() {
        let moreController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        moreController.addAction(UIAlertAction(title: "Rate \(Constants.appDisplayName)", style: .default, handler: { uiAlertAction in
            AppStoreReviewManager.offerViewPromptUponUserRequest()
        }))
        moreController.addAction(UIAlertAction(title: "Share \(Constants.appDisplayName)", style: .default, handler: { uiAlertAction in
            self.presentShareAppActivity()
        }))
        moreController.addAction(UIAlertAction(title: "Share feedback", style: .default, handler: { uiAlertAction in
            self.sendMessageTo(["16159754270"], body: "Hey Adam, ")
        }))
        moreController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { uiAlertAction in
            //do nothing
        }))
        present(moreController, animated: true)
    }
    
    //MARK: - Helper
    
    func sendMessageTo(_ numbers: [String], body: String = "") {
        if (messageComposer.canSendText()) {
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(recipients: numbers, body: body)
            present(messageComposeVC, animated: true)
        } else {
            AlertManager.showAlert(title: "Cannot Send Text Message", subtitle: "Your device is not able to send text messages.", primaryActionTitle: "OK", primaryActionHandler: {}, on: self)
        }
    }

}

//MARK: - UITableViewDelegate

extension ChatsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == potentialRecipients.count {
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            present(contactPicker, animated: true, completion: nil)
        } else {
            let contact = potentialRecipients[indexPath.row]
            sendMessageTo([contact.contactProperty])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Unpin") { (action, sourceView, completionHandler) in
            self.potentialRecipients.remove(at: indexPath.row)
            DispatchQueue.main.async {
//                self.tableView.reloadRows(at: [indexPath], with: .middle)
//                self.tableView.reloadDataWithRowAnimation(.fade)
                self.tableView.reloadData()
            }
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
}

//MARK: - UITableViewDataSource

extension ChatsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        potentialRecipients.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == potentialRecipients.count {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.SBID.Cell.ChatAddTableCell, for: indexPath) as! ChatAddTableCell
            cell.configure()
            return cell
        }
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.SBID.Cell.ChatPinTableCell, for: indexPath) as! ChatPinTableCell
//        let contact = potentialRecipients[indexPath.row]
//        cell.configure(recipients: [contact])
//        return cell
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.SBID.Cell.ChatTableCell, for: indexPath) as! ChatTableCell
        let contact = potentialRecipients[indexPath.row]
        cell.configure(
            image: (contact.imageData != nil) ? UIImage(data: contact.imageData!)! : nil,
            firstName: contact.firstName,
            lastName: contact.lastName)
        return cell
    }
    
}

//MARK: - CNContactPickerDelegate

extension ChatsVC: CNContactPickerDelegate {

    //having this funciton does not allow you to select a particular property of this contact
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
//        guard !potentialRecipients.contains(where: { $0.phoneNumber == contact.bestPhoneNumberE164 }) else {
//            AlertManager.showInfoCentered("You've already favorited this contact", "", on: self)
//            return
//        }
//
//        let phoneNumberCount = contact.phoneNumbers.count
//
//        guard phoneNumberCount > 0 else {
//            dismiss(animated: true)
//            //show pop up: "Selected contact does not have a number"
//            return
//        }
//
//        if phoneNumberCount == 1 {
//            addRecipient(from: contact)
//        } else {
//            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)
//
//            for i in 0...phoneNumberCount-1 {
//                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
//                alert -> Void in
//                    self.addRecipient(from: contact, withSpecificNumber: contact.phoneNumbers[i].value.stringValue)
//                })
//                alertController.addAction(phoneAction)
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
//            alert -> Void in
//
//            })
//            alertController.addAction(cancelAction)
//
//            dismiss(animated: true)
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if let stringValue = contactProperty.value as? String, stringValue == "emailAddresses" {
            addRecipient(from: contactProperty.contact, withSpecificEmail: contactProperty.value as? String)
        } else {
            addRecipient(from: contactProperty.contact, withSpecificNumber: contactProperty.value as? String)
        }
    }
    
    func addRecipient(from contact: CNContact,
                      withSpecificNumber specificNumber: String? = nil,
                      withSpecificEmail specificEmail: String? = nil) {
        var contactProperty: String? = specificEmail ?? specificNumber ?? contact.bestPhoneNumberE164
        guard let contactProperty else {
            AlertManager.showInfoCentered("Selected contact does not have a proper phone number", "", on: self)
            return
        }
        let newRecipient = Recipient(contactProperty: contactProperty,
                                     firstName: contact.givenName,
                                     lastName: contact.familyName,
                                     imageData: contact.thumbnailImageData)
        potentialRecipients.append(newRecipient)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}
