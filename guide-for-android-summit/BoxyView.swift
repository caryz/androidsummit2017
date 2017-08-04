//
//  BoxyView.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/26/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import Foundation
import UIKit

class BoxyView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var contentStack: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadows()
    }

    class func instanceFromNib() -> BoxyView {
        return UINib(nibName: "BoxyView", bundle: nil).instantiate(withOwner: self, options: nil).first as! BoxyView
    }

    func configure(_ title: String? = nil, content: String? = nil, color: UIColor? = nil,
                   imageName: String? = nil, contentMode: UIViewContentMode = .scaleAspectFit) {
        if let title = title {
            self.titleLabel.text = title
        } else {
            self.titleLabel.removeFromSuperview()
        }

        if let content = content {
            self.contentLabel.text = content
        } else {
            self.contentLabel.removeFromSuperview()
        }

        if let bgColor = color {
            self.titleBackgroundView.backgroundColor = bgColor
        } else {
            self.titleBackgroundView.removeFromSuperview()
        }

        if let imgName = imageName {
            self.image.image = UIImage(named: imgName)
            self.image.contentMode = contentMode
        } else {
            self.image.removeFromSuperview()
        }
    }

    func addCustomViewToStack(_ customView: UIView) {
        contentStack.addArrangedSubview(customView)
    }
}
