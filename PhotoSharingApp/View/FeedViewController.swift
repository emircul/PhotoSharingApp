//
//  FeedViewController.swift
//  PhotoSharingApp
//
//  Created by Emir on 3.11.2022.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray = [Post]()
    
    //var emailArray = [String]()
    //var commentArray = [String]()
    //var imageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseGetData()
    }
    
    func firebaseGetData() {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
            
            if error != nil {
                self.errorMessage(titleInput: "Hata", messageInput: error!.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    //self.emailArray.removeAll(keepingCapacity: false)
                    //self.commentArray.removeAll(keepingCapacity: false)
                    //self.imageArray.removeAll(keepingCapacity: false)
                     
                    self.postArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        if let imageUrl = document.get("imageurl") as? String {
                            if let comment = document.get("comment") as? String {
                                if let email = document.get("username") as? String {
                                    let documentID = document.documentID
                                    let post = Post(UUID: documentID,emailArray: email, commentArray: comment, imageURL: imageUrl)
                                    self.postArray.append(post)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        cell.emailLabel.text = postArray[indexPath.row].emailArray
        cell.commentLabel.text = postArray[indexPath.row].commentArray
        cell.postImageView.sd_setImage(with: URL(string: postArray[indexPath.row].imageURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").document(postArray[indexPath.row].UUID).delete() { error in
            if error != nil {
                self.errorMessage(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Post silinmedi.")
            } else {
                self.errorMessage(titleInput: "Başarılı", messageInput: "Post silindi.")
            }
        }
    }
    
    func errorMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
