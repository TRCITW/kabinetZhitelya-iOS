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
    private let notification = Notifications()
    
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
        
        let fcmToken = notification.messaging.fcmToken ?? ""
        
        let body: [String: Any] = ["username": email,
                                   "password": password,
                                   "fcm_token": fcmToken,
                                   "device_os": "iOS"]
        
        guard
            let request = NetworkHelper.shared.createRequest(method: .post,
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
    
    func signUp(email: String?, lastName: String?, account: Int?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard
            let email = email,
            let account = account,
            let lastName = lastName,
            email != "",
            lastName != ""
        else {
            completion(.failure(AuthErrors.notFilled))
            return
        }
        
        guard Validatos.isSimpleEmail(email)
        else {
            completion(.failure(AuthErrors.simpleEmail))
            return
        }
        
        let fcmToken = notification.messaging.fcmToken ?? ""
        
        let body: [String: Any] = ["email": email,
                                   "last_name": lastName,
                                   "number": account,
                                   "fcm_token": fcmToken,
                                   "device_os": "iOS"]
        
        guard
            let request = NetworkHelper.shared.createRequest(method: .post,
                                    body: body,
                                    endpoint: .signUp)
        else { return }
        
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let statusCode = response.response?.statusCode
                if statusCode == 201 {
                    completion(.success(Void()))
                } else if statusCode == 406 {
                    completion(.failure(AuthErrors.cantCreateAccount))
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
            let request = NetworkHelper.shared.createRequest(method: .post, body: ["username": email], endpoint: .requestRecovery)
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
        
        guard
            let request = NetworkHelper.shared.createRequest(method: .post,
                                    body: ["text": QRCode],
                                    endpoint: .linkFromQRCode)
        else { return }
        
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
