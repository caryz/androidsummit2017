//
//  SecondViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/22/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit
import Firebase

class SpeakersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    let cellReuseIdentifier = "SpeakerCell"
    let ref = Database.database().reference(withPath: "speakers")
    var speakers = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchSpeakers()
    }

    func configureTableView() {
        tableView.rowHeight = 80
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func fetchSpeakers() {
        // already fetched on schedule, retrieve from singleton
        speakers = SessionManager.sharedInstance.fetchedSpeakers
        tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speakers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SpeakerCell

        let speaker = speakers[indexPath.row]
        cell.configure(name: speaker.fullName, company: speaker.company)
        cell.speakerImage?.imageFromServerURL(urlString: speaker.avatar)
        //print(speaker.avatar)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueId.speakerDetails.rawValue) {
            let viewController = segue.destination as? SpeakerDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                viewController?.speaker = speakers[indexPath.row]
                let cell = self.tableView.cellForRow(at: indexPath) as! SpeakerCell
                if let imageView = cell.speakerImage {
                    //viewController?.imageView = imageView
                    viewController?.speakerImage = imageView
                }
            }
        }
    }
}

extension UIImageView {

    public func imageFromServerURL(urlString: String) {
        guard let avatarUrl = NSURL(string: urlString) else { return }

        URLSession.shared.dataTask(with: avatarUrl as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error.debugDescription)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
                self.setRounded()
                self.layoutSubviews()
            })

        }).resume()
    }

    public func imageNamed(_ name: String) {
        let image = UIImage(named: name)
        self.image = image
        self.setRounded()
        self.layoutSubviews()
    }
}
