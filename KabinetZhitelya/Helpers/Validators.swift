//
//  Validators.swift
//  KabinetZhitelya
//
//  Created by Andreas on 03.06.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import Foundation

class Validatos {
    
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard
            let email = email,
            let password = password,
            let confirmPass = confirmPassword,
            email != "",
            password != "",
            confirmPass != ""
        else { return false }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
