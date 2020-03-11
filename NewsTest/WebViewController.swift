//
//  WebViewController.swift
//  NewsTest
//
//  Created by Gary on 3/6/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit
import WebKit


final class WebViewController: UIViewController, WKNavigationDelegate, Storyboarded {
    private var webView: WKWebView!
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view = self.webView

        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
    }

}


protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {
    // Creates a view controller from our storyboard. This relies on view controllers having the same storyboard identifier as their class name. This method shouldn't be overridden in conforming types.
    static func instantiate() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
