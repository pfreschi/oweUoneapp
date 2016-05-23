//
//  ProfileViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var school: UILabel!


    @IBOutlet weak var oweUtokens: UILabel!

    @IBOutlet weak var profilePic: UIImageView!

    @IBOutlet weak var favorCompleted: UILabel!

    @IBOutlet weak var favorRecieved: UILabel!

   
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
    }
    
    func getUserInfo() {
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                let name = profile.displayName
              //  let email = profile.email
                let photoURL = profile.photoURL
                
                username.text = name

                self.profilePic.image = UIImage(data: NSData(contentsOfURL: photoURL!)!)
                
            }
        }
        
        let FBid = NSUserDefaults.standardUserDefaults().objectForKey("FBid")
        let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
        self.profilePic.image = UIImage(data: NSData(contentsOfURL: url!)!)
    }
 

}
