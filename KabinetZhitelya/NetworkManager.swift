//
//  NetworkManager.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager {
    
    static func signIn(body: [String: Any], completion201: @escaping ([HTTPCookie]) -> (), completion403: @escaping () -> ()) {
        guard let url = URL(string: Constants.baseUrl + "api/v4/auth/login/") else { return }
        var request = URLRequest(url: url)
        let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = httpBody
        request.method = .post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let statusCode = response.response?.statusCode
                if statusCode == 201 {
                    if let headerFields = response.response?.allHeaderFields as? [String: String], let URL = response.request?.url {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                        UserDefaults.standard.setValue("1", forKey: "token")
                        completion201(cookies)
                    }
                } else if statusCode == 403 {
                    completion403()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func signUp(body: [String: Any], completion201: @escaping () -> (), completion406: @escaping () -> ()) {
        guard let url = URL(string: Constants.baseUrl + "api/v4/registration/sign_in/") else { return }
        var request = URLRequest(url: url)
        let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = httpBody
        request.method = .post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let statusCode = response.response?.statusCode
                if statusCode == 201 {
                    completion201()
                } else if statusCode == 406 {
                    completion406()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func requestRecovery(body: [String: Any], completion201: @escaping () -> (), completion400: @escaping () -> ()) {
        guard let url = URL(string: Constants.baseUrl + "api/v4/registration/reset_password/") else { return }
        var request = URLRequest(url: url)
        let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = httpBody
        request.method = .post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let statusCode = response.response?.statusCode
                if statusCode == 201 {
                    completion201()
                } else if statusCode == 400 {
                    completion400()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func linkFromQRCode(QRCode: String, completion200: @escaping (Any) -> (), completion404: @escaping () -> ()) {
        guard let url = URL(string: Constants.baseUrl + "api/v4/public/bank_redirect_by_qr/") else { return }
        var request = URLRequest(url: url)
        let body: [String: Any] = ["text": QRCode]
        let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = httpBody
        request.method = .post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        AF.request(request).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                if statusCode == 200 {
                    let response = value as? [String: Any]
                    let url = response!["bank_url"]!
                    completion200(url)
                } else if statusCode == 404 {
                    completion404()
                }
            case .failure(let error):
                completion404()
                print("Error is: \(error.localizedDescription)")
            }
        }
    }
    
    
    
}
