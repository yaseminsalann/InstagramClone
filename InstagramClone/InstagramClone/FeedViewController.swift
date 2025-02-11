//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Yasemin salan on 11.02.2025.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var userEmailAray = [String]()
    var userCommentAray = [String]()
    var likeArray = [Int]()
    var imageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getDaraFromFirebase()

    }
    func getDaraFromFirebase(){
        let fireStoreDatabase = Firestore.firestore()
        //order ile tarihe göre sıralı bir şekilde verileri çektik
        fireStoreDatabase.collection("Posts").order(by: "date",descending: true).addSnapshotListener { (snapshot,error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.userEmailAray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userCommentAray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                       let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        print(documentID)
                        if let postedBy =  document.get("posteBy") as? String{
                            self.userEmailAray.append(postedBy)
                            print(postedBy)
                        }
                        if let postComment =  document.get("postComment") as? String{
                            self.userCommentAray.append(postComment)
                            print(postComment)
                        }
                        if let likesCount =  document.get("likes") as? Int{
                            self.likeArray.append(likesCount)
                            print(likesCount)
                        }
                        if let imageURLString =  document.get("imageUrl") as? String{
                            self.imageArray.append(imageURLString)
                            print(imageURLString)
                        }
                    }
                    self.tableView.reloadData()
                    
                }
               
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailAray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.userEmailLabel.text = userEmailAray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentAray[indexPath.row]
        cell.imageView?.sd_setImage(with: URL(string: self.imageArray[indexPath.row]))
        cell.documentLabel.text = self.documentIdArray[indexPath.row]
        return cell
    }
    
}
