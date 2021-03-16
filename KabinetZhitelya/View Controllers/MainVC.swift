//
//  MainVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 07.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import WebKit

class MainVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var cookies: [HTTPCookie] = []
    let token = UserDefaults.standard.object(forKey: "token")

    override func viewDidLoad() {
        super.viewDidLoad()
           
        view.backgroundColor = .white
        checkloginStatus()
        setupWebView()
    }
    
    private func setupWebView() {
        
        let webView = WKWebView()
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        let url = URL(string: Constants.baseUrl)
        let request = URLRequest(url: url!)
        for cookie in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
        //webView = WKWebView(frame: .zero, configuration: config)
        
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
    }
    
    
    private func checkloginStatus() {
        if token as? String != "1" {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginScreen = storyboard.instantiateViewController(withIdentifier: "SignInVC")
                self.present(loginScreen, animated: true)
            }
        }
    }
}

extension MainVC {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        print(webView.url)
        guard let url = webView.url?.absoluteString else { return }
        if url == "https://lk2.eis24.me/#/main/dashboard/" {
            UserDefaults.standard.setValue("", forKey: "token")
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginScreen = storyboard.instantiateViewController(withIdentifier: "SignInVC")
                self.present(loginScreen, animated: true)
            }
        }
    }
}
