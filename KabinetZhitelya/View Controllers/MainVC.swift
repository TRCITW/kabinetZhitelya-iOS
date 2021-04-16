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
    var webView: WKWebView!
    let webViewConfiguration = WKWebViewConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
           
        //view.backgroundColor = .white
        checkloginStatus()
        setupWebView()
    }
    
    private func setupWebView() {
        
        let config = WKWebViewConfiguration()
//        webViewConfiguration.userContentController.add(self, name: "openDocument")
//        webViewConfiguration.userContentController.add(self, name: "jsError")
        
        self.webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        
        let url = URL(string: Constants.baseUrl)
        let request = URLRequest(url: url!)
        for cookie in cookies {
            self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
        //webView = WKWebView(frame: .zero, configuration: config)
        
        self.webView.load(request)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        view.addSubview(webView)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        
        
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

extension MainVC {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print(navigationResponse.response.url?.appendingPathComponent(navigationResponse.response.suggestedFilename!))
//        print(navigationResponse.response)
//        decisionHandler(.allow)
//
//    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        print(navigationAction.request)
        guard let url = URL(string: "https://lk2.eis24.me/40f0a9c5-20c6-431c-acb8-256c4ca63ba6") else { return }
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent("downloadedFile.jpg")
        do {
            try FileManager.default.copyItem(at: url, to: destinationFileUrl)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}
