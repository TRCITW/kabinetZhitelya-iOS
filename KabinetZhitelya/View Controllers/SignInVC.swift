//
//  ViewController.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: loginTextField.frame.width - 28 - 14, y: 7, width: 28, height: 28)
        button.addSubview(UIImageView(image: #imageLiteral(resourceName: "loginIcon")))
        button.addTarget(self, action: #selector(loginToAccount), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var isAccountLabel: UILabel!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var payByQRCodeButton: UIButton!
    @IBOutlet var telegramButton: UIButton!

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
    }
    
    private func setupButtons() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        payByQRCodeButton.setupWhiteButton(title: "Оплата по QR")
        createAccountButton.setTitleColor(UIColor().setupCustomBlue(), for: .normal)
        telegramButton.setupWhiteButton(title: "Телеграм бот")
    }
    
    private func setupTF() {
        loginTextField.backgroundColor = UIColor().setupPaleBlue()
        loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginTextField.addSubview(loginButton)
    }

    
    @IBAction func scanQRCode(_ sender: UIButton) {
        
    }
    
    @IBAction func unwindSegueFromRecovery(segue: UIStoryboardSegue) {
    }
    
    @IBAction func goToTelegramBot() {
        guard let url = URL(string: "https://t.me/arseniy_kabinet_bot/") else { return }
        UIApplication.shared.open(url)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEnterPasswordSegue" {
            guard let dvc = segue.destination as? EnterPasswordVC else { return }
            dvc.username = loginTextField.text
        }
    }
    
    @objc private func loginToAccount() {
        performSegue(withIdentifier: "toEnterPasswordSegue", sender: nil)
    }

}

extension SignInVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func textFieldChanged() {
        if loginTextField.text?.isEmpty == true {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
            loginTextField.backgroundColor = UIColor().setupPaleBlue()
        } else {
            loginButton.isEnabled = true
            loginButton.alpha = 1
            loginTextField.backgroundColor = .white
        }
    }
}

