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
        let requestedTokens = tokenAmount.text
        
        if (title!.isEmpty || descr!.isEmpty || requestedTokens!.isEmpty) {
            warningText.text = "Please fill out all the information!"
            
        } else if title!.characters.count > 20 {
            
            warningText.text = "Please limit the favor title to 20 characters"
        } else {
            if let user = FIRAuth.auth()?.currentUser {
                for profile in user.providerData {
                    uid = profile.uid;  // Provider-specific UID
                    self.userRef.child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        let totalTokens = snapshot.value!["Tokens"] as! Int
                        if(Int(requestedTokens!) <= totalTokens) {
                            FirebaseProxy.firebaseProxy.saveFavor(title!, descr: descr!, tokenAmount: Int(requestedTokens!)!, creator: self.uid)
                            self.navigationController!.viewControllers.popLast()
                            //self.performSegueWithIdentifier("backToFeed", sender: self)
                        } else {
                            self.warningText.text = "You don't have enough tokens"
                        }
                    })
                    //let test = userHasEnoughTokens(uid, requestedTokens: Int(token!)!)
                    /*print("user has enough tokens: \(test)")
                    if test {
                        FirebaseProxy.firebaseProxy.saveFavor(title!, descr: descr!, tokenAmount: Int(token!)!, creator: uid)
                        performSegueWithIdentifier("backToFeed", sender: self)
                    } else {
                        warningText.text = "You don't have enough tokens"
                    }*/
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print(FIRAuth.auth()?.currentUser?.displayName)
      //  print(FIRAuth.auth()?.currentUser?.uid)
    }
    

    var hasEnoughToken = false
    
    // returns true if this user has enough tokens to post a favor with the given # of postingTokens
    func userHasEnoughTokens(uid: String, requestedTokens: Int) -> Bool {
        self.userRef.child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let tokens = snapshot.value!["Tokens"] as! Int
            self.updateHasEnoughTokens(requestedTokens, totalTokens: tokens)
            print("enough tokens in closure: \(self.hasEnoughToken)")
        })
        print("enough tokens outside closure: \(self.hasEnoughToken)")
        return hasEnoughToken
    }
    func updateHasEnoughTokens(requestedTokens : Int, totalTokens : Int) {
        hasEnoughToken = requestedTokens <= totalTokens
    }
}
