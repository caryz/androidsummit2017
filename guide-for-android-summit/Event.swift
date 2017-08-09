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
    var speakers: [String] // some sort of ID here, guid or int?
    var saved: Bool = false
    var speakerList: [Person]

    // firebase properties
    let key: Int
    let ref: DatabaseReference?

    init(title: String, description: [String], startTime: TimeInterval, endTime: TimeInterval,
         track: EventTrack, speakers: [String], key: Int, saved: Bool = false) {
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.track = track
        self.speakers = speakers
        self.saved = saved
        self.speakerList = [Person]()
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
        speakers = snapshotValue[e.speaker] as? [String] ?? [String]()
        speakerList = [Person]()
        saved = false // TODO: Firebase
        key = Int(snapshot.key) ?? -1
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

    static func ==(lhs: Event, rhs: Event) -> Bool {
        // TODO: make this into eventId comparisons later
        return lhs.title == rhs.title // && lhs.type == rhs.type
    }
}
