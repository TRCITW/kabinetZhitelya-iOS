//
//  ViewController.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var nextStepButton: UIButton!
    @IBOutlet var isAccountLabel: UILabel!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var payByQRCodeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        setupButtons()
        setupTF()
        view.backgroundColor = UIColor().setupBackgroundGray()
    }
    
    private func setupLabels() {
        isAccountLabel.textColor = UIColor().setupCustomLightGray()
        orLabel.textColor = UIColor().setupCustomLightGray()
        emailLabel.textColor = UIColor().setupCustomDarkGray()
    }
    
    private func setupButtons() {
        nextStepButton.isEnabled = false
        nextStepButton.alpha = 0.5
        nextStepButton.setupBlueButton(title: "Дальше")
        payByQRCodeButton.setupWhiteButton(title: "Оплата по QR")
        createAccountButton.setTitleColor(UIColor().setupCustomBlue(), for: .normal)
    }
    
    private func setupTF() {
        loginTextField.backgroundColor = UIColor().setupPaleBlue()
        loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @IBAction func login(_ sender: UIButton) {
        
    }
    
    @IBAction func scanQRCode(_ sender: UIButton) {
        
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEnterPasswordSegue" {
            guard let dvc = segue.destination as? EnterPasswordVC else { return }
            dvc.username = loginTextField.text
        }
    }

}

extension SignInVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func textFieldChanged() {
        if loginTextField.text?.isEmpty == true {
            nextStepButton.isEnabled = false
            nextStepButton.alpha = 0.5
            loginTextField.backgroundColor = UIColor().setupPaleBlue()
        } else {
            nextStepButton.isEnabled = true
            nextStepButton.alpha = 1
            loginTextField.backgroundColor = .white
        }
    }
}

