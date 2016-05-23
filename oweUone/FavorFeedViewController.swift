//
//  FavorFeedViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class FavorFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootRef = FirebaseProxy().myRootRef
    let favorRef = FirebaseProxy.firebaseProxy.favorRef
    
    var favorsList = [Favor]()
    
    var usersList = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        favorRef.observeEventType(.Value, withBlock: { (snapshot) in
            print(snapshot.value)
            
            self.favorsList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let favorDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let favor = Favor(key: key, dictionary: favorDict)
                        
                        self.favorsList.insert(favor, atIndex: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
        
        rootRef.child("users").observeEventType(.Value, withBlock: { (snapshot) in
            print(snapshot.value)
            
            self.usersList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        let uid = snap.key
                        let user = User(key: uid, dictionary: userDict)
                        
                        self.usersList.insert(user, atIndex: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
        })

        
    }
    
    //Synchronizing data to the table view
    override func viewDidAppear(animated: Bool) {
        //  favorRef.observeEventType(.Value, withBlock: { (snapshot) in
        
        /*
         let newFavor = snapshot.value as! Favor
         self.favorsList.append(newFavor)
         self.tableView.reloadData()
         
         */
        // })
    }
    
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tells the FavorFeed tableview how many rows it should have
        return self.favorsList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomFavorCell
        
        cell.favorTitle.text = self.favorsList[indexPath.row].title
        cell.earnTokens.text = "earn \(self.favorsList[indexPath.row].tokenAmount) tokens"
        
        
        let postCreatorID = self.favorsList[indexPath.row].creator
        var postCreatorName = "Unknown"
        
        for user in usersList {
            if (user.key == postCreatorID) {
                postCreatorName = user.name
            }
        }
        
        
        
        let postTime = self.favorsList[indexPath.row].time
        let localeStr = "us"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: localeStr)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let date: NSDate? = dateFormatter.dateFromString(postTime)
        cell.postedTime.text = "posted \(FirebaseProxy.firebaseProxy.timeAgoSinceDate(date!, numericDates: true)) by \(postCreatorName)"
        
        
        
        //add profile pic of creator
        let creatorProfPic = getProfPic(self.favorsList[indexPath.row].creator)
        if (creatorProfPic != nil) {
            cell.favorPhoto.image = creatorProfPic
        }
        
        
        2
        cell.favorPhoto.layer.cornerRadius = cell.favorPhoto.frame.size.width / 2;
        cell.favorPhoto.clipsToBounds = true;
        
        return cell
        
    }
    
    func getProfPic(fid: String) -> UIImage? {
        if (fid != "") {
            var imgURLString = "https://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
            var imgURL = NSURL(string: imgURLString)
            var imageData = NSData(contentsOfURL: imgURL!)
            var image = UIImage(data: imageData!)
            return image
        }
        return nil
    }
    
    
    
    
}

