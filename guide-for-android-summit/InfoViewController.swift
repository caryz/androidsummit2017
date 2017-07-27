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


    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentBox()
    }

    func configureContentBox() {
        let androidSummitBox = BoxyView.instanceFromNib()
        androidSummitBox.configure("Android Summit", content: "A multi-track event focused on designing, developing, and testing for Android.\n\nAugust 24th & 25th, 2017", color: .red)
        contentStack.addArrangedSubview(androidSummitBox)

        let sheratonHotel = BoxyView.instanceFromNib()
        sheratonHotel.configure("Sheraton Tysons Hotel", content: "8661 Leesburg Pike\nTysons, VA, 22182", color: .gray, imageName: "sheraton")
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

        for i in 0...3 {
            let box = BoxyView.instanceFromNib()
            box.configure("Title \(i)", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", color: .cyan)
            contentStack.addArrangedSubview(box)
        }
    }
}
