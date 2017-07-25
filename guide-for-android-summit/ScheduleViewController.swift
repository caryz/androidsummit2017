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
    let ref = Database.database().reference(withPath: "schedule")

    // instance variables
    var schedule = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        handleUserLogin()
        fetchSchedule()
    }

    func handleUserLogin() {
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print(auth)
        }
    }

    func fetchSchedule() {
        ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let event = Event(snapshot: item as! DataSnapshot)
                print("\(event.title) | \(event.description) | \(event.getStartTimeInDate()) to \(event.getEndTimeInDate())")
            }
        })
    }
}
