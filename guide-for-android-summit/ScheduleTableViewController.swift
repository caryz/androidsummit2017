//
//  ScheduleTableViewController.swift
//  guide-for-android-summit
//
//  Created by Cary Zhou on 7/24/17.
//  Copyright © 2017 caryz. All rights reserved.
//

import UIKit
import Firebase

class ScheduleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Instance Variables
    let cellReuseIdentifier = "customEventCell"
    var events = [Event]()
    let ref = Database.database().reference(withPath: "schedule")
    var sectionCount: Int = 0
    var eventCount: Int = 0
    var eventToPass: Event?

    // TODO: make search controller and add SegmentControl

    var timeTable = [[Event]]()// each row is [section row row row]
    var didFinishFetching: Bool = false {
        didSet {
            if didFinishFetching == true {
                // ??
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        fetchSchedule()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func configureTableView() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        loadingSpinner.startAnimating()
    }

    func fetchSchedule() {
        ref.queryOrdered(byChild: "start").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let event = Event(snapshot: item as! DataSnapshot)
                self.events.append(event)
            }
            for e in self.events {
                print(e.startTime)
            }

            sleep(1)
            self.populateTimeTable()
            self.loadingSpinner.stopAnimating()
            UIApplication.shared.statusBarView?.backgroundColor = .white
            self.tableView.reloadData()
        })
    }

    func populateTimeTable() {
        var lastTime: TimeInterval = 0

        for event in events {
            if event.startTime != lastTime {
                // add section
                timeTable.append([event])
            } else {
                // add row
                timeTable[timeTable.count-1].append(event)
            }
            lastTime = event.startTime
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return timeTable.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTable[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! EventCell

        let event = timeTable[indexPath.section][indexPath.row]
        let timeText = "\(event.getStartTime()) - \(event.getEndTime())"
        cell.configure(title: event.title, time: timeText, speaker: event.speaker)

        let colors = TrackColors()
        cell.blockView.backgroundColor = UIColor.white
        switch event.track {
        case .Design:
            buildTopBorder(colors.Design, view: cell.blockView)
        case .Development:
            buildTopBorder(colors.Development, view: cell.blockView)
        case .Testing:
            buildTopBorder(colors.Testing, view: cell.blockView)
        default:
            cell.blockView.backgroundColor = UIColor.white
        }
        return cell
    }

    func buildTopBorder(_ withColor: UIColor, view: UIView) {
        let upperBorder = CALayer()
        upperBorder.backgroundColor = withColor.cgColor
        upperBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 10)
        //upperBorder.frame = CGRect(x: 0, y: 0, width: 15, height: view.frame.height)
        view.layer.addSublayer(upperBorder)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return convertToAMPM(timeTable[section][0].startTime)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueId.eventDetails.rawValue) {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as? EventDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                viewController?.event = timeTable[indexPath.section][indexPath.row]
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
