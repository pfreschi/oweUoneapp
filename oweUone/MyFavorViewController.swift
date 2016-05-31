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
    
    var usersList = [User]()
    
    @IBOutlet weak var incompleteFavorsView: UITableView!
    @IBOutlet weak var titleMyFavors: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        if let user = FIRAuth.auth()?.currentUser {
            incompleteFavors.removeAll()
            completedFavors.removeAll()
            
            incompleteFavors = []
            completedFavors = []
            for profile in user.providerData {
                firebase.favorRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                    self.incompleteFavors.removeAll()
                    self.completedFavors.removeAll()
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
                    self.incompleteFavors.sortInPlace { (f1: Favor, f2: Favor) -> Bool in
                        return f1.time > f2.time
                    }
                    self.completedFavors.sortInPlace { (f1: Favor, f2: Favor) -> Bool in
                        return f1.time > f2.time
                    }
                    self.incompleteFavorsView.reloadData()
                })
            }
        }
        //info about all users is required to proceed to Favor Detail page
        FirebaseProxy.firebaseProxy.myRootRef.child("users").observeEventType(.Value, withBlock: { (snapshot) in
            print(snapshot.value)
            
            self.usersList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if var userDict = snap.value as? Dictionary<String, AnyObject> {
                        let uid = snap.key
                        userDict["pic"] = FirebaseProxy.firebaseProxy.getProfPic(uid)
                        let user = User(key: uid, dictionary: userDict)
                        
                        self.usersList.insert(user, atIndex: 0)
                    }
                }
            }
        })

    }
    
    @IBAction func switchFavorView(sender: UIButton) {
        incompleteView = !incompleteView
        if(incompleteView) {
            sender.setTitle("Show Completed", forState: .Normal)
            titleMyFavors.title = "My Incomplete Favors"
        } else {
            sender.setTitle("Show Incomplete", forState: .Normal)
            titleMyFavors.title = "My Completed Favors"
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
            let date = FirebaseProxy.firebaseProxy.convertStringDatetoNSDate(currentFavor.time)
            cell.date.text = "posted \(FirebaseProxy.firebaseProxy.timeAgoSinceDate(date, numericDates: true))"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showIncompleteFavorDetail"{
            if let cell = sender as? UITableViewCell {
                let i = incompleteFavorsView.indexPathForCell(cell)!.row
                let vc = segue.destinationViewController as! FavorDetailViewController
                vc.currentFavor = self.incompleteFavors[i]
                vc.favorsList = self.incompleteFavors
                vc.usersList = self.usersList
            }
        } else if segue.identifier == "showCompletedFavorDetail"{
            if let cell = sender as? UITableViewCell {
                let i = incompleteFavorsView.indexPathForCell(cell)!.row
                let vc = segue.destinationViewController as! FavorDetailViewController
                vc.currentFavor = self.completedFavors[i]
                vc.favorsList = self.completedFavors
                vc.usersList = self.usersList
            }
        }

    }
}