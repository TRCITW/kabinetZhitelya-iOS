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
    
//    lazy var nextStepButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: loginTextField.frame.width - 28 - 14, y: 7, width: 28, height: 28)
//        button.addSubview(UIImageView(image: #imageLiteral(resourceName: "loginIcon")))
//        button.addTarget(self, action: #selector(loginToAccount), for: .touchUpInside)
//        return button
//    }()
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            self.setupVideo()
        }
        setupLabels()
        setupButtons()
        setupTF()
        view.backgroundColor = UIColor().setupBackgroundGray()
    }
    
    // MARK: - QR code scan logic
    
    func setupVideo() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = view.layer.bounds
    }
    
    func startRunning() {
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    //MARK: - SetupViews
    
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
//        loginTextField.addSubview(nextStepButton)
        passwordTF.setupTF()
        passwordTF.isHidden = true
    }
    
    //MARK: - IBActions
    
    @IBAction func scanQRCode(_ sender: UIButton) {
        startRunning()
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        loginButton.isHidden = false
        passwordTF.isHidden = false
        passwordRecoveryButton.isHidden = false
    }
    
    @IBAction func unwindSegueFromRecovery(segue: UIStoryboardSegue) {
    }
    
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
            //self.activityIndicator.stopAnimating()
        }, completion403: {
            let alert = UIAlertController(title: "Неверный логин или пароль", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        })
        
        //enterButton.setTitle("Войти", for: .normal)
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
    
//    @objc private func loginToAccount() {
//        //performSegue(withIdentifier: "toEnterPasswordSegue", sender: nil)
//        loginButton.isHidden = false
//        passwordTF.isHidden = false
//        passwordRecoveryButton.isHidden = false
//    }
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

extension SignInVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                NetworkManager.linkFromQRCode(QRCode: object.stringValue ?? "") { (bankUrl) in
                    self.view.layer.sublayers?.removeLast()
                    guard let url = URL(string: bankUrl as! String) else { return }
                    UIApplication.shared.open(url)
                } completion404: {
                    let alert = UIAlertController(title: "По данному QR коду невозможно произвести оплата", message: object.stringValue, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        self.view.layer.sublayers?.removeLast()
                    }
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}

