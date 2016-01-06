//
//  Repository.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 10/22/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import Foundation

class Repository {
    
    let name: String
    let id: Int
    let url: String
    
    init(name: String, id: Int, url: String) {
        self.name = name
        self.id = id
        self.url = url
    }
}



//        "id": 1296269,
//        "owner": {
//            "login": "octocat",
//            "id": 1,
//            ...
//        },
//        "name": "Hello-World",
//        "full_name": "octocat/Hello-World",
//        "description": "This your first repo!",
//        "private": false,
//        "fork": false,
//        "url": "https://api.github.com/repos/octocat/Hello-World",
//        "html_url": "https://github.com/octocat/Hello-World"

