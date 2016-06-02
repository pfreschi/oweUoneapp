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
    
    var userPhoneNum : String = ""
    let rootRef = FIRDatabase.database().reference()
    let userRef = FirebaseProxy.firebaseProxy.userRef
    var imageView : UIImageView!
    var newUser : [String: AnyObject] = [ "provider" : "",
                                        "Name": "",
                                        "Email": "",
                                        "Phone": "",
                                        "Tokens": 0,
                                        "completedFavorsForOthers": []
                                    ]
    
    
    override func viewDidLoad() {
        imageView = UIImageView(frame: CGRectMake(0, 0, 200, 200))
        imageView.center = CGPoint(x: view.center.x, y: 250)
        imageView.image = UIImage(named: "bigIcon")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
        view.addSubview(imageView)
        super.viewDidLoad()
        
    }
    
    
    @IBAction func FBlogin(sender: AnyObject) {
        let FBlogin = FBSDKLoginManager()
        FBlogin.logOut()
       // FBlogin.loginBehavior = FBSDKLoginBehavior(rawValue: )
       // FBSDKAccessToken.refreshCurrentAccessToken(f)
        
        FBlogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {(result, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if result.isCancelled {
                print("Log in is cancelled.")
                
            } else {
                
                self.getProfilePic()
                
                // use FB Access token to switch for a firebase access token
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                self.firebaseLogin(credential)
                
            }
        })
    }
    
    func showFeed() {
        //when user logged in, automatically take user to the favors feed view
        let nextView = (self.storyboard?.instantiateViewControllerWithIdentifier("tabBar"))! as UIViewController
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    
    func getPhoneNumAlert(userUid: String) {
        let alertController = UIAlertController.init(title: "Login Successful", message: "Please enter your phone number", preferredStyle: .Alert)
        
        let updateAction = UIAlertAction(title:"Submit", style:.Default, handler: {
            alert -> Void in
            
            self.userPhoneNum = alertController.textFields![0].text!
            self.newUser["Phone"] = self.userPhoneNum
            
            self.addNewUser(userUid)
            self.showFeed()
            self.setNeedsFocusUpdate()
        })
        
        alertController.addAction(updateAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "000-000-0000"
        }
        
        alertController.view.setNeedsLayout()
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // add new user into firebase
    func addNewUser(userUid: String) {
        self.rootRef.child("users").child(userUid).setValue(self.newUser)
    }
    
     // get user's info with facebook token
     func getProfilePic() {
         if FBSDKAccessToken.currentAccessToken() != nil {
         let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
            graphRequest.startWithCompletionHandler({ (connection, user, requestError) -> Void in
         
                // get user FB profile picture
                let FBid = user.valueForKey("id") as? String
            
                // store facebook ID for future access
                NSUserDefaults.standardUserDefaults().setValue(FBid, forKey: "FBid")
                    
             //let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
            // self.imageView.image = UIImage(data: NSData(contentsOfURL: url!)!)
     
            })
        }
     }
    
    func firebaseLogin(credential: FIRAuthCredential) {
        
        if (FIRAuth.auth()?.currentUser?.linkWithCredential) != nil {
            print("Current user has been linked with a firebase credential.")
            //when user logged in, automatically take user to the favors feed view
            
            showFeed()
         
        } else {
            
            //start a new firebase credential
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    
                    // add the new user to Firebase database
                    for profile in user!.providerData {
                        let userUid = profile.uid
                    
                        self.newUser["provider"] = profile.providerID
                        self.newUser["Name"] = profile.displayName!
                        self.newUser["Email"] = profile.email!
                        self.newUser["Tokens"] = 100
                        //self.newUser["completedFavorsForOthers"] = []
                       // "School": "University of Washington"
                        
                        NSUserDefaults.standardUserDefaults().setValue(userUid, forKey: "uid")
                        
                        self.userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                            
                            // if user had logged in before, go to the feed view
                            if snapshot.hasChild(userUid) {
                                self.showFeed()
                                
                            } else {
                                // prompts a alert controller to ask for user phone number
                                // and add user information into firebase
                                self.getPhoneNumAlert(userUid)
                            }
                        })

                        
                        //add school to database? implement later
                        /*
                         self.rootRef.observeEventType(.Value, withBlock: { (snapshot) in
                         print(snapshot.value)
                         
                         if let schools = snapshot.childSnapshotForPath("schools") as FIRDataSnapshot! {
                         if let schoolDict = schools.value as? Dictionary<String, AnyObject> {
                         print(schoolDict)
                         //let key = snap.key
                         //let favor = Favor(key: key, dictionary: favorDict)
                         
                         //self.favorsList.insert(favor, atIndex: 0)
                         }
                         }
                         })
                         */
                        
                    }
                }
            }
        }
    }
    
}
