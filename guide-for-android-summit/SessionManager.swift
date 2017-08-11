//
//  SessionManager.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 8/4/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import Foundation

class SessionManager {

    static let sharedInstance = SessionManager()

    // MARK: - Local Variable

    // unique user identifier
    var uid: String = ""

    // list of bookmarked items, index is eventId
    var bookmarkedEvents: [Bool] = [Bool]()

    var fetchedEvents: [Event] = [Event]()

    var fetchedSpeakers: [Person] = [Person]()

    var userDisplayName: String = "Guest"

    var userEmail: String = "No Email :("

    var userPhotoUrl: URL? = nil
}
