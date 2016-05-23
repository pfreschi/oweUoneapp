//
//  FirebaseProxy.swift
//  oweUone
//
//  This class provides methods that interact with the Firebase database.
//
//  Created by Quynh Huynh on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase



class FirebaseProxy: NSObject {
    
    static let firebaseProxy = FirebaseProxy()
    // Connect to Firebase DB
    private var _myRootRef = FIRDatabase.database().reference()
    private var _favorRef = FIRDatabase.database().reference().child("favors")
    
    var favorRef: FIRDatabaseReference {
        return _favorRef
    }
    
    var myRootRef: FIRDatabaseReference {
        return _myRootRef
    }
    
    /* saveFavor saves an *uncompleted* favor for the given user with the follow information:
     - favor id: uniquely identify a favor
     - Name of the Favor (Short title)
     - Description (details about favor)
     - Token amount: how much this favor is worth (set by the person who needs the favor done)
     - creator: user Id of who created the favor
     - finisher: user Id of who completed the favor (not sure what to set this to if
     */
    func saveFavor(title: String, descr: String, tokenAmount: Int, creator: String) {
        // time
        // favor name
        // description
        // token amount
        // giving user
        // user who completes task
        
        let timeCreated = String(NSDate())
        
        let newFavorDetails: [String:AnyObject] = [
            "time" : timeCreated,
            "title" : title,
            "descr" : descr,
            "tokenAmount:" : tokenAmount,
            "creator" : creator,
            "finisher" : "",
            "completed" : false
        ]
        FirebaseProxy.firebaseProxy.favorRef.childByAutoId().setValue(newFavorDetails)
    }
    
    func getTask() {
        
    }
}



