//
//  FeedTableViewCell.swift
//  InstagramClone
//
//  Created by Yasemin salan on 12.02.2025.
//

import UIKit
import FirebaseStorage
import FirebaseFirestoreInternal
class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    
    @IBOutlet weak var documentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = ["likes":likeCount+1] as [String : Any]
            //sadece likes değerini güncelledik diper değerleri değiştirmedik
            fireStoreDatabase.collection("Posts").document(documentLabel.text!).setData(likeStore, merge: true)
        }
        
        
    }
}
