//
//  Event.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/23/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import Foundation
import Firebase

enum EventTrack: Int {
    case Unknown = -1
    case Development
    case Design
    case Testing
}

struct Event {
    /* API Fields
     description: "Still too many applications do not meet the hig..."
     end:         1500323100000
     start:       1500324000000
     title:       "Android Application Security, The Right Way"
     type:        0
     */

    // MARK: Instance Variables & Init
    let title: String
    let description: String
    let startTime: Int
    let endTime: Int
    let track: EventTrack
    let speaker: String // some sort of ID here, guid or int?

    // firebase properties
    let key: String
    let ref: DatabaseReference?

    init(title: String, description: String, startTime: Int, endTime: Int,
         track: EventTrack, speaker: String, key: String) {
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.track = track
        self.speaker = speaker
        self.key = key
        self.ref = nil
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as? String ?? "Empty Title"
        description = snapshotValue["description"] as? String ?? "Empty Description"
        startTime = snapshotValue["start"] as? Int ?? 0
        endTime = snapshotValue["end"] as? Int ?? 0
        track = EventTrack(rawValue: snapshotValue["type"] as? Int ?? -1)!
        speaker = snapshotValue["speaker"] as? String ?? "Empty Speaker"
        key = snapshot.key
        ref = snapshot.ref
    }

    // MARK: Utility functions
    func getStartTimeInDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.startTime / 1000))
    }

    func getEndTimeInDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.endTime / 1000))
    }
}
