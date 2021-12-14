//
//  UIViewController + Extension .swift
//  KabinetZhitelya
//
//  Created by Andreas on 22.04.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?, completion: @escaping () -> Void = {}) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            completion()
        }
        ac.addAction(acAction)
        present(ac, animated: true, completion: nil)
    }
    
    func showAlertToOpenLink(title: String?, message: String?, link: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acAction = UIAlertAction(title: "Отмена", style: .cancel)
        let openAction = UIAlertAction(title: "Открыть", style: .default) { (_) in
            guard let url = URL(string: link) else { return }
            UIApplication.shared.open(url)
        }
        ac.addAction(acAction)
        ac.addAction(openAction)
        present(ac, animated: true, completion: nil)
    }
}
