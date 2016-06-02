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
            
        } else if title!.characters.count > 50 {
            
            warningText.text = "Please limit the favor title to 50 characters"
            
        } else if descr!.characters.count > 200 {
            warningText.text = "Please limit the descrption to 200 characters"
        } else {
            if let user = FIRAuth.auth()?.currentUser {
                for profile in user.providerData {
                    uid = profile.uid;  // get Provider-specific UID
                    self.userRef.child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        let totalTokens = snapshot.value!["Tokens"] as! Int
                        
                        // find the total # of tokens of all favors user has posted
                        FirebaseProxy.firebaseProxy.favorRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                            let favorList = snapshot.value as! [String : AnyObject]
                            var totalTokensPosted = 0
                            for (key, value) in favorList {
                                let favor = Favor(key: key, dictionary: value as! Dictionary<String, AnyObject>)
                                if(profile.uid == favor.creator && !favor.completion) {
                                    totalTokensPosted += favor.tokenAmount
                                }
                            }

                            // check & display error message if they don't have enough tokens
                            let tokensLeft = totalTokens - totalTokensPosted
                            if(Int(requestedTokens!) <= tokensLeft) {
                                FirebaseProxy.firebaseProxy.saveFavor(title!, descr: descr!, tokenAmount: Int(requestedTokens!)!, creator: self.uid)
                                self.navigationController!.viewControllers.popLast()
                            } else {
                                self.warningText.text = "You wanted to post a favor with \(requestedTokens!) but you only have \(tokensLeft). Try lowering the token amount."
                            }
                        })
                    })
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
