//
//  Utilities.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/25/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import Foundation
import UIKit

enum SegueId: String {
    case eventDetails = "showEventDetails"
    case tabBarSegue = "TabBarSegue"
}

enum EventFieldsEnum: String {
    case title = "title"
    case description = "description"
    case startTime = "start"
    case endTime = "end"
    case track = "type"
    case speaker = "speaker"
}

struct EventFields {
    let title = "title"
    let description = "description"
    let startTime = "start"
    let endTime = "end"
    let track = "type"
    let speaker = "speaker"
    let location = "location"
}

struct TrackColors {
    let Development = UIColor(red: 1, green: 0.698, blue: 0.698, alpha: 1.0)
    let Design = UIColor(red: 0.698, green: 0.8431, blue: 1, alpha: 1.0)
    let Testing = UIColor(red: 0.698, green: 1, blue: 0.7569, alpha: 1.0)
}

func convertIntervalToDate(_ interval: TimeInterval) -> Date {
    return Date(timeIntervalSince1970: TimeInterval( interval / 1000))
}

func convertToAMPM(_ interval: TimeInterval) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    return formatter.string(from: convertIntervalToDate(interval))
}
