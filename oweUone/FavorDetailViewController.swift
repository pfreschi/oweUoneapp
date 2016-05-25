//
//  FavorDetailViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class FavorDetailViewController: UIViewController {
    
    var currentFavor = Favor(key: "NONE", dictionary: Dictionary<String, String>())
    var favorsList = [Favor]()
    var usersList = [User]()
    
    var favorCreatorName = String()
    var favorFinisherName = String()
    
    var currentUserIsCreator = Bool()
    
    
    @IBOutlet weak var favorPhoto: UIImageView!
    @IBOutlet weak var favorTitle: UILabel!
    @IBOutlet weak var postedTime: UILabel!
    @IBOutlet weak var earnTokens: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var favorDescription: UILabel!
    
    @IBOutlet weak var contactOrMarkAsCompleted: UIButton!
    
    @IBAction func contactOrCompletePressed(sender: UIButton) {
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorPhoto.image = FirebaseProxy.firebaseProxy.getProfPic(currentFavor.creator)
        favorTitle.text = currentFavor.title
        
        for user in usersList {
            if (user.key == currentFavor.creator) {
                favorCreatorName = user.name
            } else if (user.key == currentFavor.finisher) {
                favorFinisherName = user.name
            }
        }
        
        if (currentFavor.creator == NSUserDefaults.standardUserDefaults().stringForKey("FBid")){
            currentUserIsCreator = true
        }
        
        if (currentUserIsCreator){
            contactOrMarkAsCompleted.setTitle("Mark as Completed", forState: .Normal)
        } else {
            contactOrMarkAsCompleted.setTitle("Contact \(favorCreatorName)", forState: .Normal)
        }

        
        
        let relativeTimeString = FirebaseProxy.firebaseProxy.convertStringDatetoNSDate(currentFavor.time)
        postedTime.text = "posted \(FirebaseProxy.firebaseProxy.timeAgoSinceDate(relativeTimeString, numericDates: true)) by \(favorCreatorName)"
        
        earnTokens.text = "earn \(currentFavor.tokenAmount) tokens"
        school.text = "University of Washington"
        favorDescription.text = " \"\(currentFavor.descr)\""

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
