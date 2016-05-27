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
    var completedFavors = [Favor]()
    var incompleteView = true
    
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
                            } else {
                                self.completedFavors.append(favor)
                            }
                        } else if(profile.uid == favor.finisher) {
                            self.completedFavors.append(favor)
                        }
                    }
                    self.incompleteFavorsView.reloadData()
                })
            }
        }
    }
    
    @IBAction func switchFavorView(sender: UIButton) {
        incompleteView = !incompleteView
        if(incompleteView) {
            sender.setTitle("Show completed items", forState: .Normal)
        } else {
            sender.setTitle("Show incomplete items", forState: .Normal)
        }
        self.incompleteFavorsView.reloadData()
    }
    
    
    func setupUI() {
        incompleteFavorsView.delegate = self
        incompleteFavorsView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(incompleteView) {
            return self.incompleteFavors.count
        } else {
            return self.completedFavors.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(incompleteView) {
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
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CompleteTableViewCell") as! CompleteTableViewCell
            let currentFavor = self.completedFavors[indexPath.row]
            cell.title.text = currentFavor.title
            cell.tokenAmt.text = "\(currentFavor.tokenAmount) tokens"
            firebase.userRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                let userList = snapshot.value as! [String : AnyObject]
                for(key, value) in userList {
                    let user = User(key: key, dictionary: value as! Dictionary<String, AnyObject>)
                    if(user.key == currentFavor.finisher) {
                        cell.completedBy.text = "Completed By \(user.name)"
                    }
                }
            })
            
            return cell
        }
    }
}

