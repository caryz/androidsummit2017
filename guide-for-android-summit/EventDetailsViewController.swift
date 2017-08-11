//
//  EventDetailsViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/25/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentStack: UIStackView!

    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var trackLabelBackground: UIView!

    // MARK: Instance Variables
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = TrackColors().getColor(event!.track)
        configure()
    }

    func configure() {
        guard let event = self.event else { return }
        let trackColor = TrackColors().getColor(event.track)

        titleLabel.textColor = trackColor
        titleLabel.text = event.title
        timeLabel.text = "\(event.getStartTime())-\(event.getEndTime())"

        trackLabel.textColor = .white
        trackLabelBackground.roundEdges(with: 3)
        trackLabelBackground.backgroundColor = trackColor

        switch event.track {
        case .Design:
            trackLabel.text = "Design"
        case .Development:
            trackLabel.text = "Development"
        case .Testing:
            trackLabel.text = "Testing"
        default:
            trackLabel.text = "" // no track
            trackLabelBackground.backgroundColor = .clear
        }

        addBoxyView(title: nil, content:
            paragraphFrom(description: event.description), color: nil)

        if !event.speakers.isEmpty {
            addSpeakerView(title: "Speakers", color: trackColor)
        }
    }

    func addBoxyView(title: String?, content: String? = nil, color: UIColor? = nil) {
        let box = BoxyView.instanceFromNib()
        box.configure(title, content: content, color: color)
        contentStack.addArrangedSubview(box)
    }

    func addSpeakerView(title: String?, color: UIColor? = nil) {
        guard let speakers = event?.speakerList else { return }

        let box = BoxyView.instanceFromNib()
        box.configure(title, content: nil, color: color)

        for speaker in speakers {
            let speakerView = SpeakerViewMini.instanceFromNib()
            speakerView.configure(name: speaker.fullName, company: speaker.company)
            speakerView.speakerImage?.imageFromServerURL(urlString: speaker.avatar)
            box.addCustomViewToStack(speakerView)
        }

        contentStack.addArrangedSubview(box)
    }
}
