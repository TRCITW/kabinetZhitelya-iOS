//
//  AccrualsVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 21.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import WebKit

class AccrualsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
    }
    
    private func setupWebView() {
        
        let config = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        
        let url = URL(string: "https://lk2.eis24.me/#/accruals/all/")
        let request = URLRequest(url: url!)
//        for cookie in cookies {
//            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
//        }
        
        //webView = WKWebView(frame: .zero, configuration: config)
        
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
    }

}

extension AccrualsVC: WKUIDelegate, WKNavigationDelegate {
    
}
