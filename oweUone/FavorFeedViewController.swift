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

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tells the FavorFeed tableview how many rows it should have
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier : String = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = "Favor Title"
        
        //let image : UIImage = //user's facebook profile picture (retrieve using SDK)
        //cell!.imageView!.image = image
        
        //cell?.detailTextLabel?.text = "this should be brief information about the favor like tokens, time stamp and person name who posted the favor"
        return cell!
        
    }

    
}
