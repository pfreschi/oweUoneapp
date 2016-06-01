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
    
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var contactOrMarkAsCompleted: UIButton!
    @IBAction func deletePressed(sender: AnyObject) {
        let deleteAlert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to permanently delete this favor?", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action: UIAlertAction!) in
            //permanently delete from favors list and segue backwards
            self.currentFavor.favorRef.removeValue()
            self.navigationController!.viewControllers.popLast()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(deleteAlert, animated: true, completion: nil)
        
        
    }
    
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
            deleteButton.hidden = false
            interestedLabel.hidden = true
        } else {
            contactOrMarkAsCompleted.setTitle("Contact \(favorCreatorName)", forState: .Normal)
            deleteButton.hidden = true
            interestedLabel.hidden = false
        }

        
        
        let dateString = FirebaseProxy.firebaseProxy.convertStringDatetoNSDate(currentFavor.time)
        let localeStr = "us"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: localeStr)
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        let date: String = dateFormatter.stringFromDate(dateString)
        
        postedTime.text = "posted \(date) by \(favorCreatorName)"
        
        earnTokens.text = "earn \(currentFavor.tokenAmount) tokens"
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
