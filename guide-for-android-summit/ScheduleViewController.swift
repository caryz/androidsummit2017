//
//  FirstViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/22/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit
import Firebase

class ScheduleViewController: UIViewController {
    // TODO: make UITableViewController
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print(auth)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

