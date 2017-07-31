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
    let description: [String]
    let startTime: TimeInterval
    let endTime: TimeInterval
    let track: EventTrack
    let speaker: String // some sort of ID here, guid or int?

    // firebase properties
    let key: String
    let ref: DatabaseReference?

    init(title: String, description: [String], startTime: TimeInterval, endTime: TimeInterval,
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
        let e = EventFields()
        title = snapshotValue[e.title] as? String ?? "Empty Title"
        description = snapshotValue[e.description] as? [String] ?? ["Empty Description"]
        startTime = snapshotValue[e.startTime] as? TimeInterval ?? 0
        endTime = snapshotValue[e.endTime] as? TimeInterval ?? 0
        track = EventTrack(rawValue: snapshotValue[e.track] as? Int ?? -1)!
        speaker = snapshotValue[e.speaker] as? String ?? "Empty Speaker"
        key = snapshot.key
        ref = snapshot.ref
    }

    // MARK: Utility functions
    func getStartTime() -> String {
        return convertToAMPM(startTime)
    }

    func getEndTime() -> String {
        return convertToAMPM(endTime)
    }

    func getStartTimeComp() -> DateComponents {
        return Calendar.current.dateComponents([.month, .day, .hour, .minute],
                                               from: convertIntervalToDate(self.startTime))
    }

    func getEndTimeComp() -> DateComponents {
        return Calendar.current.dateComponents([.month, .day, .hour, .minute],
                                               from: convertIntervalToDate(self.endTime))
    }
}
