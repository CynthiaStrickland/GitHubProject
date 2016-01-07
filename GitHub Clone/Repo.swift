//
//  Repository.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 10/22/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import Foundation

class Repository {
    
    var owner: Owner?
    var name: String?
    var description: String?
    var repoURL: String!
    
    init(owner: Owner?, name: String, description: String?, repoURL: String!) {
        self.owner = owner
        self.name = name
        self.description = description
        self.repoURL = repoURL
    }
}

