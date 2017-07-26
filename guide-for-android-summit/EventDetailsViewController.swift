//
//  EventDetailsViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/25/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!


    // MARK: Instance Variables
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = event?.title
        descriptionLabel.text = event?.description
        speakerLabel.text = event?.speaker
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
