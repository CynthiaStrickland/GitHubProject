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
    
    class func identifier() -> String {
        return "LoginViewController"
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        self.activityController.startAnimating()
                OAuth.shared.requestGithubAccess(["scope" : "user,repo"])
    }

    var oauthCompletionHandler: OAuthViewControllerCompletionHandler?

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
