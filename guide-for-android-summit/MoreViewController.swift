//
//  MoreViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 8/11/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MoreViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var contentStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInfo()
        configureCreditsView()
    }

    func configureUserInfo() {
        let box = BoxyView.instanceFromNib()
        box.configure("Profile", content: nil, color: SummitColors.red)

        // user info tile
        let userView = SpeakerViewMini.instanceFromNib()
        let displayName = SessionManager.sharedInstance.userDisplayName
        let photo = SessionManager.sharedInstance.userPhotoUrl
        let email = SessionManager.sharedInstance.userEmail
        userView.configure(name: displayName, company: email)
        if let pic = photo {
            userView.speakerImage?.imageFromServerURL(urlString: pic.absoluteString)
        } else {
            userView.speakerImage.imageNamed("user_placeholder")
        }
        box.addCustomViewToStack(userView)

        // add logout button
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(self.userSignOut))

        let logoutButton = buildTileButton(title: "Sign Out", gesture: gestureRecognizer)

        box.addCustomViewToStack(logoutButton)
        contentStack.addArrangedSubview(box)
    }

    func configureCreditsView() {
        let box = BoxyView.instanceFromNib()
        box.configure("Credits", content: nil, color: SummitColors.red)

        let cary = SpeakerViewMini.instanceFromNib()
        cary.configure(name: "Cary Zhou", company: "Developer")
        cary.speakerImage.imageNamed("cary")
        box.addCustomViewToStack(cary)

        let youjin = SpeakerViewMini.instanceFromNib()
        youjin.configure(name: "Youjin Nam", company: "Designer")
        youjin.speakerImage.imageNamed("youjin")
        box.addCustomViewToStack(youjin)

        contentStack.addArrangedSubview(box)
    }

    func userSignOut() {
        GIDSignIn.sharedInstance().signOut()

        let firebaseAuth = Auth.auth()
        do {
            print("Logging out user \(String(describing: Auth.auth().currentUser?.uid))")
            try firebaseAuth.signOut()

            if Auth.auth().currentUser == nil {
                print("User logged out")
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let loginVC: LoginViewController = storyboard.instantiateViewController(
                    withIdentifier: StoryboardId.Login) as! LoginViewController

                UIApplication.shared.statusBarView?.backgroundColor = .clear
                self.present(loginVC, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            self.present(showAlert("Logout Error", message: signOutError.localizedDescription),
                         animated: true, completion: nil)
        }
    }
}
