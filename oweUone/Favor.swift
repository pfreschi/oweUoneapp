//
//  User.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class Favor: NSObject {
    private var _favorRef: FIRDatabaseReference!
    
    private var _key: String!
    private var _time: String!
    private var _creator: String!
    private var _descr: String!
    private var _finisher: String!
    private var _title: String!
    private var _tokenAmt: Int!
    private var _completion: Bool!
    
    var key: String {
        return _key
    }
    
    var time: String {
        return _time
    }
    
    var creator: String {
        return _creator
    }
    
    var descr: String {
        return _descr
    }
    
    var finisher: String {
        return _finisher
    }
    
    var title: String {
        return _title
    }
    
    var tokenAmt: Int {
        return _tokenAmt
    }
    
    var completion: Bool {
        return _completion
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        if let newTime = dictionary["time"] as? String {
            self._creator = newTime
        }

        if let newCreator = dictionary["creator"] as? String {
            self._creator = newCreator
        }
        
        if let newDescr = dictionary["descr"] as? String {
            self._descr = newDescr
        }
        
        if let newFinisher = dictionary["finisher"] as? String {
            self._finisher = newFinisher
        }
        
        if let newTitle = dictionary["title"] as? String {
            self._title = newTitle
        }
        
        if let newTokenAmt = dictionary["tokenAmt"] as? Int {
            self._tokenAmt = newTokenAmt
        }
        
        if let newCompletion = dictionary["completion"] as? Bool {
            self._completion = newCompletion
        }
        
        //the above properties added to their key?!
        self._favorRef = FirebaseProxy.firebaseProxy.favorRef.child(self._key)
        
    }
    
    
    
}

