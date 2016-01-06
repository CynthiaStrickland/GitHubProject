//
//  AppDelegate.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 10/21/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var oauthViewController: LoginViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.checkOAuthStatus()
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        OAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.UserDefaults) { (success) -> () in
            if success {
                if let oauthViewController = self.oauthViewController {
                    oauthViewController.processOauthRequest()
                }
            }
        }
        
        return true
    }
    
    // MARK: Setup
    
    func checkOAuthStatus() {
        
        do {
            
            let token = try OAuth.shared.accessToken()
            print(token)
            
        } catch _ { self.presentOAuthViewController() }
    }
    
    func presentOAuthViewController() {
        
        if let tabbarController = self.window?.rootViewController as? UITabBarController, homeViewController = tabbarController.viewControllers?.first as? MyReposViewController, storyboard = tabbarController.storyboard {
            
            if let oauthViewController = storyboard.instantiateViewControllerWithIdentifier(LoginViewController.identifier()) as? LoginViewController {
                
                homeViewController.addChildViewController(oauthViewController)
                homeViewController.view.addSubview(oauthViewController.view)
                oauthViewController.didMoveToParentViewController(homeViewController)
                
                tabbarController.tabBar.hidden = true
                
                oauthViewController.oauthCompletionHandler = ({
                    UIView.animateWithDuration(0.6, delay: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        oauthViewController.view.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            oauthViewController.view.removeFromSuperview()
                            oauthViewController.removeFromParentViewController()
                            
                            tabbarController.tabBar.hidden = false
                            
                            homeViewController.update()
                    })
                })
                
                self.oauthViewController = oauthViewController
            }
        }
    }
}

