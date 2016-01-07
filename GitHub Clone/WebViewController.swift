//
//  WebViewController.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/6/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var item: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        
        let urlRequest = NSURLRequest(URL: NSURL(string: "http://google.com")!)
        webView.loadRequest(urlRequest)

    }
}


    
