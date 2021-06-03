//
//  NetworkManager.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import Alamofire
import PDFKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private func createRequest(method: HTTPMethod, body: [String: Any]?, endpoint: Endpoints) -> URLRequest? {
        guard
            let url = URL(string: Constants.baseUrl + endpoint.rawValue)
        else { return nil }
        var request = URLRequest(url: url)
        if let body = body {
            let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = httpBody
        }
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("com.kabinet-zhitelya.rf", forHTTPHeaderField: "agent")
        request.setValue("ios", forHTTPHeaderField: "os")
        return request
    }
    
    func signIn(email: String?, password: String?, completion: @escaping (Result<[HTTPCookie], Error>) -> Void) {
        
        guard
            let password = password,
            let email = email,
            password != "",
            email != ""
        else {
            completion(.failure(AuthErrors.notFilled))
            return
        }
        
        guard Validatos.isSimpleEmail(email)
        else {
            completion(.failure(AuthErrors.simpleEmail))
            return
        }
        
        let body: [String: Any] = ["username": email,
                                   "password": password]
        
        guard
            let request = createRequest(method: .post,
                                    body: body,
                                    endpoint: .signIn)
        else { return }
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let statusCode = response.response?.statusCode
                if statusCode == 201 {
                    if let headerFields = response.response?.allHeaderFields as? [String: String], let URL = response.request?.url {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                        UserDefaults.standard.setValue("1", forKey: "token")
                        completion(.success(cookies))
                    }
                } else if statusCode == 403 {
                    completion(.failure(AuthErrors.invalidLoginOrPass))
                } else if statusCode == 400 {
                    completion(.failure(AuthErrors.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
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
        request.setValue("com.kabinet-zhitelya.rf", forHTTPHeaderField: "agent")
        request.setValue("ios", forHTTPHeaderField: "os")
        
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
    
    func requestRecovery(email: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard
            let email = email,
            email != ""
        else {
            completion(.failure(AuthErrors.notFilled))
            return
        }
        
        guard Validatos.isSimpleEmail(email) else {
            completion(.failure(AuthErrors.simpleEmail))
            return
        }
        
        guard
            let request = createRequest(method: .post, body: ["username": email], endpoint: .requestRecovery)
        else {
            completion(.failure(AuthErrors.unknownError))
            return
        }
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let statusCode = response.response?.statusCode
                if statusCode == 200 || statusCode == 201 {
                    completion(.success(Void()))
                } else if statusCode == 406 {
                    completion(.failure(AuthErrors.invalidLoginOrPass))
                } else if statusCode == 400 {
                    completion(.failure(AuthErrors.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
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
        request.setValue("com.kabinet-zhitelya.rf", forHTTPHeaderField: "agent")
        request.setValue("ios", forHTTPHeaderField: "os")
        
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
    
    static func downloadFile(url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let headers: HTTPHeaders = [HTTPHeader(name: "Content-Type", value: "application/pdf"),
                                    HTTPHeader(name: "Accept", value: "application/json"),
                                    HTTPHeader(name: "agent", value: "com.kabinet-zhitelya.rf")]
        
        AF.download(url, method: .get, headers: headers).responseData { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
