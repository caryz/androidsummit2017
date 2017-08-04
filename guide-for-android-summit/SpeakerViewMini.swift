//
//  SpeakerViewMini.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 8/4/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit

class SpeakerViewMini: UIView {
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var speakerCompany: UILabel!

    class func instanceFromNib() -> SpeakerViewMini {
        return UINib(nibName: "SpeakerViewMini", bundle: nil).instantiate(withOwner: self, options: nil).first as! SpeakerViewMini
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //addShadows()
    }

    func configure(name: String, company: String) {
        self.speakerName.text = name
        self.speakerCompany.text = company
    }
}
