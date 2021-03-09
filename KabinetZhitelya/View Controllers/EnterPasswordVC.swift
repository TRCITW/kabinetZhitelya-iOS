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
    var cokkies: [HTTPCookie] = []
    
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var forgetPasswordButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var isAccountLabel: UILabel!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var scanQRCodeButton: UIButton!
    @IBOutlet var telegramBotButton: UIButton!


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
        telegramBotButton.setupWhiteButton(title: "Оплата по QR")
        scanQRCodeButton.setupWhiteButton(title: "Телеграм бот")
    }
    
    private func setupTF() {
        passwordTextField.backgroundColor = UIColor().setupPaleBlue()
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    private func setupActivityIndicatir() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.center = enterButton.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @IBAction func login(_ sender: UIButton) {
        enterButton.setTitle("", for: .normal)
        //activityIndicator.startAnimating()
        guard
            let username = self.username,
            let password = passwordTextField.text
        else { return }
        
        let credentials: [String: Any] = ["username": username,
                                          "password": password]
        
        NetworkManager.signIn(body: credentials, completion201: { (cookies) in
            self.cokkies = cookies
            print("Cookies on enterpass Screen is: \(self.cokkies)")
            let mainVC = MainVC()
            mainVC.cookies = cookies
            self.performSegue(withIdentifier: "toMainVCSegue", sender: nil)
            //self.activityIndicator.stopAnimating()
        }, completion403: {
            let alert = UIAlertController(title: "Неверный логин или пароль", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        })
        
        enterButton.setTitle("Войти", for: .normal)
        print(credentials)
    }
    
    @IBAction func goToTelegramBot() {
        guard let url = URL(string: "https://t.me/arseniy_kabinet_bot/") else { return }
        UIApplication.shared.open(url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainVCSegue" {
            guard let dvc = segue.destination as? MainVC else { return }
            dvc.cookies = cokkies
        }
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
