//
//  PasswordRecoveryVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 09.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

class PasswordRecoveryVC: UIViewController {
    
    var email: String!
    
    @IBOutlet var recoveryLabel: UILabel!
    @IBOutlet var loginTF: UITextField!
    @IBOutlet var requestRecoveryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginTF.text = email
        setupViews()
    }
    
    private func setupViews() {
        if loginTF.text != "" {
            requestRecoveryButton.isEnabled = true
            requestRecoveryButton.alpha = 1.0
        } else {
            requestRecoveryButton.isEnabled = false
            requestRecoveryButton.alpha = 0.5
        }
        loginTF.setupTF()
        requestRecoveryButton.setupBlueButton(title: "Отправить")
        loginTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @IBAction func requestRecovery(_ sender: UIButton) {
        
        NetworkManager.shared.requestRecovery(email: loginTF.text) { (result) in
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: "recoverySuccess", sender: nil)
            case .failure(let error):
                self.showAlert(title: error.localizedDescription, message: nil)
            }
        }
    }
    
    @IBAction func closeScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Text Field Delegate

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
