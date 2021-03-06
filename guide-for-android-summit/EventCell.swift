//
//  EventCell.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/25/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var bookmark: ToggleButton!

    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var leftBarView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadowToCell()
    }

    func addShadowToCell() {
        blockView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        blockView.layer.shadowOffset = CGSize(width: 1, height: 1)
        blockView.layer.shadowOpacity = 1
    }

    func configure(title: String, time: String, speakers: [String],
                   color: UIColor? = .white, checked: Bool = false) {
        self.titleLabel?.text = title
        self.timeLabel?.text = time
        self.leftBarView?.backgroundColor = color
        self.bookmark.isChecked = checked

        // build speaker string
        self.speakerLabel?.text = speakers.joined(separator: ", ")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
