//
//  UserDetailViewController.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/7/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

protocol UserDetailViewControllerDelegate  {
    func dismissViewController()
}

class UserDetailViewController: UIViewController {
    class func identifier() -> String {
        return "dismissViewController"
    }
    
    var otherUser: User?
    var delegate: UserDetailViewControllerDelegate?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLogin: UILabel!
    
    @IBAction func doneWithViewController (sender: UIStoryboardSegue){
        if let delegate = self.delegate {
            delegate.dismissViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userLogin.text = self.otherUser?.login
        if let url = NSURL(string: otherUser!.avatar!) {
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
