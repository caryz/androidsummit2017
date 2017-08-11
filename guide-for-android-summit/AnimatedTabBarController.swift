//
//  AnimatedTabBarController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 8/8/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit

class AnimatedTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if selectedViewController == nil || viewController == selectedViewController {
            return false
        }

        let fromView = selectedViewController!.view
        let toView = viewController.view

        fromView!.superview?.addSubview(toView!) // avoid nav bar flicker
        UIView.transition(from: fromView!, to: toView!, duration: 0.5, options: [.transitionCrossDissolve], completion: nil)
        
        return true
    }
}
