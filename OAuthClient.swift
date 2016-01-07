//
//  OAuthClient.swift
//  GitHub Clone
//
//  Created by Cynthia Whitlatch on 11/9/15.
//  Copyright © 2015 Cynthia Whitlatch. All rights reserved.
//

import UIKit

let kTokenKey = "kTokenKey"
let kClientId = kClientID
let kClientSecretId = kClientSecretID
let kOAuthAuthorize = "https://github.com/login/oauth/authorize"
let kOAuthTokenAccess = "https://github.com/login/oauth/access_token"

class OAuthClient {
    
    static let shared = OAuthClient()
    
    func requestGithubAccess(parameters: [String: String]) {
        
        var requestString = ""
        print(parameters)
        
        for (index, value) in parameters {
            print(index)
            print(value)
            requestString = requestString.stringByAppendingString("\(index)=\(value)")
        }
        
        print(requestString)
        
        guard let requestURL = NSURL(string: "\(kOAuthAuthorize)?\(kClientId)&scope=\(requestString)") else {return}
        UIApplication.sharedApplication().openURL(requestURL)
        
    }
    
    func exchangeForToken(code: String, completion: (success: Bool) -> ()) {
        print(code)
        
        guard let exchangeURL = NSURL(string: "\(kOAuthTokenAccess)?\(kClientId)&\(kClientSecretId)&code=\(code)") else {return}
        let requestToken = NSMutableURLRequest(URL: exchangeURL)
        requestToken.HTTPMethod = "POST"
        requestToken.setValue("application/json", forHTTPHeaderField: "Accept")
        NSURLSession.sharedSession().dataTaskWithRequest(requestToken) { (data, response, error) -> Void in
            if let _ = error {
                print("error")
            }
            if let data = data {
                do {
                    if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                        if let accessToken = rootObject["access_token"] as? String {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(accessToken, forKey: kTokenKey)
                                completion(success: defaults.synchronize())
                            })
                        }
                    }
                    
                } catch _ {}
            }
            
            if let _ = response {
                print(":)")
            }
            
        }.resume()
        
    
    }
    
    func extractTemporaryCode(url: NSURL) -> String {
        guard let returnedURL = url.absoluteString.componentsSeparatedByString("=").last else {return "error"}
        return returnedURL
        
    }
    
    func accessToken() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(kTokenKey)
    }
    

}
