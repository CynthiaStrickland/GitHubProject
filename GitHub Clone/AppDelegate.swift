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
    var loginViewController: LoginViewController?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.presentLoginViewController()
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let code = OAuth.shared.extractTemporaryCode(url)
        
        OAuth.shared.exchangeForToken(code) { (success) -> () in
            if success {
                
                guard let mainViewController = self.loginViewController?.parentViewController as? UserViewController else {return}
                GithubService.getUser({ (user) -> () in
                    mainViewController.user = user
                })
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    
                    self.loginViewController!.view.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        self.oginViewController?.spinner.stopAnimating()
                        self.loginViewController!.removeFromParentViewController()
                        self.loginViewController = nil
                })
            }
        }
        
        return true
    }
    
    func presentLoginViewController() {
        
        if let token = OAuth.shared.accessToken() {
            print(token)
        } else {
            guard let mainViewController = self.window?.rootViewController as? UITabBarController, storyboard = mainViewController.storyboard else {return}
            guard let authViewController = storyboard.instantiateViewControllerWithIdentifier(LoginViewController.identifier()) as? LoginViewController else {return}
            guard let firstTab = mainViewController.viewControllers?.first else {return}
            
            self.loginViewController = authViewController
            
            firstTab.addChildViewController(authViewController)
            firstTab.view.addSubview(authViewController.view)
            authViewController.didMoveToParentViewController(firstTab)
        }
    }
}

