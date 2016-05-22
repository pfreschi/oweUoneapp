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
    // Connect to Firebase DB
    var myRootRef = FIRDatabaseReference.init()
    
    
    
    /* saveFavor saves an *uncompleted* favor for the given user with the follow information:
            - favor id: uniquely identify a favor (//GENERATED AUTOMATICALLY via childByAutoID!)
            - Name of the Favor (Short title)
            - Description (details about favor)
            - Token amount: how much this favor is worth (set by the person who needs the favor done)
            - creator: user Id of who created the favor (optional parameter, defaults to current logged in user)
            - finisher: user Id of who completed the favor (not sure what to set this to if
     */
    
    override init() {
        super.init()
        myRootRef = FIRDatabase.database().reference()
    }

    func saveFavor(title: String, description: String, tokenAmount: Int, creator: String, finisher: String = "") {
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
            "creator" : creator,
            "finisher" : finisher,
            "completed" : "false" // added this here so later we can mark which ones have been completed
        ]
        myRootRef.child("favors").childByAutoId().setValue(favor)
        print("Saved a new favor!")

    }
    
    /*
    func getSingleFavor(favorID: String) -> Favor {
        myRootRef.child("favors").child(favorID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in

            let time = snapshot.value!["time"] as! NSDate
            let title = snapshot.value!["title"] as! String
            let description = snapshot.value!["description"] as! String
            let tokenAmount = snapshot.value!["tokenAmount"] as! String
            let creator = snapshot.value!["creator"] as! String
            let finisher = snapshot.value!["finisher"] as! String
            let completed = snapshot.value!["completed"] as! String
            
            //resultFavor.init(time: time, title: title, description: description, tokenAmount: tokenAmount, creator: creator, finisher: finisher, completed: completed)
        

            //HOW DO I RETURN THIS??
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    */
}


