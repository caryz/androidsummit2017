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
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    
    // MARK: - Instance Variables
    let cellReuseIdentifier = "customEventCell"
    var events = [Event]()
    let ref = Database.database().reference(withPath: "schedule")
    var sectionCount: Int = 0
    var eventCount: Int = 0
    var eventToPass: Event?
    var dayIndex: Int = 0

    // TODO: make search controller and add SegmentControl

    // first layer = thurs/fri; second layer = time section; third layer = time rows
    var timeTable = [[[Event]]]()
    var savedEvents = [Event]()

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
    }

    func configureTableView() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        loadingSpinner.startAnimating()

        timeTable.append([[Event]]())
        timeTable.append([[Event]]())
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
            if event.getStartTimeComp().month == 8 && event.getStartTimeComp().day == 24 {
                if event.startTime != lastTime {
                    timeTable[0].append([event])
                } else {
                    timeTable[0][timeTable[0].count-1].append(event)
                }
            } else {
                if event.startTime != lastTime {
                    timeTable[1].append([event])
                } else {
                    timeTable[1][timeTable[1].count-1].append(event)
                }
            }
            lastTime = event.startTime
        }
    }

    // MARK: - SegmentController

    @IBAction func didChangeIndex(_ sender: UISegmentedControl) {
        dayIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }

    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        guard let indexPath = tableView.indexPathForView(view: sender) else { return }
        print("tapped \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        let event = timeTable[dayIndex][indexPath.section][indexPath.row]

        // save event
        savedEvents.append(event)

//        let image = UIImage(named: "bookmark-plus-dark")
//        bookMarkButton.setBackgroundImage(image, for: .normal)
//        bookMarkButton.setBackgroundImage(UIImage(named: "bookmark-check-dark"), for: .normal)

        // hook up firebase stuff

    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("tapped \(indexPath)")
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        if timeTable.isEmpty {
            return 1
        }
        return timeTable[dayIndex].count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if timeTable.isEmpty {
            return 1
        }
        return timeTable[dayIndex][section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if timeTable.isEmpty { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! EventCell
        let colors = TrackColors()

        let event = timeTable[dayIndex][indexPath.section][indexPath.row]
        let timeText = "\(event.getStartTime())-\(event.getEndTime())"
        cell.blockView.backgroundColor = UIColor.white
        cell.configure(title: event.title, time: timeText, speaker: event.speaker,
                       color: colors.getColor(event.track))

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if timeTable.isEmpty {
            return ""
        }
        return convertToAMPM(timeTable[dayIndex][section][0].startTime)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueId.eventDetails.rawValue) {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as? EventDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                viewController?.event = timeTable[dayIndex][indexPath.section][indexPath.row]
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

extension UITableView {
    func indexPathForView (view : UIView) -> IndexPath? {
        let location = view.convert(CGPoint.zero, to: self)
        return indexPathForRow(at: location)
    }
}
