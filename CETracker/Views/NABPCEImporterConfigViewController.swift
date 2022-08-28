//
//  NABPCEImporterConfigViewController.swift
//  CETracker
//
//  Created by Jon Onulak on 8/17/22.
//

import UIKit
import KeychainSwift

class NABPCEImporterConfigViewController: UIViewController, CEImporterConfigViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveLoginInfoSwitch: UISwitch!
    
    weak var delegate: CEImporterDelegate?
    var importer: NABPCEImporter!
    
    private var keychain = KeychainSwift()
    private let emailKey = "nabpEmail"
    private let passKey = "nabpPass"
    private let saveInfoKey = "saveLoginInfo"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sheetController = self.presentationController as? UISheetPresentationController {
            sheetController.detents = [.medium()]
            sheetController.prefersGrabberVisible = true
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let shouldSaveInfo = UserDefaults.standard.bool(forKey: saveInfoKey)
        saveLoginInfoSwitch.isOn = shouldSaveInfo
        emailTextField.text = keychain.get(emailKey)
        if shouldSaveInfo {
            passwordTextField.text = keychain.get(passKey)
        }
    }
    
    @IBAction func saveLoginSwitchToggled(_ sender: UISwitch) {
        if !sender.isOn {
            keychain.delete(passKey)
        }
        UserDefaults.standard.set(sender.isOn, forKey: saveInfoKey)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        configIsFinished()
    }
    
    private func configIsFinished() {
        importer.setLoginDetails(user: emailTextField.text ?? "", pass: passwordTextField.text ?? "")
        keychain.set(emailTextField.text ?? "", forKey: emailKey)
        if saveLoginInfoSwitch.isOn {
            keychain.set(passwordTextField.text ?? "", forKey: passKey)
        }
        delegate?.configDidComplete(for: importer)
    }
}

extension NABPCEImporterConfigViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField { passwordTextField.becomeFirstResponder() }
        if textField == passwordTextField { configIsFinished() }
        return false
    }
}
