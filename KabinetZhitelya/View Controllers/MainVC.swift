//
//  MainVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 07.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class MainVC: UIViewController {
    
    var cookies: [HTTPCookie] = []
    let token = UserDefaults.standard.object(forKey: "token")
    var webView: WKWebView!
    let webViewConfiguration = WKWebViewConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
           
        checkloginStatus()
        setupWebView()
        Notifications().getFCMToken()
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
        
        if key.contains("download") {
            downloadFromAccruals(url: key)
            return
        }
    }
}

// MARK: - WebView Navigation

extension MainVC: WKUIDelegate, WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
//        let url = "\(navigationAction.request)"
//        print("download url is ", url)
//        
//        if url.contains("file") && url.contains("requests") {
//            downloadFromRequests(url: url)
//            return
//        }
//        
//        if url.contains("download") {
//            downloadFromAccruals(url: url)
//            return
//        }
//        
//        if url.contains("file") && url.contains("tickets") {
//            downloadFromQuestions(url: url)
//            return
//        }
//        
//        if url.contains("online") && url.contains("cash") {
//            downloadFromPayments(url: url)
//            return
//        }
    }
    
    private func downloadFromRequests(url: String) {
        NetworkManager.downloadFile(url: url) { (result) in
            switch result {
            case .success(let data):
                print(#function)
//                guard let pdf = PDFDocument(data: data) else { print("cant cast to pdf"); return }
                let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
                self.loadWebPage(url: "https://lk2.eis24.me/#/requests/list/")
            case .failure(let error):
                self.showAlert(title: "Ошибка сохранения файла", message: error.localizedDescription) {
                    self.loadWebPage(url: "https://lk2.eis24.me/#/requests/list/")
                }
            }
        }
    }
    
    private func downloadFromAccruals(url: String) {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Back to controller", for: .normal)
        button.frame = CGRect(x: 50, y: 100, width: 100, height: 50)
//        NetworkManager.downloadFile(url: url) { (result) in
//            switch result {
//            case .success(let data):
//                guard let pdf = PDFDocument(data: data) else { print("cant cast to pdf"); return }
//                let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
//                self.present(activityController, animated: true, completion: nil)
//                self.loadWebPage(url: "https://lk2.eis24.me/#/accruals/all/")
//            case .failure(let error):
//                self.showAlert(title: "Ошибка сохранения файла", message: error.localizedDescription) {
//                    self.loadWebPage(url: "https://lk2.eis24.me/#/accruals/all/")
//                }
//            }
//        }
    }
    
    @objc private func loadWebPageAccruals() {
        let urlString = "https://lk2.eis24.me/#/accruals/all/"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        for cookie in cookies {
            self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        self.webView.load(request)
    }
    
    private func downloadFromQuestions(url: String) {
        NetworkManager.downloadFile(url: url) { (result) in
            switch result {
            case .success(let data):
//                guard let pdf = PDFDocument(data: data) else { print("cant cast to pdf"); return }
                let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
                self.loadWebPage(url: "https://lk2.eis24.me/#/tickets/list/")
            case .failure(let error):
                self.showAlert(title: "Ошибка сохранения файла", message: error.localizedDescription) {
                    self.loadWebPage(url: "https://lk2.eis24.me/#/tickets/list/")
                }
            }
        }
    }
    
    private func downloadFromPayments(url: String) {
        NetworkManager.downloadFile(url: url) { (result) in
            switch result {
            case .success(let data):
//                guard let pdf = PDFDocument(data: data) else { print("cant cast to pdf"); return }
                let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
                self.loadWebPage(url: "https://lk2.eis24.me/#/payments/list/")
            case .failure(let error):
                self.showAlert(title: "Ошибка сохранения файла", message: error.localizedDescription) {
                    self.loadWebPage(url: "https://lk2.eis24.me/#/tickets/list/")
                }
            }
        }
    }
}
