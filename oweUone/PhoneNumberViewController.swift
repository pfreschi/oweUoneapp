//
//  PhoneNumberViewController.swift
//  oweUone
//
//  Created by Peter Freschi on 5/22/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController {

    @IBOutlet weak var enteredNumber: UITextField!
    @IBAction func phoneNumberInput(sender: UITextField) {
        if (sender.text!.characters.count >= 11) {
            let nextView = (self.storyboard?.instantiateViewControllerWithIdentifier("Login"))! as UIViewController
            self.presentViewController(nextView, animated: true, completion: nil)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Login" {
            if let destination = segue.destinationViewController as? LoginViewController {
                destination.enteredPhoneNumber = self.enteredNumber.text!
            }
        }
    }
    
    
}


