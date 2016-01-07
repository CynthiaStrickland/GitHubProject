//
//  LoginViewController.swift
//  GitHubClone
//
//  Created by Michael Babiy on 10/22/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

typealias OAuthViewControllerCompletionHandler = () -> ()

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        self.activityController.startAnimating()
        NSOperationQueue().addOperationWithBlock { () -> Void in
            usleep(1000000)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                OAuth.shared.oauthRequestWith(["scope" : "email,user,repo"])
            })
        }
    }
    
        var oauthCompletionHandler: OAuthViewControllerCompletionHandler?
        
        class func identifier() -> String {
            return "LoginViewController"
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setupAppearance()
        }
    
        func setupAppearance() {
            self.loginButton.layer.cornerRadius = 3.0
        }
        
        func processOauthRequest() {
            if let oauthCompletionHandler = self.oauthCompletionHandler {
                oauthCompletionHandler()
            }
        }
}
