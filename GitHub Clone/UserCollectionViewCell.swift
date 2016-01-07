//
//  UserCollectionViewCell.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var user: User! {
        didSet {
            
            NSOperationQueue().addOperationWithBlock { () -> Void in
                
                if let imageUrl = NSURL(string: self.user.repoURL!) {
                    guard let imageData = NSData(contentsOfURL: imageUrl) else {return}
                    let image = UIImage(data: imageData)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.imageView.image = image
                    })
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
