//
//  LoginViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/23/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func loginButton(_ sender: UIButton) {
        performSegue(withIdentifier: SegueId.tabBarSegue.rawValue, sender: nil)
    }
    
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
