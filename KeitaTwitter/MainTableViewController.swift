//
//  MainTableViewController.swift
//  KeitaTwitter
//
//  Created by Keita on 8/5/15.
//  Copyright (c) 2015 Keita Ito. All rights reserved.
//

import UIKit
import TwitterKit

class MainTableViewController: UITableViewController {
    
    var accountData: NSDictionary?
    var followersData: NSDictionary?
    var followersNameArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAccountVerifyCredentials()
        
        getFollowersList()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getAccountVerifyCredentials() {
        let statusesShowEndpoint = "https://api.twitter.com/1.1/account/verify_credentials.json"
        //        let params = ["id": "20"]
        let params: [String:String] = [:]
        var clientError : NSError?
        
        let request: NSURLRequest? = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        if let request = request {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
//                    println(json)
                    if let json = json as? NSDictionary {
                        self.accountData = json
                        
                        self.updateUI(json)
                    }
                }
                else {
                    println("Error: \(connectionError)")
                }
            }
        }
        else {
            println("Error: \(clientError)")
        }
    }
    
    func updateUI(jsonData: NSDictionary) {
        if let username = jsonData["name"] as? String {
            self.title = username
        }
    }
    
    
    func getFollowersList() {
        let statusesShowEndpoint = "https://api.twitter.com/1.1/followers/list.json"
        //        let params = ["id": "20"]
        let params: [String:String] = [:]
        var clientError : NSError?
        
        let request: NSURLRequest? = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        if let request = request {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
                    if let followersListJson = json as? NSDictionary {
                        println(followersListJson)
                        self.followersData = followersListJson
                        
                        self.createFollowersNameArray(followersListJson)
                    }
                }
                else {
                    println("Error: \(connectionError)")
                }
            }
        }
        else {
            println("Error: \(clientError)")
        }
    }
    
    func createFollowersNameArray(jsonData: NSDictionary) {
        if let array = jsonData["users"] as? NSArray {
            for user in array {
                if let name = user["name"] as? String {
                    println(name)
                    followersNameArray.append(name)
                }
                
            }
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return followersNameArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as! MainTableViewCell

        // Configure the cell...
        let username = followersNameArray[indexPath.row]
        
        cell.textLabel?.text = "@\(username)"
        

        return cell

    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        
        if segue.identifier == "moveToMessageTableView" {
            let messageVC = segue.destinationViewController as! MessageViewController
            let indexPath: NSIndexPath? = tableView.indexPathForSelectedRow()
            if let indexPath = indexPath {
                let username: String? = followersNameArray[indexPath.row]
                
                let user: User = User(username: username!)
                messageVC.user = user
                messageVC.title = username
            }
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

}
