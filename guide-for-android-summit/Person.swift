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
    let description: String
    let eventId: Int //"Huyen is an Android developer and Google Develo..."
    let avatar: String //"http://androidsummit.org/2016/img/speakers/huye..."
    let fullName: String

    // firebase properties
    let key: String
    let ref: DatabaseReference?

    init(fullName: String, company: String, description: String, img: String,
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
        let s = SpeakerFields()

        fullName = snapshotValue[s.fullName] as? String ?? "Empty Name"
        company = snapshotValue[s.company] as? String ?? "Empty Company"
        description = snapshotValue[s.description] as? String ?? "Empty Description"
        avatar = snapshotValue[s.avatar] as? String ?? "no url"
        eventId = snapshotValue[s.eventId] as? Int ?? -1
        key = snapshot.key
        ref = snapshot.ref
    }

    // TODO: init with snapshot

    func toAnyObject() -> Any {
        return [
            "company": company,
            "description": description,
            "name": fullName
        ]
    }
}
