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
            "tokenAmount" : tokenAmount,
            "creator" : creator,
            "finisher" : "",
            "completed" : false
        ]
        FirebaseProxy.firebaseProxy.favorRef.childByAutoId().setValue(newFavorDetails)
    }
    
    func getTask() {
        
    }
    

    
    
    
    
    
    
    
    
    
    //fair use of function from jacks205 on GitHub
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return "\(components.year) years ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) months ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) days ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) hours ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "an hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) minutes ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "a minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) seconds ago"
        } else {
            return "just now"
        }
        
    }
    
    
    
}



