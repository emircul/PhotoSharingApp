//
//  SettingsViewController.swift
//  PhotoSharingApp
//
//  Created by Emir on 3.11.2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goToViewController", sender: nil)
        } catch {
            errorMessage(titleInput: "Hata", messageInput: "Çıkış yapma başarısız.")
        }
    }
    
    func errorMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
