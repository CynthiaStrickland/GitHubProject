//
//  UserCollectionViewCell.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    class func identifier() -> String {
        return "UserCollectionViewCell"
    }
    
    @IBOutlet var imageView: UIImageView!
    var user: User! {
        didSet {
            if let url = NSURL(string: user.avatar!) {
                NSOperationQueue().addOperationWithBlock({ () -> Void in
                    let imageData = NSData(contentsOfURL: url)!
                    let image = UIImage(data: imageData)
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.imageView.image = image
                    })
                })
            }
        }
    }

    
}
