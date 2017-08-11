//
//  SpeakerDetailViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/27/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import Foundation
import UIKit

class SpeakerDetailViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: Instance Variables
    var speaker: Person?
    var speakerImage: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.tintColor = SummitColors.red
        configure()
    }

    func configure() {
        guard let speaker = self.speaker else { return }
        nameLabel.text = speaker.fullName
        addBoxyView(title: speaker.fullName, content:
            paragraphFrom(description: speaker.description), color: .red)
        if let img = speakerImage {
            self.imageView.image = img.image
        }
    }

    func addBoxyView(title: String?, content: String? = nil, color: UIColor? = nil) {
        let box = BoxyView.instanceFromNib()
        box.configure(title, content: content, color: color)
        contentStack.addArrangedSubview(box)
    }
}
