//
//  GithubService.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class GithubService {
    
    class func getReposWithSearch(text: String, completion: (repositoryArray: [Repository]) -> Void) {
        if let token = OAuthClient.shared.accessToken() {
            guard let baseURL = NSURL(string: "https://api.github.com/search/repositories?q=\(text)") else {return}
            print(baseURL)
            let request = NSMutableURLRequest(URL: baseURL)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")    
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                if let error = error {
                    print(error)
                }
                if let response = response as? NSHTTPURLResponse {
                    print(response.statusCode)
                    if response.statusCode == 200 {
                        if let data = data {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                if let repoArray = Repository.parseJSONToRepositoryWithSearch(data) {
                                    completion(repositoryArray: repoArray)
                                }
                            })
                        }
                        
                    }
                }
                
                }.resume()
        }
    }
    
    class func getUser(completion: (user: User) -> ())  {
        
        if let token = OAuthClient.shared.accessToken() {
            print(token)
            guard let baseURL = NSURL(string: "https://api.github.com/user") else {return}
            let request = NSMutableURLRequest(URL: baseURL)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
            
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                if let error = error {
                    print(error)
                }
                if let response = response as? NSHTTPURLResponse {
                    print(response.statusCode)
                    if response.statusCode == 200 {
                        if let data = data {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                if let user = User.getUser(data) {
                                    completion(user: user)
                                }
                            })
                            
                        }
                    }
                }
                
                
                }.resume()
        }
    }
    
    class func postRepo(name: String) {
        do {
            
            if let token = OAuthClient.shared.accessToken() {
                guard let baseURL = NSURL(string: "https://api.github.com/user/repos") else {return}
                print(baseURL)
                let request = NSMutableURLRequest(URL: baseURL)
                
                var parameters = [String: String]()
                parameters["name"] = name
                
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
                
                request.HTTPMethod = "POST"
                print(request)
                
                let parameterJSON = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
                request.HTTPBody = parameterJSON
                
                NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                    if let error = error {
                        print(error)
                    }
                    if let response = response as? NSHTTPURLResponse {
                        print(response.statusCode)
                        if response.statusCode == 200 {
                            if let data = data {
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    print(data)
                                })
                            }
                            
                        }
                    }
                    
                    }.resume()
            }
        }catch _ {}
        
    }
    
    class func getRepos(completion: (repositoryArray: [Repository]) -> Void) {
        
        guard let baseURL = NSURL(string: "https://api.github.com/repositories") else {return}
        let request = NSMutableURLRequest(URL: baseURL)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let error = error {
                print(error)
            }
            if let response = response as? NSHTTPURLResponse {
                if response.statusCode == 200 {
                    if let data = data {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            if let repoArray = Repository.parseJSONToRepository(data) {
                                completion(repositoryArray: repoArray)
                            }
                        })
                        
                    }
                }
            }
            
            }.resume()
        
        
    }
    
    class func getUserWithSearch(name: String, completion: (userArray: [User]) -> ())  {
        
        if let token = OAuthClient.shared.accessToken() {
            print(token)
            guard let baseURL = NSURL(string: "https://api.github.com/search/users?q=\(name)") else {return}
            let request = NSMutableURLRequest(URL: baseURL)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
            
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                if let error = error {
                    print(error)
                }
                if let response = response as? NSHTTPURLResponse {
                    print(response.statusCode)
                    if response.statusCode == 200 {
                        if let data = data {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                if let userArray = User.getUserArray(data) {
                                    completion(userArray: userArray)
                                }
                            })
                            
                        }
                    }
                }
                
                }.resume()
        }
    }
}