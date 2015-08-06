//
//  AppDelegate.swift
//  KeitaTwitter
//
//  Created by Keita on 8/5/15.
//  Copyright (c) 2015 Keita Ito. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var isLoggedin = false
    var initialVC: UIViewController?
    let defaults = NSUserDefaults.standardUserDefaults()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        checkAuthentication()
        
        if isLoggedin {
            window?.rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as? UIViewController
        } else {
            let rootVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            let navVC: UINavigationController = UINavigationController(rootViewController: rootVC)
            window?.rootViewController = navVC
        }

        
        
        Fabric.with([Twitter()])
        return true
    }
    
    func checkAuthentication() {
        
        let isAuthenticated = defaults.objectForKey("isAuthenticated") as? Bool
        
        if let isAuthenticated = isAuthenticated {
            if isAuthenticated == true {
                println("true")
                isLoggedin = true
            } else {
                println("false")
                isLoggedin = false
            }
        } else {
            defaults.setObject(false, forKey: "isAuthenticated")
            println("created isAuthenticated in defaults")
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

