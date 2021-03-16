//
//  ViewController.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import AVFoundation

class SignInVC: UIViewController {
    
    var cokkies: [HTTPCookie] = []
    
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var nextStepButton: UIButton!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var isAccountLabel: UILabel!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var payByQRCodeButton: UIButton!
    @IBOutlet var telegramButton: UIButton!
    @IBOutlet var passwordRecoveryButton: UIButton!
    @IBOutlet var orView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var passwordView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            //self.setupVideo()
        }
        
        orView.backgroundColor = .white
        setupLabels()
        setupButtons()
        setupTF()
        setupCustomViews()
        view.backgroundColor = UIColor().setupBackgroundGray()
    }
    
    //MARK: - Views Prep
    
    private func setupLabels() {
        isAccountLabel.textColor = UIColor().setupCustomLightGray()
        orLabel.textColor = UIColor().setupCustomLightGray()
    }
    
    private func setupButtons() {
        loginButton.isHidden = true
        passwordRecoveryButton.isHidden = true
        nextStepButton.isEnabled = false
        nextStepButton.alpha = 0.5
        payByQRCodeButton.setupWhiteButton(title: "Оплата по QR")
        createAccountButton.setTitleColor(UIColor().setupCustomBlue(), for: .normal)
        telegramButton.setupWhiteButton(title: "Телеграм бот")
    }
    
    private func setupTF() {
        loginTextField.backgroundColor = UIColor().setupPaleBlue()
        loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTF.setupTF()
        passwordTF.isHidden = true
    }
    
    private func setupCustomViews() {
        loginView.viewForTextField()
        
        passwordView.viewForTextField()
        passwordView.isHidden = true
    }
    
    //MARK: - IBActions
    
    @IBAction func scanQRCode(_ sender: UIButton) {
        //startRunning()
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        nextStepButton.isHidden = true
        loginButton.isHidden = false
        passwordTF.isHidden = false
        passwordRecoveryButton.isHidden = false
        passwordView.isHidden = false
        passwordTF.becomeFirstResponder()
    }
    
    @IBAction func unwindSegueFromRecovery(segue: UIStoryboardSegue) {}
    
    @IBAction func goToTelegramBot() {
        guard let url = URL(string: "https://t.me/arseniy_kabinet_bot/") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard
            let username = loginTextField.text,
            let password = passwordTF.text
        else { return }
        
        let credentials: [String: Any] = ["username": username,
                                          "password": password]
        
        NetworkManager.signIn(body: credentials, completion201: { (cookies) in
            self.cokkies = cookies
            print("Cookies on enterpass Screen is: \(self.cokkies)")
            let mainVC = MainVC()
            mainVC.cookies = cookies
            self.performSegue(withIdentifier: "toMainVCSegue", sender: nil)
        }, completion403: {
            let alert = UIAlertController(title: "Неверный логин или пароль", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        })
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEnterPasswordSegue" {
            guard let dvc = segue.destination as? EnterPasswordVC else { return }
            dvc.username = loginTextField.text
        }
        
        if segue.identifier == "toMainVCSegue" {
            guard let dvc = segue.destination as? MainVC else { return }
            dvc.cookies = cokkies
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
            loginTextField.backgroundColor = UIColor().setupPaleBlue()
        }
    }
}

