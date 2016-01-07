//
//  GithubService.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//
import Foundation


class GithubService {
  class func repositoriesForSearchTerm(searchTerm : String) {
    let baseURL = "http://localhost:3000"
    let finalURL = baseURL + "?q=\(searchTerm)"
    
    if let url = NSURL(string: finalURL) {
      NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
        if let error = error {
          print("error")
        } else if let httpResponse = response as? NSHTTPURLResponse {
          print(httpResponse)
        }
      }).resume()
    }
    
  }
  
  class func createFileOnRepo() {
  let baseURL = "https://api.github.com/repos/bradleypj823/TestFromApi/contents/index1.html"
  let request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
    request.HTTPMethod = "PUT"
    let filePath = NSBundle.mainBundle().pathForResource("index", ofType: "html")
   // let rawData = [NSData (contentsOfFile: <#String#>)]
    let htmlString = try? NSString(contentsOfFile: filePath!, encoding: 0)
    
    print(htmlString)
    
    let baseData = htmlString!.dataUsingEncoding(NSUTF8StringEncoding)
    let baseString = baseData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
    print(baseString)
    
    
     let json = [
      "branch" : "gh-pages",
        "message": "my commit message",
        "committer": [
          "name": "Brad",
          "email": "johnson.bradley01@gmail.com"
        ],
        "content": baseString!
    ]
    
    
    
    let data = try? NSJSONSerialization.dataWithJSONObject(json, options: [])
    request.HTTPBody = data
    
    if let token = KeychainService.loadToken() {
      request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    
    NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      print(response)
      let object = try? NSJSONSerialization.JSONObjectWithData(data!, options: [])
      print(object)
      
    }).resume()
  }
  
  class func createRepo() {
    let baseURL = "https://api.github.com/user/repos?name=TestFromApi"
    let request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
    if let token = KeychainService.loadToken() {
      request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    request.HTTPMethod = "POST"
    
    let json = ["name" : "TestFromApi"]
    let data = try? NSJSONSerialization.dataWithJSONObject(json, options: [])
    request.HTTPBody = data
    
    NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      print(response)
     let object = try? NSJSONSerialization.JSONObjectWithData(data!, options: [])
      print(object)
      
    }).resume()
    
   
  }
  
  class func userForSearchTerm(searchTerm : String, userSearchCallback : (errorDescription : String?, users :[User]?) -> (Void)) {
    let baseURL = "https://api.github.com/search/users"
    let finalURL = baseURL + "?q=\(searchTerm)"
    let request = NSMutableURLRequest(URL: NSURL(string: finalURL)!)
    if let token = KeychainService.loadToken() {
      request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    
    if let url = NSURL(string: finalURL) {
      NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        if let error = error {
          print("error")
        } else if let httpResponse = response as? NSHTTPURLResponse {
          print(httpResponse)
          //i have the data, got my response
          
          if httpResponse.statusCode == 200 {
            if let users = UserJSONParser.usersFromJSONData(data!) {
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                userSearchCallback(errorDescription: nil, users: users)
              })
            }
          }
          
          userSearchCallback(errorDescription: nil, users: nil)
          
          
        }
      }).resume()
    }
    
  }
  
}







