//
//  NetworkHelper.swift
//  KabinetZhitelya
//
//  Created by Andreas on 02.07.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHelper {
    
    static let shared = NetworkHelper()
    private init() { }
    
    
    func createRequest(method: HTTPMethod, body: [String: Any]?, endpoint: Endpoints) -> URLRequest? {
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
}
