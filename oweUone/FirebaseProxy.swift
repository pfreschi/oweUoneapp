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
    func saveFavor(id: Int, title: String, description: String, tokenAmount: Int, creator: Int, finisher: Int) {
        // time
        // favor name
        // description
        // token amount
        // giving user
        // user who completes task
        let timeCreated = String(NSDate())
        let favor: [String:String] = [
            "time" : timeCreated,
            "title" : title,
            "description" : description,
            "tokenAmount:" : String(tokenAmount),
            "creator" : String(creator),
            "finisher" : String(finisher),
            "completed" : "false" // added this here so later we can mark which ones have been completed
        ]
        myRootRef.setValue(favor)
    }
    
    func getTask() {
        
    }
}



