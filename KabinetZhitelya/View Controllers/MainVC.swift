//
//  MainVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 07.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import WebKit

class MainVC: UIViewController {
    
    var cookies: [HTTPCookie] = []
    let token = UserDefaults.standard.object(forKey: "token")
    var webView: WKWebView!
    let webViewConfiguration = WKWebViewConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
           
        checkloginStatus()
        setupWebView()
    }
    
    private func setupWebView() {
        self.webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        
        view.addSubview(webView)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        
        loadWebPage(url: Constants.baseUrl)
    }
    
    @objc private func loadWebPage(url: String) {
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        for cookie in cookies {
            self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        self.webView.load(request)
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let key = "\(change![NSKeyValueChangeKey.newKey] ?? "")"
        print(key)
        if key == "https://lk2.eis24.me/#/auth/login/" {
            UserDefaults.standard.setValue("", forKey: "token")
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginScreen = storyboard.instantiateViewController(withIdentifier: "SignInVC")
                self.present(loginScreen, animated: true)
            }
        }
    }
}

// MARK: - WebView Navigation

extension MainVC: WKUIDelegate, WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        let url = "\(navigationAction.request)"
        print("URL is ", url)
        
        
        if url.contains("arseniy") && url.contains("bot") {
            guard let url = URL(string: url) else { return }
            UIApplication.shared.open(url)
            return
        }
    }
}
