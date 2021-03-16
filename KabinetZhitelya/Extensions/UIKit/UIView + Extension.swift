//
//  UIView + Extension.swift
//  KabinetZhitelya
//
//  Created by Andreas on 15.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

extension UIView {
    
    func viewForTextField() {
        self.backgroundColor = UIColor().setupPaleBlue()
        self.layer.cornerRadius = 9.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0).cgColor
    }
}
