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
    
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!

    //let usersRef = Database.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    fileprivate func configureUI() {
        loginSpinner.stopAnimating()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        GoogleLoginButton.setBorders(1)
        GoogleLoginButton.roundEdges(with: 3)

        GuestLoginButton.setBorders(1)
        GuestLoginButton.roundEdges(with: 3)
    }

    @IBAction func loginButton(_ sender: UIButton) {
        loginSpinner.startAnimating()
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func guestButtonTapped(_ sender: UIButton) {
        loginSpinner.startAnimating()
        Auth.auth().signInAnonymously() { (user, error) in
            self.loginSpinner.stopAnimating()
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
        if let _ = error {
            self.loginSpinner.stopAnimating()
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        print("Signed In: \(credential.provider) | \(user.userID)")

        Auth.auth().signIn(with: credential) { (user, error) in
            self.loginSpinner.stopAnimating()
            if let e = error {
                self.handleLoginError(e)
                return
            }
            if let user = user {
                print("Signed into Firebase")
                SessionManager.sharedInstance.uid = user.uid
                SessionManager.sharedInstance.userDisplayName = user.displayName ?? "Nameless"
                SessionManager.sharedInstance.userEmail = user.email ?? "No Email :("
                SessionManager.sharedInstance.userPhotoUrl = user.photoURL

                //self.checkUserServersideData(user.uid)

                self.performSegue(withIdentifier: SegueId.tabBarSegue.rawValue, sender: nil)
            }
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

//    fileprivate func checkUserServersideData(_ uid: String) {
//        usersRef.observe(.value, with: { snapshot in
//            //var newItems: [GroceryItem] = []
//            var users: [String] = []
//            for user in snapshot.children {
////                users.append(user)
////                if uid == user {
////                    // current user's saved bookmarks should be populated
////                    //SessionManager.sharedInstance.bookmarkedEvents
////                }
//            }
//
//            if !users.contains(uid) {
//                // add user if it does not exist currently
//            }
//
//            print(users)
//        })
//    }
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
