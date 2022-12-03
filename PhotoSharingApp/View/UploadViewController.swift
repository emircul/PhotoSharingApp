//
//  UploadViewController.swift
//  PhotoSharingApp
//
//  Created by Emir on 3.11.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        view.addGestureRecognizer(imageGestureRecognizer)
    }
    
    
    @IBAction func uploadPressed(_ sender: UIButton) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { storagemetadata, error in
                if error != nil {
                    self.showErrorMessage(title: "Hata!", message: error?.localizedDescription ?? "Hata aldınız, Tekrar deneyin!")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            if let imageUrl = imageUrl {
                                let firestoreDatabase = Firestore.firestore()
                                
                                let firestorePost = ["imageurl" : imageUrl, "comment" : self.textField.text!, "username" : Auth.auth().currentUser!.email!, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil {
                                        self.showErrorMessage(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız, Tekrar deneyiniz.")
                                    } else {
                                        
                                        self.imageView.image = UIImage(named: "image")
                                        self.textField.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func chooseImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Tamam", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
