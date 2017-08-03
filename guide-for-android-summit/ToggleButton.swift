//
//  ToggleButton.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 8/2/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit


class ToggleButton: UIButton {
    var checkedImage: UIImage?
    var offImage: UIImage?

    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(offImage, for: .normal)
            }
            isChecked = !isChecked
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // set up default images
        self.offImage = UIImage(named: "bookmark-plus-dark")
        self.checkedImage = UIImage(named: "bookmark-check-dark")
    }

    func configure(checkedImage: String, offImage: String, on checked: Bool = false) {
        self.isChecked = checked
        self.checkedImage = UIImage(named: checkedImage)
        self.offImage = UIImage(named: offImage)
    }

}
