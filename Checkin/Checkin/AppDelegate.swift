//
//  AppDelegate.swift
//  Checkin
//
//  Created by Rajat Lala on 15/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
 var testNavigationController: UINavigationController?
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "LOGIN")
        NSUserDefaults.standardUserDefaults().setObject("NO", forKey: "tosterDipslay")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "viewcontrollerentry")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "CHECKOUTCALL")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "entry")
        NSUserDefaults.standardUserDefaults().synchronize()
        RefreshAfterSubmit=false

        print(NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages"))

        if(IS_IPHONE_4)
        {
            let storyboard = UIStoryboard(name: "iPhone4", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
            testNavigationController = UINavigationController(rootViewController: vc)
            self.testNavigationController?.setNavigationBarHidden(true, animated: true)
        }
        else if(IS_IPHONE_5)
        {
            let storyboard = UIStoryboard(name: "iPhone5S", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
            testNavigationController = UINavigationController(rootViewController: vc)
            self.testNavigationController?.setNavigationBarHidden(true, animated: true)
        }
        else if(IS_IPHONE_6)
        {
            let storyboard = UIStoryboard(name: "iPhone6", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
            testNavigationController = UINavigationController(rootViewController: vc)
            self.testNavigationController?.setNavigationBarHidden(true, animated: true)
        }
        else if(IS_IPHONE_6_plus)
        {
            let storyboard = UIStoryboard(name: "iPhone6Plus", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
            testNavigationController = UINavigationController(rootViewController: vc)
            self.testNavigationController?.setNavigationBarHidden(true, animated: true)
        }

        else
        {
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let storyboard = UIStoryboard(name: "iPhone5S", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
            testNavigationController = UINavigationController(rootViewController: vc)
            self.testNavigationController?.setNavigationBarHidden(true, animated: true)
        }

        self.window?.rootViewController = testNavigationController
        Fabric.with([Crashlytics.self()])
        return true
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
        
//        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"proj_tmp")
//        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"working_tmp")
//        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"task_tmp")
//        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"city_tmp")
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkInternetConnection()-> Bool
    {
        let connected: Bool = Reachability.reachabilityForInternetConnection().isReachable()
        
        if connected == true {
            print("Internet connection OK")
            return true
        }
        else
        {
            print("Internet connection FAILED")
            return false
        }
    }
    func applicationSignificantTimeChange(appication:UIApplication)
    {
    
    }
    


}

