//
//  PostFavorViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import Firebase

class PostFavorViewController: UIViewController {
    @IBOutlet weak var favorTitle: UITextField!
    
    @IBOutlet weak var favorDescription: UITextField!

    @IBOutlet weak var tokenAmount: UITextField!
    
    @IBAction func postFavor(sender: AnyObject) {
        
        let fbProxy = FirebaseProxy()
        
        if (favorTitle.text != nil && favorDescription.text != nil && tokenAmount.text != nil){
            fbProxy.saveFavor(favorTitle.text!, description: favorDescription.text!, tokenAmount: Int(tokenAmount.text!)!, creator: "this should be creator's id")
        }
        
        
        
    }
    
}
