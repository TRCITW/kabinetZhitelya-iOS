//
//  UIAlertController + Extension.swift
//  KabinetZhitelya
//
//  Created by Andreas on 07.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func alertForAuth(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}
