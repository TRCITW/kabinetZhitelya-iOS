//
//  Endpoints.swift
//  KabinetZhitelya
//
//  Created by Andreas on 03.06.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import Foundation

enum Endpoints: String {
    
    case signIn = "api/v4/auth/login/"
    case signUp = "api/v4/registration/sign_in/"
    case requestRecovery = "api/v4/registration/reset_password/"
    case linkFromQRCode = "api/v4/public/bank_redirect_by_qr/"
    
}
