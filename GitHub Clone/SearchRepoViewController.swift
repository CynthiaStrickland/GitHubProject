//
//  SearchRepoViewController.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class SearchRepoViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchReposBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var array = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    class func identifier() -> String {
        return "SearchRepoViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchReposBar.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchRepoViewController.identifier(), forIndexPath: indexPath) as! SearchRepoViewController
        cell.repo = self.array[indexPath.row]
        
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.array = []
        if let text = searchReposBar.text{
            GithubService.getReposWithSearch(text, completion: { (array) -> Void in
                self.array = array
            })
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == RepositoryWebView.identifier() {
            guard let repoWebViewController = segue.destinationViewController as? RepositoryWebView else {return}
            guard let myIndexPath = self.tableView.indexPathForSelectedRow else {return}
            let repo = self.array[myIndexPath.row]
            repoWebViewController.repo = repo
            repoWebViewController.delegate = self
        }
    }
    
    func repositoryWebViewDidFinish() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
