//
//  ViewController.swift
//  GitHub Clone
//
//  Created by Cynthia Whitlatch on 11/9/15.
//  Copyright © 2015 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    @IBAction func requestTokenButton(sender: AnyObject) {
        
        OAuth.shared.requestGithubAccess()
        
    }
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
        
    }



}

