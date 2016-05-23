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
    @IBOutlet weak var favorTitle: UITextField!
    
    @IBOutlet weak var favorDescription: UITextField!

    @IBOutlet weak var tokenAmount: UITextField!
    
    @IBAction func postFavor(sender: AnyObject) {
        
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                let uid = profile.uid;  // Provider-specific UID
                if (favorTitle.text != nil && favorDescription.text != nil && tokenAmount.text != nil){
                    FirebaseProxy.firebaseProxy.saveFavor(favorTitle.text!, descr: favorDescription.text!, tokenAmount: Int(tokenAmount.text!)!, creator: uid)
                }
                

            }
            
        } else {
            // No user is signed in.
        }

        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FIRAuth.auth()?.currentUser?.displayName)
        print(FIRAuth.auth()?.currentUser?.uid)
            }
    
}
