//
//  MyFavorViewController.swift
//  oweUone
//
//  Created by Peter Freschi on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.



import UIKit
import Foundation
import Firebase

extension NSDate {
    func daysFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
}

class MyFavorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let firebase = FirebaseProxy()
    var incompleteFavors = [Favor]()
    
    @IBOutlet weak var incompleteFavorsView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
 
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                firebase.favorRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                    let favorList = snapshot.value as! [String : AnyObject]
                    for (key, value) in favorList {
                        let favor = Favor(key: key, dictionary: value as! Dictionary<String, AnyObject>)
                        if(profile.uid == favor.creator) {
                            if (!favor.completion) {
                                self.incompleteFavors.append(favor)
                            }
                        }
                    }
                    self.incompleteFavorsView.reloadData()
                })
            }
        }

    }
    
    func setupUI() {
        incompleteFavorsView.delegate = self
        incompleteFavorsView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.incompleteFavors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IncompleteTableViewCell") as! IncompleteTableViewCell
        let currentFavor = self.incompleteFavors[indexPath.row]
        cell.title.text = currentFavor.title
        cell.tokenAmt.text = "\(currentFavor.tokenAmount) tokens"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let date = dateFormatter.dateFromString(currentFavor.time)
        let difference = NSDate().daysFrom(date!)
        if(difference < 1) {
            cell.date.text = "posted \(NSDate().hoursFrom(date!)) hours ago"
        } else if(difference > 1){
            cell.date.text = "posted \(difference) days ago"
        } else {
            cell.date.text = "posted 1 day ago"
        }
        return cell
    }
}

