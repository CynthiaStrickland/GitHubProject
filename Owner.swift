//
//  Owner.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/7/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import Foundation

class Owner {
    
    var id: Int?
    var login: String?
    var url: String?
    
    init(id: Int?, login: String?, url: String?) {
        self.id = id
        self.login = login
        self.url = url
    }
}