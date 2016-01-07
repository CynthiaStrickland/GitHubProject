//
//  CollectionViewFlowLayout.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    init(columns: Int) {
        
        super.init()
        
        let frame = UIScreen.mainScreen().bounds
        let width = CGRectGetWidth(frame)
        
        let sizeWidth = (width / CGFloat(columns)) - 1.0
        
        self.itemSize = CGSize(width: sizeWidth, height: sizeWidth)
        self.minimumInteritemSpacing = 1.0
        self.minimumLineSpacing = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
}
