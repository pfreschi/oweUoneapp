//
//  UserSelectionViewController.swift
//  oweUone
//
//  Created by Quynh Huynh on 6/1/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class UserSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var usersList = [User]()
    var currentFavor = Favor(key: "NONE", dictionary: Dictionary<String, String>())
    
    @IBOutlet weak var userView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // load all user names and photos
        FirebaseProxy.firebaseProxy.myRootRef.child("users").observeEventType(.Value, withBlock: { (snapshot) in
            self.usersList = []
    
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if var userDict = snap.value as? Dictionary<String, AnyObject> {
                        let uid = snap.key
                        if uid != self.currentFavor.creator {
                            userDict["pic"] = FirebaseProxy.firebaseProxy.getProfPic(uid)
                            let user = User(key: uid, dictionary: userDict)
                            
                            self.usersList.insert(user, atIndex: 0)
                        }
                    }
                }
            }
            self.userView.reloadData()
        })
    }
    
    func setupUI() {
        userView.delegate = self
        userView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell") as! UserTableViewCell
        let currentUser = self.usersList[indexPath.row]
        cell.userName.text = currentUser.name
        cell.userSchool.text = currentUser.email
        for user in usersList {
            if (user.key == currentUser.key) {
                //add profile pic of creator
                cell.profilePic.image = user.pic
            }
        }
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
        cell.profilePic.clipsToBounds = true;
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let cell = sender as? UITableViewCell {
            let secondView = segue.destinationViewController as! FavorDetailViewController
            secondView.markCompleted = true
            let selectedIndex = userView.indexPathForCell(cell)!.row
            secondView.favorFinisherKey = usersList[selectedIndex].key
            secondView.favorFinisherName = usersList[selectedIndex].name
            secondView.currentFavor = currentFavor
        }
    }
}