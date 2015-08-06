//
//  ViewController.swift
//  KeitaTwitter
//
//  Created by Keita on 8/5/15.
//  Copyright (c) 2015 Keita Ito. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: TWTRLogInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.logInCompletion = { (session, error) in
            // play with Twitter session
            println("KeitaTwitter")
            self.moveToMainTableView()
        }
        
        
//        loginButton = TWTRLogInButton { (session, error) in
//            // play with Twitter session
//            println("KeitaTwitter")
//        }
//        loginButton = twitterLogInButton
//        logInButton.center = self.view.center
//        self.view.addSubview(logInButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToMainTableView() {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let navC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as! UINavigationController
        
        UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            appDelegate.window?.rootViewController = navC
            }) { (Bool) -> Void in
                println("Transition completed: \(Bool)")
        }
        
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "isAuthenticated")

    }


}

