//
//  LoginViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/23/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var GoogleLoginButton: UIButton!
    @IBOutlet weak var GuestLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }

    fileprivate func configureButtons() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        GoogleLoginButton.setBorders(1)
        GoogleLoginButton.roundEdges(with: 3)

        GuestLoginButton.setBorders(1)
        GuestLoginButton.roundEdges(with: 3)
    }

    @IBAction func loginButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func guestButtonTapped(_ sender: UIButton) {
        Auth.auth().signInAnonymously() { (user, error) in
            if let e = error {
                self.handleLoginError(e)
                return
            }

            if let usr = user {
                print("User [\(usr.uid)] has logged in")
                SessionManager.sharedInstance.uid = usr.uid
                self.performSegue(withIdentifier: SegueId.tabBarSegue.rawValue, sender: nil)
            }
        }
    }

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let e = error {
            handleLoginError(e)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        print("Signed In: \(credential.provider) | \(user.userID)")

        Auth.auth().signIn(with: credential) { (user, error) in
            if let e = error {
                self.handleLoginError(e)
                return
            }
            print("Signed into Firebase")
            self.performSegue(withIdentifier: SegueId.tabBarSegue.rawValue, sender: nil)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("Signed Out: [\(user.userID )]")
    }

    fileprivate func handleLoginError(_ err: Error) {
        self.present(showAlert("Sign in Error", message: "Please check your connectivity and try again"),
                     animated: true, completion: nil)
        print("Login Error: [\(err.localizedDescription)]")
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
