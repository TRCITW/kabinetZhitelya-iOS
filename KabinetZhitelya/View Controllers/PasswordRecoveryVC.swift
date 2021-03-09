//
//  PasswordRecoveryVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 09.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

class PasswordRecoveryVC: UIViewController {
    
    @IBOutlet var recoveryLabel: UILabel!
    @IBOutlet var loginTF: UITextField!
    @IBOutlet var requestRecoveryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    private func setupViews() {
        requestRecoveryButton.isEnabled = false
        requestRecoveryButton.alpha = 0.5
        loginTF.setupTF()
        requestRecoveryButton.setupBlueButton(title: "Отправить")
        loginTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @IBAction func requestRecovery(_ sender: UIButton) {
        guard let username = loginTF.text else { return }
        let body: [String: Any] = ["username": username]
        NetworkManager.requestRecovery(body: body) {
            self.performSegue(withIdentifier: "recoverySuccess", sender: nil)
        } completion400: {
            let alert = UIAlertController(title: "Ошибка. Не удалось найти логин", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }

    }
    
    @IBAction func closeScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension PasswordRecoveryVC: UITextFieldDelegate {
    @objc private func textFieldChanged() {
        if loginTF.text?.isEmpty == true {
            requestRecoveryButton.isEnabled = false
            requestRecoveryButton.alpha = 0.5
        } else {
            requestRecoveryButton.isEnabled = true
            requestRecoveryButton.alpha = 1.0
        }
    }
}
