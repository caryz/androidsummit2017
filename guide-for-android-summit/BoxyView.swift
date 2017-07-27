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
        return UINib(nibName: "BoxyView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! BoxyView
    }

    func configure(_ title: String? = nil, content: String? = nil, color: UIColor? = nil, imageName: String? = nil) {
        if let title = title {
            self.titleLabel.text = title
        } else {
            self.titleLabel.isHidden = true
        }

        if let content = content {
            self.contentLabel.text = content
        } else {
            self.contentLabel.isHidden = true
        }

        if let bgColor = color {
            self.titleBackgroundView.backgroundColor = bgColor
        } else {
            self.titleBackgroundView.isHidden = true
        }

        if let imgName = imageName {
            self.image.image = UIImage(named: imgName)
        } else {
            self.image.isHidden = true
        }
    }

    func addCustomViewToStack(_ customView: UIView) {
        contentStack.addArrangedSubview(customView)
    }
    
    fileprivate func addShadows() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 1

        self.titleBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.titleBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.titleBackgroundView.layer.shadowOpacity = 1
    }
}
