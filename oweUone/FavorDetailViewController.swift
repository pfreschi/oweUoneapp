//
//  FavorDetailViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class FavorDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate{
    
    var currentFavor = Favor(key: "NONE", dictionary: Dictionary<String, String>())
    var favorsList = [Favor]()
    var usersList = [User]()
    
    var favorCreatorName = String()
    var favorCreatorPhoneNumber = String()
    var favorFinisherName = String()
    
    var currentUserRealName = String()
    
    var currentUserIsCreator = Bool()
    
    
    @IBOutlet weak var favorPhoto: UIImageView!
    @IBOutlet weak var favorTitle: UILabel!
    @IBOutlet weak var postedTime: UILabel!
    @IBOutlet weak var earnTokens: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var favorDescription: UILabel!
    
    @IBOutlet weak var contactOrMarkAsCompleted: UIButton!
    
    @IBAction func contactOrCompletePressed(sender: UIButton) {
        if (currentUserIsCreator){
            
        } else {
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "(oweUone Inquiry): Hi there! I am interested in completing your \"\(currentFavor.title)\" favor on oweUone. -\(currentUserRealName)"
                controller.recipients = [favorCreatorPhoneNumber]
                controller.messageComposeDelegate = self
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorPhoto.image = FirebaseProxy.firebaseProxy.getProfPic(currentFavor.creator)
        favorPhoto.layer.cornerRadius = favorPhoto.frame.size.width / 2;
        favorPhoto.clipsToBounds = true;
        favorTitle.text = currentFavor.title
        
        for user in usersList {
            if (user.key == currentFavor.creator) {
                favorCreatorName = user.name
                favorCreatorPhoneNumber = user.phone
            } else if (user.key == currentFavor.finisher) {
                favorFinisherName = user.name
            } else if (user.key == NSUserDefaults.standardUserDefaults().stringForKey("FBid")){
                currentUserRealName = user.name
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
        postedTime.text = "Posted \(FirebaseProxy.firebaseProxy.timeAgoSinceDate(relativeTimeString, numericDates: true)) by \(favorCreatorName)"
        
        earnTokens.text = "Earn \(currentFavor.tokenAmount) tokens"
        school.text = "University of Washington"
        favorDescription.text = " \"\(currentFavor.descr)\""

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }


    
    
}
