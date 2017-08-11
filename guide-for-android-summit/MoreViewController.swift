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

    @IBAction func logOutButtonTapped(_ sender: UIButton) {
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
