//
//  SpeakerCell.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/31/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import Foundation
import UIKit

class SpeakerCell: UITableViewCell {

    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var speakerCompany: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(name: String, company: String) {
        self.speakerName.text = name
        self.speakerCompany.text = company
    }
}
