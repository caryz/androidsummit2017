//
//  LoginViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/23/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var GoogleLoginButton: UIButton!
    @IBOutlet weak var GuestLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }

    fileprivate func configureButtons() {
        GoogleLoginButton.setBorders(1)
        GoogleLoginButton.roundEdges(with: 3)

        GuestLoginButton.setBorders(1)
        GuestLoginButton.roundEdges(with: 3)
    }

    @IBAction func loginButton(_ sender: UIButton) {
        performSegue(withIdentifier: SegueId.tabBarSegue.rawValue, sender: nil)
    }
    
    @IBAction func guestButtonTapped(_ sender: UIButton) {
        Auth.auth().signInAnonymously() { (user, error) in
            if let usr = user {
                print("User [\(usr.uid)] has logged in")
                SessionManager.sharedInstance.uid = usr.uid
                self.performSegue(withIdentifier: SegueId.tabBarSegue.rawValue, sender: nil)
            }
            if let err = error {
                print("Error: \(error)")
            }
        }
    }
}

@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableSpace = UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
    }
}

extension UIButton {
    func setBorders(_ pointValue: CGFloat, with color: UIColor = .white) {
        self.layer.borderWidth = pointValue
        self.layer.borderColor = color.cgColor
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
