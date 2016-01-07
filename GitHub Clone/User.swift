//  User.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 11/13/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import Foundation

class User {
    var name: String?
    var repoURL: String?
    var id: Int?
    var login: String?
    var avatar: String?
    
    init(name: String? = "", repoURL: String? = "", id: Int?, login: String?, avatar: String? = "") {
        self.name = name
        self.repoURL = repoURL
        self.id = id
        self.login = login
        self.avatar = avatar
    }
}
