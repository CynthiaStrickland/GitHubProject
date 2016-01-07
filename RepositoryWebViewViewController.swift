//
//  RepositoryWebViewViewController.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/7/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

protocol RepositoryWebViewDelegate {
    func repositoryWebViewDidFinish()
}

class RepositoryWebView: UIViewController {
    
    var repo: Repository!
    @IBOutlet weak var repoWebView: UIWebView!
    var delegate: RepositoryWebViewDelegate?
    
    
    class func identifier() -> String {
        return "RepositoryWebView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    
    func setupWebView() {
        let url = self.repo.repoURL
        print(url)
        guard let baseURL = NSURL(string: "\(url)" ) else {return}
        let request = NSMutableURLRequest(URL: baseURL)
        self.repoWebView.loadRequest(request)
    }
    
    @IBAction func doneWithViewController(sender: UIStoryboardSegue) {
        if let delegate = self.delegate {
            delegate.repositoryWebViewDidFinish()
        }
    }
}
