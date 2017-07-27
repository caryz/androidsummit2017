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


    // MARK: Instance Variables
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        guard let event = self.event else { return }
        let trackColor = TrackColors().getColor(event.track)

        titleLabel.textColor = trackColor
        titleLabel.text = event.title
        timeLabel.text = "\(event.getStartTime())-\(event.getEndTime())"

        //headerBackgroundView.backgroundColor = trackColor

        addBoxyView(title: "Description", content: event.description, color: trackColor)
        addBoxyView(title: "Speakers", content: nil, color: trackColor)
    }

    func addBoxyView(title: String?, content: String? = nil, color: UIColor? = nil) {
        let box = BoxyView.instanceFromNib()
        box.configure(title, content: content, color: color)
        contentStack.addArrangedSubview(box)
    }

}
