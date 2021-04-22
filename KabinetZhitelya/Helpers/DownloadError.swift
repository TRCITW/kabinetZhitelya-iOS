//
//  DownloadError.swift
//  KabinetZhitelya
//
//  Created by Andreas on 22.04.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import Foundation

enum DownloadErrors {

    case serverError
    case doubleFile
    
}

extension DownloadErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .doubleFile:
            return NSLocalizedString("Данный файл уже сохранён", comment: "")
        }
    }
}
