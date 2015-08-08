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
        didSet {
            
            let lastMessage = messages.last!
            if lastMessage.type == .Sending {
                
                // 1 second delay with calling autoReply method
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    self.autoReply(self.messages.last!)
                }
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // set self to text field's delegete
        self.messageTextField.delegate = self
        
        // add observers for moving up text field when keyboard is displayed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        // add tap gesture recognizer for dismissing keyboard when the screen is tapped (due to UITableView)
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        
        
        
        
        
        
        // message test code
        self.view.addSubview(UIImageView(image: UIImage(named: "right_bubble")))
        
//        let aMessage = Message(text: "keita")
//        messages.append(aMessage)
//        let bMessage = Message(text: "Thom")
//        messages.append(bMessage)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // move up text field when keyboard is displayed
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    // move back text field to the bottom of the screen
    func keyboardWillHide(notification: NSNotification) {
//        var info = notification.userInfo!
//        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
        })
    }
    
    func dismissKeyboard() {
        // TODO: reignFirstResponder vs endEditing
        self.messageTextField.resignFirstResponder()
        self.containerView.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func postMessage(sender: AnyObject) {
        
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
        
        // TODO: which is correct, true or false?
        return false
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return messages.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        var cell: UITableViewCell? = nil
        
        let message = messages[indexPath.row]
        
        if message.type == .Sending {
            let cell = tableView.dequeueReusableCellWithIdentifier("SendingMessageCell", forIndexPath: indexPath) as! SendingMessageCell
            cell.messageTextLabel.text = message.text
            cell.backgroundImageView = UIImageView(image: UIImage(named: "right_bubble"))
            //cell.backgroundImageView.frame = cell.messageTextLabel.frame
            //cell.backgroundColor = UIColor.clearColor()
            return cell
        } else  {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReceivingMessageCell", forIndexPath: indexPath) as! ReceivingMessageCell
            cell.messageTextLabel.text = message.text
            cell.backgroundImageView = UIImageView(image: UIImage(named: "left_bubble"))
            //cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("MessageTableViewCell", forIndexPath: indexPath) as! MessageTableViewCell

        // Configure the cell...
//        cell.textLabel?.text = messages[indexPath.row].text
//        
//        let message: Message = messages[indexPath.row]
//        if message.type == .Sending {
//            cell.textLabel?.textAlignment = NSTextAlignment.Right
//            let imageView = UIImageView(image: UIImage(named: "right_bubble"))
//            println(cell.textLabel!.frame.size.width)
//            imageView.frame = cell.textLabel!.frame
////            cell.textLabel?.addSubview(imageView)
////            cell.insertSubview(imageView, belowSubview: cell.textLabel!)
//            cell.backgroundColor = UIColor.clearColor()
//            cell.backgroundView = imageView
//        } else if message.type == .Receiving {
//            cell.textLabel?.textAlignment = NSTextAlignment.Left
//            let imageView = UIImageView(image: UIImage(named: "left_bubble"))
//            cell.insertSubview(imageView, aboveSubview: cell.textLabel!)
//        }
        
        

//        return cell
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

    

}
