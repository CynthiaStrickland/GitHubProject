//
//  SearchUserViewController.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var users = [User]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    class func identifier() -> String {
        return "collectionviewcell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = CustomFlowLayout(columns: 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(searchTerm: String) {
        do {
            let token = OAuth.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/search/users?access_token=\(token)&q=\(searchTerm)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = json["items"] as? [[String : AnyObject]] {
                            var users = [User]()
                            for item in items {
                            let name = item["login"] as? String
                                let profileImageUrl = item["avatar_url"] as? String
    
                                if let name = name, profileImageUrl = profileImageUrl {
                                    users.append(User(name: name, profileImageUrl: profileImageUrl, id: id))
                                }
                                
                            }
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.users = users
                            })
                        }
                    }
                }
                
                }.resume()
        } catch {}
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionviewcell", forIndexPath: indexPath) as! UserCollectionViewCell
        let user = self.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        self.update(searchTerm)
    }
    
}

