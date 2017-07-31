//
//  Person.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/23/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import Foundation
import Firebase

struct Person {
    let company: String // "Android Engineer at Trello, GDE"
    let description: [String]
    let eventId: Int //"Huyen is an Android developer and Google Develo..."
    let avatar: String //"http://androidsummit.org/2016/img/speakers/huye..."
    let fullName: String

    // firebase properties
    let key: String
    let ref: DatabaseReference?

    init(fullName: String, company: String, description: [String], img: String,
         eventId: Int, key: String) {
        self.fullName = fullName
        self.company = company
        self.description = description
        self.avatar = img
        self.eventId = eventId
        self.key = key
        self.ref = nil
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        let p = PersonFields()

        fullName = snapshotValue[p.fullName] as? String ?? "Empty Name"
        company = snapshotValue[p.company] as? String ?? "Empty Company"
        description = snapshotValue[p.description] as? [String] ?? ["Empty Description"]
        avatar = snapshotValue[p.avatar] as? String ?? "no url"
        eventId = snapshotValue[p.eventId] as? Int ?? -1
        key = snapshot.key
        ref = snapshot.ref
    }

    func toAnyObject() -> Any {
        return [
            "company": company,
            "description": description,
            "name": fullName
        ]
    }
}
