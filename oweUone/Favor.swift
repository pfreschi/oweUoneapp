//
//  User.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import Foundation
import Firebase

class Favor {
    var time : NSDate
    var title : String
    var description : String
    var tokenAmount : String
    var creator : String
    var finisher : String
    var completed : String

    
    init(time : NSDate, title : String, description : String, tokenAmount : String, creator : String, finisher : String, completed : String) {
        self.time = time
        self.title = title
        self.description = description
        self.tokenAmount = tokenAmount
        self.creator = creator
        self.finisher = finisher
        self.completed = completed
    }
}
