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

        tableView.rowHeight = 80
        self.automaticallyAdjustsScrollViewInsets = false
        addPeople()
    }

    func addPeople() {
        ref.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let speaker = Person(snapshot: item as! DataSnapshot)
                self.speakers.append(speaker)
                //print(speaker.key)
            }

            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speakers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        let speaker = speakers[indexPath.row]
        cell.textLabel?.text = speaker.fullName
        cell.detailTextLabel?.text = speaker.company
        cell.imageView?.image = UIImage(named: "user_placeholder")
        fetchImage(speaker.avatar, forIndexPath: indexPath)
        //fetchImage("http://c.dryicons.com/images/icon_sets/shine_icon_set/png/256x256/business_user.png", forIndexPath: indexPath)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueId.speakerDetails.rawValue) {
            let viewController = segue.destination as? SpeakerDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                viewController?.speaker = speakers[indexPath.row]
                let cell = self.tableView.cellForRow(at: indexPath)
//                if let img = cell?.imageView?.image {
//                    viewController?.imageView.image = img
//                }
            }
        }
    }

    // MARK: - Helper Methods
    func fetchImage(_ url: String, forIndexPath: IndexPath) {
        guard let pic = URL(string: url) else { return }

        let session = URLSession(configuration: .default)

        let downloadPicTask = session.dataTask(with: pic) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        let cell = self.tableView.cellForRow(at: forIndexPath)
                        cell?.imageView?.image = image
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
}
