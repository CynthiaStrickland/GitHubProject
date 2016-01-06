//
//  MyReposViewController.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 10/21/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class MyReposViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func update() {
        do {
            let token = try OAuth.shared.accessToken()
            let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)")!
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    if let arraysOfRepoDictionaries = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [[String : AnyObject]] {
                        
                        var repositories = [Repository]()
                        for eachRepository in arraysOfRepoDictionaries {
                            let name = eachRepository["name"] as? String
                            let id = eachRepository["id"] as? Int
                            let url = eachRepository["svn_url"] as? String
                                if let name = name, id = id, url = url  {
                                let repo = Repository(name: name, id: id, url: url)
                                repositories.append(repo)
                            }
                        }

                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.repositories = repositories
                        })
                    }
                }
            }.resume()
        } catch {}
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        
        return cell
    }
}


