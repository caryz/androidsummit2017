//
//  InfoViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/23/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView! // idk if i'm even using this lul
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var easterEggBarItem: UIBarButtonItem!
    var didTriggerEasterEgg = false
    var easterEggView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentBox()
    }

    func configureContentBox() {
        let androidSummitBox = BoxyView.instanceFromNib()
        //androidSummitBox.configure("Android Summit", content: "A multi-track event focused on designing, developing, and testing for Android.\n\nAugust 24th & 25th, 2017", color: .red)
        androidSummitBox.configure("Android Summit", content: "A multi-track event focused on designing, developing, and testing for Android.\n\nAugust 24th & 25th, 2017", color: nil, imageName: "about_logo", contentMode: .scaleAspectFill)
        contentStack.addArrangedSubview(androidSummitBox)

        let sheratonHotel = BoxyView.instanceFromNib()
        sheratonHotel.configure("Sheraton Tysons Hotel", content: "8661 Leesburg Pike\nTysons, VA, 22182", color: nil, imageName: "sheraton", contentMode: .scaleAspectFill)
        contentStack.addArrangedSubview(sheratonHotel)

        let sponsorBox = BoxyView.instanceFromNib()
        sponsorBox.configure("Sponsor", content: "", color: .orange, imageName: "cof_logo")
        contentStack.addArrangedSubview(sponsorBox)

        let partnerBox = BoxyView.instanceFromNib()
        partnerBox.configure("Partner", content: "", color: .purple, imageName: "modev_logo")
        contentStack.addArrangedSubview(partnerBox)

        let benefitingBox = BoxyView.instanceFromNib()
        benefitingBox.configure("Benefiting", content: "", color: .blue, imageName: "wwc_logo")
        contentStack.addArrangedSubview(benefitingBox)
    }
    @IBAction func didTapEasterEgg(_ sender: UIBarButtonItem) {
        if didTriggerEasterEgg {
            easterEggView.removeFromSuperview()
            didTriggerEasterEgg = false
        } else {
            easterEggView = UIView(frame: CGRect(x: 50, y: 64, width: 200, height: 50))
            easterEggView.backgroundColor = UIColor.lightGray
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            label.adjustsFontSizeToFitWidth = true
            label.text = "Stahp. Fk u. Juliana sucks."
            easterEggView.addSubview(label)
            view.addSubview(easterEggView)
            didTriggerEasterEgg = true
        }
    }
}
