//
//  LoginViewController.swift
//  GitHubClone
//
//  Created by Michael Babiy on 10/22/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    class func identifier() -> String {
        return "LoginViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        OAuthClient.shared.requestGithubAccess(["scope" : "user,repo"])
        spinner.startAnimating()
    }
    
}
