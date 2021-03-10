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
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: loginTextField.frame.width - 28 - 14, y: 7, width: 28, height: 28)
        button.addSubview(UIImageView(image: #imageLiteral(resourceName: "loginIcon")))
        button.addTarget(self, action: #selector(loginToAccount), for: .touchUpInside)
        return button
    }()
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var isAccountLabel: UILabel!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var payByQRCodeButton: UIButton!
    @IBOutlet var telegramButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NetworkManager.linkFromQRCode(QRCode: "ST00012|Name=ТСЖ На Славе|PersonalAcc=40703810720520002626|BankName=ТКБ БАНК ПАО|BIC=044525388|CorrespAcc=30101810800000000388|PayeeINN=7814350511|PayerAddress=Славы пр-кт, д.52, корп.1, кв.874|PersAcc=7815795151439|LastName=7815795151439|PaymPeriod=02.2021|Category=Квартплата|UIN=78157951514395002210632145|TechCode=02|Sum=632145|AddAmount=000|Purpose=7815795151439 Квартплата 02.2021 Славы пр-кт, д.52, корп.1, кв.874|QuickPay=https://xn----7sbdqbfldlsq5dd8p.xn--p1ai/api/v4/public/pay_by_qr/?accrual=602e48c997bdc7006e2f693e&number=7815795151439&source=slip", completion200: {}, completion404: {})
        
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            print("YEEEES")
            self.setupVideo()
        }
        setupLabels()
        setupButtons()
        setupTF()
        view.backgroundColor = UIColor().setupBackgroundGray()
    }
    
    // MARK: - QR code scan logic
    
    func setupVideo() {
        // 2. Настраиваем устройство видео
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        // 3. Настроим input
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        // 4. Настроим output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // 5
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
    
    //MARK: - IBActions
    
    @IBAction func scanQRCode(_ sender: UIButton) {
        startRunning()
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

extension SignInVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                NetworkManager.linkFromQRCode(QRCode: object.stringValue ?? "") { (bankUrl) in
                    let alert = UIAlertController(title: "QR код распознан", message: object.stringValue, preferredStyle: .alert)
                    let goToLink = UIAlertAction(title: "Перейти", style: .default) { (action) in
                        guard let url = URL(string: bankUrl as! String) else { return }
                        UIApplication.shared.open(url)
                    }
                    alert.addAction(goToLink)
                    self.present(alert, animated: true, completion: nil)
                } completion404: {
                    let alert = UIAlertController(title: "QR код не распознан", message: object.stringValue, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Сканировать ещё", style: .cancel)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }

            }
        }
    }
}

