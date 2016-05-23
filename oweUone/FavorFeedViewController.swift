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
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        favorRef.observeEventType(.Value, withBlock: { (snapshot) in
            print(snapshot.value)
            
            self.favorsList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    // print(snap.value)
                    
                    if let favorDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let favor = Favor(key: key, dictionary: favorDict)
                        
                        self.favorsList.insert(favor, atIndex: 0)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        cell?.textLabel?.text = self.favorsList[indexPath.row].title
        cell?.detailTextLabel?.text = "\(self.favorsList[indexPath.row].descr) created by \(self.favorsList[indexPath.row].creator)"
        
        //cell.textLabel?.text = "Favor Title"
        
        //let image : UIImage = //user's facebook profile picture (retrieve using SDK)
        cell!.imageView!.image = getProfPic(self.favorsList[indexPath.row].creator)
        
        //cell?.detailTextLabel?.text = "this should be brief information about the favor like tokens, time stamp and person name who posted the favor"
        return cell!
        
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

