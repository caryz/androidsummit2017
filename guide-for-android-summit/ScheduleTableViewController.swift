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
    var refreshControl: UIRefreshControl!
    
    // MARK: - Instance Variables
    let cellReuseIdentifier = "customEventCell"
    let ref = Database.database().reference(withPath: "schedule")
    let speakerRef = Database.database().reference(withPath: "speakers")

    // first layer = thurs/fri; second layer = time section; third layer = time rows
    var events = [Event]()
    var timeTable = [[[Event]]]() // tableDatasource
    var savedEvents = [Event]()
    var allEvents = [[[Event]]]() // mirrors tableDataSource but won't change

    var dayIndex: Int = 0 // for segmentControl
    var didFinishFetching: Bool = false
    var bookmarkButtonChecked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchData()
    }

    func configureTableView() {
        loadingSpinner.startAnimating()

        // self sizing cells
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        // populate initial data
        timeTable.append([[Event]]())
        timeTable.append([[Event]]())
        allEvents.append([[Event]]())
        allEvents.append([[Event]]())

        // refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }

    func fetchData() {
        ref.queryOrdered(byChild: "start").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let event = Event(snapshot: item as! DataSnapshot)
                self.events.append(event)
            }
            SessionManager.sharedInstance.fetchedEvents = self.events

            self.fetchSpeakers()
        })
    }

    func fetchSpeakers() {
        var speakers = [Person]()
        speakerRef.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let speaker = Person(snapshot: item as! DataSnapshot)
                speakers.append(speaker)
                if let index = self.events.index(where: { $0.key == speaker.eventId }) {
                    self.events[index].speakers.append(speaker.fullName)
                    self.events[index].speakerList.append(speaker)
                    print("Event key[\(self.events[index].key)] associated with Speaker[\(speaker.eventId)]")
                }
            }
            SessionManager.sharedInstance.fetchedSpeakers = speakers

            self.populateTimeTable()
            self.didFinishFetching = true
            self.loadingSpinner.stopAnimating()
            UIApplication.shared.statusBarView?.backgroundColor = .white
            self.tableView.reloadData()
        })
    }

    func populateTimeTable() {
        var lastTime: TimeInterval = 0

        for event in events {
            if event.getStartTimeComp().month == 8 && event.getStartTimeComp().day == 24 {
                // TODO: sort same time by eventId for consistency
                if event.startTime != lastTime {
                    timeTable[0].append([event])
                    allEvents[0].append([event])
                    print("---")
                } else {
                    timeTable[0][timeTable[0].count-1].append(event)
                    allEvents[0][allEvents[0].count-1].append(event)
                }
            } else {
                if event.startTime != lastTime {
                    timeTable[1].append([event])
                    allEvents[1].append([event])
                } else {
                    timeTable[1][timeTable[1].count-1].append(event)
                    allEvents[1][allEvents[1].count-1].append(event)
                }
            }
            print(event.key)
            lastTime = event.startTime
        }
    }

    // MARK: - SegmentController

    @IBAction func didChangeIndex(_ sender: UISegmentedControl) {
        dayIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }

    @IBAction func bookmarkButtonTapped(_ sender: ToggleButton) {
        guard let indexPath = tableView.indexPathForView(view: sender) else { return }
        // TODO: hook up firebase stuff
        let event = timeTable[dayIndex][indexPath.section][indexPath.row]
        var saved = false

        if let index = savedEvents.index(where: { $0 == event }) {
            // remove event
            saved = false
            savedEvents.remove(at: index)
            print("Unsaved: [\(event.title)] at [\(indexPath)")
        } else {
            // save event
            saved = true
            savedEvents.append(event)
            print("Saved: [\(event.title)] at [\(indexPath)")
        }
        timeTable[dayIndex][indexPath.section][indexPath.row].saved = saved
        allEvents[dayIndex][indexPath.section][indexPath.row].saved = saved
        sender.isChecked = saved
    }

    @IBAction func bookMarkToggleTapped(_ sender: UIBarButtonItem) {
        if bookmarkButtonChecked == false {
            var toDelete = [IndexPath]()

            for s in (0..<timeTable[dayIndex].count).reversed() {
                for r in (0..<timeTable[dayIndex][s].count).reversed() {
                    let indexPath = IndexPath(row: r, section: s)
                    let event = timeTable[dayIndex][s][r]
                    if !savedEvents.contains(where: { $0 == event }) {
                        toDelete.append(indexPath)
                        timeTable[dayIndex][s].remove(at: r)
                        print("Deleting: [\(event.title)] at [\(s), \(r)]")
                    }
                }
            }

            deleteAppropriateCells(toDelete, animation: .fade)
            bookmarkButtonChecked = true
            toggleBookmark(true)
        } else {
            // add all rows
            var toInsert = [IndexPath]()
            for sec in (0..<allEvents[dayIndex].count) {
                for row in (0..<allEvents[dayIndex][sec].count) {
                    let indexPath = IndexPath(row: row, section: sec)
                    let event = allEvents[dayIndex][sec][row]
                    if !timeTable[dayIndex][sec].contains(where: { $0 == event }) {
                        toInsert.append(indexPath)
                        timeTable[dayIndex][sec].append(event)
                        print("Inserting: [\(event.title)] at [\(sec), \(row)]")
                    }
                }
                timeTable[dayIndex][sec] = allEvents[dayIndex][sec]
            }

            tableView.insertRows(at: toInsert, with: .fade)
            bookmarkButtonChecked = false
            toggleBookmark(false)
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        guard didFinishFetching else { return 0 }
        if tableEventCount() == 0 {
            tableView.backgroundView  = noDataView()
        } else {
            tableView.backgroundView = nil
        }
        return timeTable[dayIndex].count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTable[dayIndex][section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! EventCell
        let colors = TrackColors()

        let event = timeTable[dayIndex][indexPath.section][indexPath.row]
        let timeText = "\(event.getStartTime())-\(event.getEndTime())"
        cell.blockView.backgroundColor = UIColor.white
        cell.configure(title: event.title, time: timeText, speakers: event.speakers,
                       color: colors.getColor(event.track), checked: event.saved)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // section gets no header if rows were removed
        guard !timeTable[dayIndex][section].isEmpty else { return nil }
        return convertToAMPM(timeTable[dayIndex][section][0].startTime)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let dankView = UIView()
    //        dankView.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 0.2)
    //        let dankLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 150, height: 15))
    //        dankLabel.text = convertToAMPM(timeTable[dayIndex][section][0].startTime)
    //        dankLabel.textColor = UIColor.darkGray
    //        dankView.addSubview(dankLabel)
    //        return dankView
    //    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueId.eventDetails.rawValue) {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as? EventDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                viewController?.event = timeTable[dayIndex][indexPath.section][indexPath.row]
                // add speaker stuff here
            }
        }
    }

    fileprivate func deleteAppropriateCells(_ toDelete: [IndexPath],
                                            animation: UITableViewRowAnimation = .automatic) {
        /* Rationale and Explanation
         * You're probably looking at this goign wtf
         * But this is for the smoothest animation possible during the edge case
         * in which user deletes all rows and leaves a random section header
         * sitting around. Maybe that's an Apple bug, but hey it is what it is.
         */
        CATransaction.begin()
        tableView.beginUpdates()
        CATransaction.setCompletionBlock {
            // if empty, an extra section header gets left in there
            if self.tableView.numberOfRows(inSection: 0) == 0 {
                self.reloadSection(0)
            }
        }
        tableView.deleteRows(at: toDelete, with: animation)
        tableView.endUpdates()
        CATransaction.commit()
    }

    fileprivate func reloadSection(_ section: Int) {
        self.tableView.reloadSections(IndexSet(section...section) as IndexSet, with: .fade)
    }

    fileprivate func toggleBookmark(_ on: Bool) {
        if on {
            bookmarkButton.image = UIImage(named: "bookmark-dark")
        } else {
            bookmarkButton.image = UIImage(named: "bookmark-outline-dark")
        }
    }

    fileprivate func tableEventCount() -> Int {
        var sum = 0
        for event in timeTable[dayIndex] {
            sum = sum + event.count
        }
        print("Sum = \(sum)")
        return sum
    }

    fileprivate func noDataView() -> UILabel {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "Bookmark some events!"
        noDataLabel.textColor     = UIColor.darkGray
        noDataLabel.textAlignment = .center
        return noDataLabel
    }

    func refresh(sender: AnyObject) {
        print("refreshing data")
        sleep(1)
        refreshControl.endRefreshing()
    }

}

extension UITableView {
    func indexPathForView (view : UIView) -> IndexPath? {
        let location = view.convert(CGPoint.zero, to: self)
        return indexPathForRow(at: location)
    }
}
