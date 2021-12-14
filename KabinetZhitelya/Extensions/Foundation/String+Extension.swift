//
//  String+Extension.swift
//  KabinetZhitelya
//
//  Created by Andreas on 27.11.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import Foundation

extension String {
    
    func stringToEnum() -> Deeplinks {
        switch self {
        case "https://applinks.eis24.me/kabinetzhitelya/tickets":
            return .tickets
        case "https://applinks.eis24.me/kabinetzhitelya/requests":
            return .requests
        case "https://applinks.eis24.me/kabinetzhitelya/accruals":
            return .accruals
        case "https://applinks.eis24.me/kabinetzhitelya/counters":
            return .counters
        case "https://applinks.eis24.me/kabinetzhitelya/news":
            return .news
        default:
            return .tickets
        }
    }
    
}
