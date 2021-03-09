//
//  MainVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 07.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import WebKit

class MainVC: UIViewController, UIWebViewDelegate {
    
    var cookies: [HTTPCookie] = []
    let token = UserDefaults.standard.object(forKey: "token")
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: Constants.baseUrl)
        let request = URLRequest(url: url!)
        for cookie in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        webView.load(request)
        checkloginStatus()
        print("Cookies on main Screen is: \(token)")
    }
    
    
    private func checkloginStatus() {
        if token as? String != "1" {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if #available(iOS 13.0, *) {
                    let loginScreen = storyboard.instantiateViewController(identifier: "SignInVC")
                    self.present(loginScreen, animated: true)
                }
            }
        }
    }

}
