//
//  ProfileViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var school: UILabel!

    @IBOutlet weak var phoneNum: UILabel!

    @IBOutlet weak var oweUtokens: UILabel!

    @IBOutlet weak var profilePic: UIImageView!

    @IBOutlet weak var favorCompleted: UILabel!

    @IBOutlet weak var favorRecieved: UILabel!

   
    @IBAction func signOut(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "FBid")
         NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        let FBManager = FBSDKLoginManager()
        FBManager.logOut()
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    
        // segue back to login view
        let nextView = (self.storyboard?.instantiateViewControllerWithIdentifier("Login"))! as UIViewController
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
    }
    
    func getUserInfo() {
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                let name = profile.displayName
                username.text = name
                
                // get user phone number
                let uid = profile.uid
                let userRef = FirebaseProxy.firebaseProxy.userRef.child(uid)
                userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
    
                    let phone = snapshot.value!["Phone"] as! String
                    self.phoneNum.text = phone
                })
            }
        }
        
        // get user profile
        let FBid = NSUserDefaults.standardUserDefaults().objectForKey("FBid")
        let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
        self.profilePic.image = UIImage(data: NSData(contentsOfURL: url!)!)
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
        self.profilePic.clipsToBounds = true;

    }
 

}
