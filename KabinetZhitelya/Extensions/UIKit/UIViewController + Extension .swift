//
//  UIViewController + Extension .swift
//  KabinetZhitelya
//
//  Created by Andreas on 22.04.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            completion()
        }
        ac.addAction(acAction)
        present(ac, animated: true, completion: nil)
    }
}
