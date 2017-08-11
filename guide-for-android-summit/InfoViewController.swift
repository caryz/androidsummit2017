//
//  InfoViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/23/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit
import MapKit

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
        androidSummitBox.configure("Android Summit", content: "A multi-track event focused on designing, developing, and testing for Android.\n\nAugust 24th & 25th, 2017", color: nil, imageName: "about_logo", contentMode: .scaleAspectFill)
        contentStack.addArrangedSubview(androidSummitBox)

        let sheratonHotel = BoxyView.instanceFromNib()
        sheratonHotel.configure("Sheraton Tysons Hotel", content: "\n8661 Leesburg Pike\nTysons, VA, 22182", color: nil, imageName: "sheraton", contentMode: .scaleAspectFill)
        sheratonHotel.addCustomViewToStack(navigationButton())
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

    func handleNavigationTap() {
        let latitude: Double = 38.9309749
        let longitude: Double = -77.246181

        let googleMapsUrl = URL(string: "comgooglemaps://")
        let alert = UIAlertController(title: "Navigate with", message: nil, preferredStyle: .actionSheet)

        // apple maps is always installed
        let appleMapsButton = UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "Sheraton Tysons Hotel"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])

        })
        alert.addAction(appleMapsButton)

        // if google maps is installed, give user the option to use it
        if UIApplication.shared.canOpenURL(googleMapsUrl!) {

            let googleMapsButton = UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
                let address = "Sheraton+Tysons+Hotel,+8661+Leesburg+Pike,+Tysons,+VA+22182"
                let url = URL(string:
                    "comgooglemaps://?saddr=&daddr=\(address)&center=\(latitude),\(longitude)&directionsmode=driving")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            })
            alert.addAction(googleMapsButton)
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func navigationButton() -> UIButton {
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                             action: #selector(self.handleNavigationTap))

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        button.setTitle("Get Directions", for: .normal)
        button.setTitleColor(SummitColors.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        button.addGestureRecognizer(gestureRecognizer)

        return button
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
