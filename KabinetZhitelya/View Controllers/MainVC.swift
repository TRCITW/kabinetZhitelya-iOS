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
        
        self.webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        view.addSubview(webView)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        
        loadWebPage(url: Constants.baseUrl)
    }
    
    private func loadWebPage(url: String) {
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

extension MainVC {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        let url = "\(navigationAction.request)"
        if url.contains("download_file") {
            
            NetworkManager.downloadFile(url: url) { (result) in
                switch result {
                case .success(let path):
                    self.showAlert(title: "Файл сохранён", message: "Путь к файлу: \(path)") {
                        self.loadWebPage(url: "https://lk2.eis24.me/#/accruals/all/")
                    }
                case .failure(let error):
                    self.loadWebPage(url: "https://lk2.eis24.me/#/accruals/all/")
                    self.showAlert(title: "Ошибка сохранения", message: "Данный файл уже сохранён")
                }
                return
            } // NetworkManager
            
        } // if-else
        
    } // webView func
    
}
