//
//  OAuth.swift
//  GitHub Clone
//
//  Created by Cynthia Whitlatch on 11/9/15.
//  Copyright © 2015 Cynthia Whitlatch. All rights reserved.
//

import UIKit
import Security


let kTokenKey = "kTokenKey"
//let kAccessTokenKey = "kAccessTokenKey"
let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"


typealias OAuthCompletion = (success: Bool) -> ()

enum OAuthError: ErrorType {
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTermporaryCode(String)
    case ResponseFromGithub(String)
}

enum SaveOptions: Int {
    case UserDefaults
}

class OAuth {

    var kClientId = kClientID
    var kClientSecret = kClientSecretID

    static let shared = OAuth()
    
    func requestGithubAccess() {
        let authURL = NSURL(string: "https://github.com/login/oauth/authorize?client_id=\(kClientId)&scope=user,repo")
        UIApplication.sharedApplication().openURL(authURL!)
    }
    
    func oauthRequestWith(parameters: [String : String]) {
        var parametersString = String()
        for parameter in parameters.values {
            parametersString = parametersString.stringByAppendingString(parameter)
        }
    }
    
    func exchangeCodeInURL(codeURL : NSURL) {
        if let code = codeURL.query {
            let request = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token?\(code)&client_id=\(kClientId)&client_secret=\(kClientSecret)")!)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 && data != nil {
                        
                        do {
                            
                            if let rootObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String : AnyObject] {
                                guard let token = rootObject["access_token"] as? String else {return}
                                
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    NSUserDefaults.standardUserDefaults().setObject(token, forKey: kTokenKey)
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                })
                            }
                            
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
            }).resume()
        }
    }
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: OAuthCompletion) {
        
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(self.kClientId)&client_secret=\(self.kClientSecret)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString) {
                
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: sessionConfiguration)
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) -> Void in
                    
                    if let _ = error {
                        completion(success: false); return
                    }
                    
                    if let data = data {
                        if let tokenString = self.stringWith(data) {
                            
                            do {
                                let token = try self.accessTokenFromString(tokenString)!
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: self.saveAccessTokenToUserDefaults(token))
                                })
                                
                            } catch _ {
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: false)
                                })
                            }
                            
                        }
                    }
                }).resume()
            }
            
        } catch _ {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(success: false)
            })
        }
    }
    
    func accessTokenFromString(string: String) throws -> String? {
        
        do {
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, string.characters.count))
            if matches.count > 0 {
                for (_, value) in matches.enumerate() {
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                }
            }
        } catch _ {
            throw OAuthError.ExtractingTokenFromString("Could not extract token from string.")
        }
        
        return nil
    }
    
    func accessToken() -> String? {
        guard let token = NSUserDefaults.standardUserDefaults().stringForKey(kTokenKey) else {return nil}
        
        return token
    }
    func temporaryCodeFromCallback(url: NSURL) throws -> String {
        
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            throw OAuthError.ExtractingTermporaryCode("Error ExtractingTermporaryCode. See: temporaryCodeFromCallback:")
        }
        
        return temporaryCode
    }
    
    func stringWith(data: NSData) -> String? {
        let byteBuffer: UnsafeBufferPointer<UInt8> = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        return String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
    }
    
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
}


