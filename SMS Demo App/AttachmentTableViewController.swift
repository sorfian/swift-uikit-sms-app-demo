//
//  AttachmentTableViewController.swift
//  SMS Demo App
//
//  Created by Sorfian on 26/03/23.
//

import UIKit
import MessageUI

class AttachmentTableViewController: UITableViewController {
    
    let filenames = [
        "become ios developer.pdf",
        "hello world.html",
        "cafeloisl.jpg",
        "hello sorfian.pptx",
        "my macbook.png",
        "app requirement example.docx",
        "hello sorfian.ppt",
        "app requirement example.doc"
    ]
    
    enum MIMEType: String {
        case jpg = "image/jpeg"
        case png = "image/png"
        case doc = "application/msword"
        case docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case ppt = "application/vnd.ms-powerpoint"
        case pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case html = "text/html"
        case pdf = "application/pdf"
        
        init?(type: String) {
            switch type.lowercased() {
                case "jpg": self = .jpg
                case "png": self = .png
                case "doc": self = .doc
                case "docx": self = .docx
                case "ppt": self = .ppt
                case "pptx": self = .pptx
                case "html": self = .html
                case "pdf": self = .pdf
                default: return nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filenames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "smscell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = filenames[indexPath.row]
        cell.imageView?.image = UIImage(named: "icon\(indexPath.row)");

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = filenames[indexPath.row]
        sendSMS(attachment: selectedFile)
    }
    
    private func sendSMS(attachment: String) {
        
        if let messageUrl = URL(string: "sms:123456789&body=Hello") {
            UIApplication.shared.open(messageUrl, options: [:], completionHandler: nil)
        }
        
        // Check if the device is capable of sending text message
        guard MFMessageComposeViewController.canSendText() else {
            let alertMessage = UIAlertController(title: "SMS Unavailable", message: "Your device is not capable of sending SMS.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            return
        }
            // Prefill the SMS
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        messageController.recipients = ["12345678", "72345524"]
        messageController.body = "Just sent the \(attachment) to your email. Please check!"
            // Present message view controller on screen
        present(messageController, animated: true, completion: nil)
    }

}

extension AttachmentTableViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch(result) {
            case MessageComposeResult.cancelled:
                print("SMS cancelled")
            case MessageComposeResult.failed:
                let alertMessage = UIAlertController(title: "Failure", message: "Failed to send the message.", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertMessage, animated: true, completion: nil) case MessageComposeResult.sent:
                print("SMS sent")
            @unknown default:
                print("Unknown error")
        }
        dismiss(animated: true, completion: nil)
    }
}
