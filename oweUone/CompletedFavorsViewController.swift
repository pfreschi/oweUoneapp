//
//  CompletedFavorsViewController.swift
//  oweUone
//
//  Created by Quynh Huynh on 5/24/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class CompletedFavorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let firebase = FirebaseProxy()
    var completedFavors = [Favor]()
    
    @IBOutlet weak var completeFavorsView: UITableView!
    
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
                            if (favor.completion) {
                                self.completedFavors.append(favor)
                            }
                        }
                        if(profile.uid == favor.finisher) {
                            self.completedFavors.append(favor)
                        }
                    }
                    self.completeFavorsView.reloadData()
                })
            }
        }
        
    }
    
    func setupUI() {
        completeFavorsView.delegate = self
        completeFavorsView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completedFavors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
