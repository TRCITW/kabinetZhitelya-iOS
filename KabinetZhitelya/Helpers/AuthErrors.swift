//
//  AuthErrors.swift
//  KabinetZhitelya
//
//  Created by Andreas on 03.06.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import Foundation

enum AuthErrors {
    case notFilled
    case simpleEmail
    case passesNotMatch
    case emailAlreadyInUse
    case invalidLoginOrPass
    case shortPass
    case verificationIDNotFount
    case userNotFound
    case unknownError
    case cantCreateAccount
}

extension AuthErrors: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .simpleEmail:
            return NSLocalizedString("Некорректный почтовый адрес", comment: "")
        case .passesNotMatch:
            return NSLocalizedString("Пароли не совпадают, введите пароль ещё раз", comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("На данный email уже зарегистрирован аккаунт", comment: "")
        case .invalidLoginOrPass:
            return NSLocalizedString("Неверный логин или пароль", comment: "")
        case .shortPass:
            return NSLocalizedString("Пароль должен быть не менее 6-ти символов", comment: "")
        case .verificationIDNotFount:
            return NSLocalizedString("Ваш телефон не удалось верифицировать. Попробуйте верифицировать телефон чуть позже", comment: "")
        case .userNotFound:
            return NSLocalizedString("Ваша сессия устарела. Необходимо перезайти в аккаунт", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .cantCreateAccount:
            return NSLocalizedString("Не удалось создать аккаунт", comment: "")
        }
    }
}
