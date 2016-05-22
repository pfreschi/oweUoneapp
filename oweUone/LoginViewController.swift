//
//  LoginViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit

import FirebaseAuth
import Firebase
import FirebaseDatabase

import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    
    let rootRef = FIRDatabase.database().reference()
    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        imageView.center = CGPoint(x: view.center.x, y: 200)
        imageView.image = UIImage(named: "fb-art")
        view.addSubview(imageView)
        
    }
    
    
    @IBAction func FBlogin(sender: AnyObject) {
        let FBlogin = FBSDKLoginManager()
        
        FBlogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {(result, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if result.isCancelled {
                print("Log in is cancelled.")
                
            } else {
                
                //self.getProfilePic()
                
                // use FB Access token to switch for a firebase access token
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                self.firebaseLogin(credential)
                
                //when user logged in, automatically take user to the favors feed view
                let nextView = (self.storyboard?.instantiateViewControllerWithIdentifier("favorsFeed"))! as UIViewController
                self.presentViewController(nextView, animated: true, completion: nil)
            }
        })
    }
    
    /*
     func getProfilePic() {
     if FBSDKAccessToken.currentAccessToken() != nil {
     let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
     graphRequest.startWithCompletionHandler({ (connection, user, requestError) -> Void in
     
     // get user FB profile picture
     let FBid = user.valueForKey("id") as? String
     let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
     self.imageView.image = UIImage(data: NSData(contentsOfURL: url!)!)
     
     })
     }
     }
     */
    
    func firebaseLogin(credential: FIRAuthCredential) {
        
        if (FIRAuth.auth()?.currentUser?.linkWithCredential) != nil {
            
            print("Current user is been linked with a firebase credential.")
            
        } else {
            
            //start a new firebase credential
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    
                    // add the new user to Firebase database
                    for profile in user!.providerData {
                        let newUser : [String: String] = [
                            "provider": profile.providerID,
                            "Name": profile.displayName!,
                            "Email": profile.email!
                        ]
                        self.rootRef.child("users").child(profile.uid).setValue(newUser)
                        
                    }
                }
            }
        }
    }
    
}


