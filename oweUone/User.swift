//
//  User.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    private var _UserRef: FIRDatabaseReference!
    
    private var _key: String
    private var _email: String!
    private var _name: String!
    private var _phone: String!
    private var _school: String!
    private var _provider: String!
    
    var key: String {
        return _key
    }
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }
    
    var phone: String {
        return _phone
    }
    
    var school: String {
        return _school
    }
    
    var provider: String {
        return _provider
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        if let newEmail = dictionary["Email"] as? String {
            self._email = newEmail
        }
        
        if let newName = dictionary["Name"] as? String {
            self._name = newName
        }
        
        if let newPhone = dictionary["Phone"] as? String {
            self._phone = newPhone
        }
        
        if let newSchool = dictionary["School"] as? String {
            self._school = newSchool
        }
        
        if let newProvider = dictionary["provider"] as? String {
            self._provider = newProvider
        }
        
        //the above properties added to their key?!
        self._UserRef = FirebaseProxy.firebaseProxy.myRootRef.child("users").child(self._key)
        
    }
    
    
    
}

