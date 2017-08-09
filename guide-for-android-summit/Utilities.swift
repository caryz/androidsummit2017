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
    case speakerDetails = "showSpeakerDetails"
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
    let track = "track"
    let speaker = "speaker"
    let location = "location"
}

struct PersonFields {
    let fullName = "name"
    let company = "company"
    let description = "description"
    let avatar = "avatar"
    let eventId = "eventId"
}

struct TrackColors {
    let Development = UIColor(red: 108/255, green: 68/255, blue: 184/255, alpha: 1.0) // #6C44B8
    let Design = UIColor(red: 231/255, green: 98/255, blue: 48/255, alpha: 1.0) // #E76230
    let Testing = UIColor(red: 62/255, green: 141/255, blue: 214/255, alpha: 1.0) // #3E8DD6
    let defaultColor = UIColor.lightGray

    func getColor(_ track: EventTrack) -> UIColor {
        switch track {
        case .Design:
            return Design
        case .Development:
            return Development
        case .Testing:
            return Testing
        default:
            return defaultColor
        }
    }
}

func paragraphFrom(description: [String]) -> String {
    return description.joined(separator: "\n\n")
}

func convertIntervalToDate(_ interval: TimeInterval) -> Date {
    return Date(timeIntervalSince1970: TimeInterval( interval / 1000))
}

func convertToAMPM(_ interval: TimeInterval) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mma"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    return formatter.string(from: convertIntervalToDate(interval))
}

extension UIView {
    func addShadows() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 1

        //self.titleBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        //self.titleBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        //self.titleBackgroundView.layer.shadowOpacity = 1
    }
}

