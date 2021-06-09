//
//  ViewController.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class SignInVC: UIViewController {
    
    var cokkies: [HTTPCookie] = []
    var locationManager = CLLocationManager()
    
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
    @IBOutlet var loginActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            //self.setupVideo()
        }
        
        loginActivityIndicator.isHidden = true
        orView.backgroundColor = .white
        setupLabels()
        setupButtons()
        setupTF()
        setupCustomViews()
        view.backgroundColor = UIColor().setupBackgroundGray()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
        payByQRCodeButton.setupWhiteButton(title: " Оплата по QR-коду")
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
        guard let email = loginTextField.text else {
            showAlert(title: AuthErrors.notFilled.errorDescription, message: nil)
            return
        }
        guard Validatos.isSimpleEmail(email) else {
            showAlert(title: AuthErrors.simpleEmail.errorDescription, message: nil)
            return
        }
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
        loginActivityIndicator.isHidden = false
        loginActivityIndicator.startAnimating()
        loginButton.isHidden = true
        
        let email = loginTextField.text
        let password = passwordTF.text
        
        NetworkManager.shared.signIn(email: email, password: password) { (result) in
            switch result {
            case .success(let cookies):
                self.cokkies = cookies
                let mainVC = MainVC()
                mainVC.cookies = cookies
                self.performSegue(withIdentifier: "toMainVCSegue", sender: nil)
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
                self.loginButton.isHidden = false
                self.loginActivityIndicator.stopAnimating()
            }
        }
    }
    
//MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMainVCSegue" {
            guard let dvc = segue.destination as? MainVC else { return }
            dvc.cookies = cokkies
        }
        
        if segue.identifier == "PasswordRecovery" {
            guard let dvc = segue.destination as? PasswordRecoveryVC else { return }
            dvc.email = loginTextField.text
        }
    }
}

// MARK: TextField Delegate

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

