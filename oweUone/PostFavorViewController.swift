//
//  PostFavorViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class PostFavorViewController: UIViewController {
    
    let userRef = FirebaseProxy.firebaseProxy.userRef
    var uid : String = ""
    @IBOutlet weak var favorTitle: UITextField!
    
    @IBOutlet weak var favorDescription: UITextField!

    @IBOutlet weak var tokenAmount: UITextField!
    
    @IBOutlet weak var warningText: UILabel!
    
    @IBAction func inputToken(sender: AnyObject) {
        
        
    }
    
    @IBAction func postFavor(sender: AnyObject) {
        
        let title = favorTitle.text
        let descr = favorDescription.text
        let token = tokenAmount.text
        
        if (title!.isEmpty || descr!.isEmpty || token!.isEmpty) {
            
            warningText.text = "Please fill out all the information!"
        
            
        } else {
            
            
            if let user = FIRAuth.auth()?.currentUser {
                for profile in user.providerData {
                    uid = profile.uid;  // Provider-specific UID
                    if checkToken(uid, postingTokens: Int(token!)!) {
                        warningText.text = "Youd don't have enough money"
                    } else {
                    
                        FirebaseProxy.firebaseProxy.saveFavor(title!, descr: descr!, tokenAmount: Int(token!)!, creator: uid)
                        performSegueWithIdentifier("backToFeed", sender: self)
                    }
                    
                }
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print(FIRAuth.auth()?.currentUser?.displayName)
      //  print(FIRAuth.auth()?.currentUser?.uid)
    }
    
    func checkToken(uid: String, postingTokens: Int) -> Bool {
        var hasEnoughToken = true
        
        self.userRef.child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let tokens = snapshot.value!["Tokens"] as! Int
            
            if tokens < postingTokens {
                hasEnoughToken = false
            }
        })
        
        return hasEnoughToken
        
    }
    
    
}
