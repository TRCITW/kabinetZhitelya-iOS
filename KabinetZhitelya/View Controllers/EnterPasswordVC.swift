//
//  EnterPasswordVC.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

class EnterPasswordVC: UIViewController {
    
    var username: String?
    
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var forgetPasswordButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var isAccountLabel: UILabel!
    @IBOutlet var createAccountButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        setupLabels()
        setupButtons()
        setupTF()

        //setupActivityIndicatir()
        view.backgroundColor = UIColor().setupBackgroundGray()
    }
    
    private func setupLabels() {
        passwordLabel.textColor = UIColor().setupCustomDarkGray()
        isAccountLabel.textColor = UIColor().setupCustomLightGray()
    }
    
    private func setupButtons() {
        enterButton.isEnabled = false
        enterButton.alpha = 0.5
        enterButton.setupBlueButton(title: "Войти")
    }
    
    private func setupTF() {
        passwordTextField.backgroundColor = UIColor().setupPaleBlue()
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    private func setupActivityIndicatir() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.center = enterButton.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @IBAction func login(_ sender: UIButton) {
        enterButton.setTitle("", for: .normal)
        //activityIndicator.startAnimating()
        guard let username = self.username,
              let password = passwordTextField.text
        else { return }
        
        let credentials: [String: Any] = ["username": username,
                                          "password": password]
        NetworkManager.signIn(body: credentials) {
            self.performSegue(withIdentifier: "toMainVCSegue", sender: nil)
            //self.activityIndicator.stopAnimating()
        }
        enterButton.setTitle("Войти", for: .normal)
        print(credentials)
    }
    

}

extension EnterPasswordVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func textFieldChanged() {
        if passwordTextField.text?.isEmpty == true {
            enterButton.isEnabled = false
            enterButton.alpha = 0.5
            passwordTextField.backgroundColor = UIColor().setupPaleBlue()
        } else {
            enterButton.isEnabled = true
            enterButton.alpha = 1
            passwordTextField.backgroundColor = .white
        }
    }
}
