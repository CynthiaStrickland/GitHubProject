//
//  CustomRepoCell.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/7/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

class CustomRepoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    var repo: Repository? {
        didSet {
            self.titleLabel.text = repo?.name
            self.detailLabel.text = repo?.description
        }
    }
    
    class func identifier() -> String {
        return "CustomRepoCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}







