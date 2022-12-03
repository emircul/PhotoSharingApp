//
//  ViewController.swift
//  PhotoSharingApp
//
//  Created by Emir on 2.11.2022.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if emailTextField.text != "" && emailTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { AuthDataResult, error in
                if error != nil {
                    self.errorMessage(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Giriş yapma başarısız.")
                } else {
                    self.performSegue(withIdentifier: "goToFeedVC", sender: nil)
                }
            }
        } else {
            self.errorMessage(titleInput: "Hata!", messageInput: "E-mail ve şifre giriniz!")
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            //kayıt olma işlemi
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authDataResult, error in
                if error != nil {
                    self.errorMessage(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Kayıt olma başarısız.")
                } else {
                    self.performSegue(withIdentifier: "goToFeedVC", sender: nil)
                }
            }
        } else {
            errorMessage(titleInput: "Hata!", messageInput: "E-mail ve şifre giriniz!")
        }
    }
    
    func errorMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.text != "" && passwordTextField.text != "" {
            //kayıt olma işlemi
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authDataResult, error in
                if error != nil {
                    self.errorMessage(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Kayıt olma başarısız.")
                } else {
                    self.performSegue(withIdentifier: "goToFeedVC", sender: nil)
                }
            }
            return true
        } else {
            errorMessage(titleInput: "Hata!", messageInput: "E-mail ve şifre giriniz!")
            return false
        }
    }
}

