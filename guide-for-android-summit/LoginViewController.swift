//
//  LoginViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/23/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let tabBarSegueIdentifier = "TabBarSegue"

    @IBAction func loginButton(_ sender: UIButton) {
        performSegue(withIdentifier: tabBarSegueIdentifier, sender: nil)
    }
}
