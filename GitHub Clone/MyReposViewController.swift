//
//  MyReposViewController.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 10/21/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class MyReposViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    class func identifier() -> String {
        return "MyReposViewController"
    }
    
    @IBOutlet var tableView: UITableView!

    var user: User?
    var array = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var searchArray = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRepos()
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CustomRepoCell.identifier(), forIndexPath: indexPath) as! CustomRepoCell
        cell.repo = self.array[indexPath.row]
        
        return cell        
    }
    
    func getRepos() {
        GithubService.getRepos { (repositoryArray) -> Void in
            self.array = repositoryArray
        }
    }

    
    
}
