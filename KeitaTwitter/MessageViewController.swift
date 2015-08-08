//
//  MessageViewController.swift
//  KeitaTwitter
//
//  Created by Keita on 8/6/15.
//  Copyright (c) 2015 Keita Ito. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var messages: [Message] = [] {
        // when post a message, the mesaage is added to messages property. Adding it triggers didSet property observer.
        didSet {
            
            let lastMessage = messages.last!
            
            // if an added message's type is Sending, call autoReply method.
            if lastMessage.type == .Sending {
                
                // 1 second delay with calling autoReply method.
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    self.autoReply(self.messages.last!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set self to text field's delegete.
        self.messageTextField.delegate = self
        
        // add observers for moving up text field when keyboard is displayed.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        // add tap gesture recognizer for dismissing keyboard when the screen is tapped (due to UITableView).
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    // remove obeservers.
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    // MARK: - Keyboard Actions
    
    // move up text field when keyboard is displayed.
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    // move back text field to the bottom of the screen
    func keyboardWillHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
        })
    }
    
    func dismissKeyboard() {
        // TODO: search reignFirstResponder vs endEditing
        self.messageTextField.resignFirstResponder()
        self.containerView.endEditing(true)
    }
    
    // MARK: - Message Actions
    
    @IBAction func postMessage(sender: AnyObject) {
        
        // if some text in textfield, add it as a message object to messages property.
        if messageTextField.text != "" {
            let sendingMessageText = messageTextField.text
            let sendingMessage = Message(text: sendingMessageText, type: .Sending)
            messages.append(sendingMessage)
            tableView.reloadData()
            println("Posted a message")
            messageTextField.text = ""
        } else {
            println("no text")
        }
    }
    
    // reply with double of the same texts of the last sending message.
    func autoReply(message: Message) {
        let messageText = message.text
        let replyMessageText = messageText + messageText
        let replyMessage = Message(text: replyMessageText, type: .Receiving)
        messages.append(replyMessage)
        tableView.reloadData()
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        // TODO: serarch which is correct, true or false?
        return false
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if message.type == .Sending {
            let cell = tableView.dequeueReusableCellWithIdentifier("SendingMessageCell", forIndexPath: indexPath) as! SendingMessageCell
            cell.messageTextView.text = message.text
            cell.backgroundImageView = UIImageView(image: UIImage(named: "right_bubble"))
            return cell
        } else  {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReceivingMessageCell", forIndexPath: indexPath) as! ReceivingMessageCell
            cell.messageTextView.text = message.text
            cell.backgroundImageView = UIImageView(image: UIImage(named: "left_bubble"))
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
