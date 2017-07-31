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

    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var leftBarView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadowToCell()
    }

    func addShadowToCell() {
        blockView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        blockView.layer.shadowOffset = CGSize(width: 2, height: 2)
        blockView.layer.shadowOpacity = 1
        //layer.shadowRadius = 0
        //layer.masksToBounds = false
    }

    func configure(title: String, time: String, speaker: String, color: UIColor? = .white) {
        self.titleLabel?.text = title
        self.timeLabel?.text = time
        self.speakerLabel?.text = speaker
        self.leftBarView?.backgroundColor = color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
