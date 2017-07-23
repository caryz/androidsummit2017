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
    let img: String //"http://androidsummit.org/2016/img/speakers/huye..."
    let fullName: String
    //TODO: have a ref

    init(fullName: String, company: String, description: String, img: String, eventId: Int) {
        self.fullName = fullName
        self.company = company
        self.description = description
        self.img = img
        self.eventId = eventId
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
