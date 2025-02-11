//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by Yasemin salan on 11.02.2025.
//

import UIKit
import FirebaseStorage
import FirebaseFirestoreInternal
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //image seçildiğinde ne yapılacağı fonksiyonu
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func uploadClickedButton(_ sender: Any) {
        //galeriden seçilem resimin firebase stora kayıt edilmesi.
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5)
            {
            let uuid = UUID().uuidString
            //image storage e kayıt edilmesi
            let mediaReference = mediaFolder.child("\(uuid).jpg")
            mediaReference.putData(data, metadata: nil) { (metadata, error) in
                if  error != nil {
                    print("Image uploaded error!")
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                }
                else{
                    print("Image uploaded successfully!")
                    //kayıt işlemi başarılı ise image url ulaşılması
                    mediaReference.downloadURL() { (url, error) in
                        if  error == nil {
                            let imageUrl = url?.absoluteString ?? ""
                          //DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference:DocumentReference? = nil
                            let firestorePost = ["imageUrl":imageUrl,"posteBy":Auth.auth().currentUser!.email!,"postComment":self.commentText.text!,"date":FieldValue.serverTimestamp(),"likes":0] as [String:Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data:firestorePost, completion: { (error) in
                                if error != nil{
                                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                                }
                                else{
                                    //firestore database e başarılı bir şekilde kayıt edildi
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                        else{
                            print("Image uploaded error!")
                        }
                    }
                }
                
                
            }
        }
        
    }
    
}
