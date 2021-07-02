//
//  SignUpVC.swift
//  KabinetZhitelya
//
//  Created by Andreas on 07.03.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet var registrationLabel: UILabel!
    @IBOutlet var accountTF: UITextField!
    @IBOutlet var surnameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        accountTF.setupTF()
        surnameTF.setupTF()
        emailTF.setupTF()
        signUpButton.setupBlueButton(title: "Регистрация")
        registrationLabel.textColor = UIColor().setupCustomBlue()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        NetworkManager.shared.signUp(email: emailTF.text, lastName: surnameTF.text, account: Int(accountTF.text ?? "1")) { (result) in
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: "ToMainVCSegue", sender: nil)
            case .failure(let error):
                self.showAlert(title: "Некорректные данные", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
