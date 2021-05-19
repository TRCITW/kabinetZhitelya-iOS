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
    
//    let url = "https://www.tutorialspoint.com/swift/swift_tutorial.pdf"
    var cookies: [HTTPCookie] = []
    let token = UserDefaults.standard.object(forKey: "token")
    var webView: WKWebView!
    let webViewConfiguration = WKWebViewConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
           
        checkloginStatus()
        setupWebView()
//        downloadFile()
    }
    
//    private func downloadFile() {
//        guard let url = URL(string: self.url) else { return }
//        let downloadSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
//        let downloadTask = downloadSession.downloadTask(with: url)
//        downloadTask.resume()
//    }
    
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

// MARK: - WebView Navigation

extension MainVC: WKUIDelegate, WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        let url = "\(navigationAction.request)"
        if url.contains("files") {
            NetworkManager.downloadFile(url: url) { (result) in
                switch result {
                case .success(let data):
                    guard let pdf = PDFDocument(data: data) else { print("cant cast to pdf"); return }
                    let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                    self.present(activityController, animated: true, completion: nil)
                    self.loadWebPage(url: "https://lk2.eis24.me/#/accruals/all/")
                case .failure(let error):
                    self.showAlert(title: "Ошибка сохранения файла", message: error.localizedDescription) {
                        self.loadWebPage(url: "https://lk2.eis24.me/#/accruals/all/")
                    }
                }
            } // NetworkManager
            
        } // if-else
        
    } // decidePolicyFor
    
}

//extension MainVC: URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("Location is \(location)")
//        DispatchQueue.main.async {
//            let pdfDoc = PDFDocument(url: location)
//            print("PDF Doc is \(pdfDoc)")
//            let activity = UIActivity()
//
////            activity.activityType = .post
//            let activityController = UIActivityViewController(activityItems: [pdfDoc], applicationActivities: [activity])
//            self.present(activityController, animated: true, completion: nil)
//
//        }
//        guard let url = downloadTask.originalRequest?.url else { return }
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
//        try? FileManager.default.removeItem(at: destinationURL)
//        do {
//            try FileManager.default.copyItem(at: location, to: destinationURL)
//            let pdfDoc = PDFDocument(url: destinationURL)
//            let activityController = UIActivityViewController(activityItems: [pdfDoc!], applicationActivities: nil)
//            DispatchQueue.main.async {
//                self.present(activityController, animated: true, completion: nil)
//            }
//        } catch let error {
//            print("Copy Error: \(error.localizedDescription)")
//        }
//    }
//}
