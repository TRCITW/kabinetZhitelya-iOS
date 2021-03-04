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
    
    static func signIn(body: [String: Any], completion: @escaping () -> ()) {
        guard let url = URL(string: Constants.baseUrl + "api/v4/auth/login/") else { return }
        var request = URLRequest(url: url)
        let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = httpBody
        request.method = .post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                completion()
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
