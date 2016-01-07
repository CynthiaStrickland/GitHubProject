//
//  WebViewController.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    class func identifier() -> String {
        return "WebViewController"
    }

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var login: UILabel!
    
        var user: User? {
            didSet {
                self.userName.text = user?.name
                self.login.text = user?.login
                
                if let url = NSURL(string: user!.avatar!) {
                    NSOperationQueue().addOperationWithBlock({ () -> Void in
                        let imageData = NSData(contentsOfURL: url)!
                        let image = UIImage(data: imageData)
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.userImage.image = image
                    })
                })
            }
        }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.getUser()
        }
        
        func getUser() {
            GithubService.getUser { (user) -> () in
                self.user = user
            }
        }
        
}

    
