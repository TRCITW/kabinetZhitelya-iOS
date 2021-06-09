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
        guard
            let email = emailTF.text,
            let lastName = surnameTF.text,
            let account = accountTF.text
        else { return }
        
        let body: [String: Any] = ["email": email,
                                   "last_name": lastName,
                                   "number": account]
        
        NetworkManager.signUp(body: body, completion201: {
            self.performSegue(withIdentifier: "ToMainVCSegue", sender: nil)
        }, completion406: {
            self.showAlert(title: "Некорректные данные", message: nil)
        })

    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
