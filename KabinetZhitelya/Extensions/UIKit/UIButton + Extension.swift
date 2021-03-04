//
//  UIButton + Extension.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setupBlueButton(title: String) {
        self.layer.cornerRadius = 9.0
        self.backgroundColor = UIColor().setupCustomBlue()
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
    }
    
    func setupWhiteButton(title: String) {
        self.layer.cornerRadius = 9.0
        self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.setTitle(title, for: .normal)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0).cgColor
        self.setTitleColor(UIColor().setupCustomBlue(), for: .normal)
    }
    
}
