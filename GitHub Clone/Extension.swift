//
//  Extension.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import Foundation
import UIKit

extension Repository {
    
    class func parseJSONToRepository(data: NSData) -> [Repository]? {
        var repoArray = [Repository]()
        do {
            if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String: AnyObject]] {
                for objects in rootObject {
                    if let ownerDictionary = objects["owner"] as? [String: AnyObject], name = objects["full_name"] as? String, description = objects["description"] as? String, repoURL = objects["html_url"] as? String {
                        
                        let owner = Owner.getOwner(ownerDictionary)
                        let repo = Repository(owner: owner, name: name, description: description, repoURL: repoURL)
                        
                        repoArray.append(repo)
                    }
                }
                return repoArray
            }
        } catch _ {}
        return nil
    }
    
    
    class func parseJSONToRepositoryWithSearch(data: NSData) -> [Repository]? {
        
        var repoArray = [Repository]()
        
        do {
            if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject] {
                //print(rootObject)
                if let items = rootObject["items"] as? [[String:AnyObject]] {
                    for objects in items {
                        //print(objects)
                        if let ownerDictionary = objects["owner"] as? [String: AnyObject], name = objects["full_name"] as? String, description = objects["description"] as? String, repoURL = objects["html_url"] as? String {
                            print(name)
                            let owner = Owner.getOwner(ownerDictionary)
                            let repo = Repository(owner: owner, name: name, description: description, repoURL: repoURL)
                            
                            repoArray.append(repo)
                        }
                    }
                }
                return repoArray
            }
        } catch _ {}
        return nil
    }
}

extension Owner {
    
    class func getOwner(dictionary: [String: AnyObject]) -> Owner? {
        
        if let login = dictionary["login"] as? String, id = dictionary["id"] as? Int, url = dictionary["url"] as? String {
            return Owner(id: id, login: login, url: url)
        }
        return nil
    }    
}

extension User {
    
    class func getUser(data: NSData) -> User? {
        
        do {
            if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                if let login = rootObject["login"] as? String, name = rootObject["name"] as? String, repoUrl = rootObject["repos_url"] as? String, id = rootObject["id"] as? Int, avatar = rootObject["avatar_url"] as? String {
                    return User(name: name, repoURL: repoUrl, id: id, login: login, avatar: avatar)
                }
                
            }
        }catch _ {}
        return nil
    }
    
    class func getUserArray(data: NSData) -> [User]? {
        var userArray = [User]()
        
        do {
            if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                //print(rootObject)
                if let items = rootObject["items"] as? [[String:AnyObject]] {
                    for objects in items {
                        if let login = objects["login"] as? String, repoUrl = objects["repos_url"] as? String, id = objects["id"] as? Int, avatar = objects["avatar_url"] as? String {
                            
                            let user = User(repoURL: repoUrl, id: id, login: login, avatar: avatar)
                            userArray.append(user)
                            
                        }
                    }
                }
                return userArray
                
            }
        }catch _ {}
        return nil
    }
}
