//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Roxana Carrera on 2/4/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController{
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        
        
        view = webView
        let myURL = URL(string: "https://www.bignerdranch.com")
        webView.load(URLRequest(url: myURL!))
       // webView.allowsBackForwardNavigationGestures = true
    }
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.bignerdranch.com")
        webView.load(URLRequest(url: myURL!))
        webView.allowsBackForwardNavigationGestures = true
    }*/
}

