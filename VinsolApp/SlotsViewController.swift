//
//  SlotsViewController.swift
//  VinsolApp
//
//  Created by Sunita Moond on 14/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import UIKit

class SlotsViewController: UIViewController {
    @IBOutlet weak var btnTop: NSLayoutConstraint!
    @IBOutlet weak var btnHieght: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
             tableView.register(UINib(nibName: String(describing: SlotTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SlotTableViewCell.self))
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
        }
    }

    var freeSlots:[Bool] = []
    var slots = [[String]]()
    var currentDate: Date? = nil;
    var indexs:[Int] = [];
    var startingDay = 1
    var endingDay = 5
    var  interval = 2


    convenience init(freeSlots: [Bool], indexs:[Int], currentdate: Date?, slots:[[String]], startingDay: Int, endingDay: Int, interval: Int) {
        self.init()

        self.startingDay = startingDay
        self.endingDay = endingDay;
        self.interval = interval;
        self.indexs = indexs;
        self.freeSlots = freeSlots
        self.slots = slots
        self.currentDate = currentdate;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        configBtn()
        configureNavigationBar()
    }

    @IBOutlet weak var submitBtn: UIButton!{
        didSet{
            submitBtn.setTitle(("check for next day").uppercased(), for: .normal)
            submitBtn.backgroundColor = UIColor.init(rgb: 0x00A799)
            submitBtn.setTitleColor(.white, for: .normal)
            submitBtn.layer.cornerRadius = 8
        }
    }
    func configBtn() {
        submitBtn.isHidden = indexs.count >= 3
        btnHieght.constant = (indexs.count >= 3) ? 0 : 50
        btnTop.constant = (indexs.count >= 3) ? 0 : 16
    }
    func configureNavigationBar() {
        title = currentDate?.getFullDate(true, false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x00A799)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        let leftButton = UIButton(type: .system)
        leftButton.semanticContentAttribute = .forceLeftToRight
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        leftButton.setTitle("BACK", for: .normal)
        leftButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
        leftButton.sizeToFit()
        leftButton.addTarget(self, action: #selector(leftButtonAction(sender:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }

    func isOccupied(sch: Schedule, s: String, e: String) -> Bool {
        if((sch.startTime.isGreater(str: s) && sch.startTime.isGreater(str: e)) || (s.isGreater(str: sch.endTime) && e.isGreater(str: sch.endTime))) {
            return false
        }

        return true;

    }

    func refreshFreeslot(schedules:[Schedule]) {
        indexs = []
        for i in 0...slots.count-1{
            freeSlots[i] = true;
            for j in 0...schedules.count-1 {
                if(isOccupied(sch: Schedule.init(startTime: slots[i][0], endTime: slots[i][1], description: "ded", participants: "dwd"), s: schedules[j].startTime, e: schedules[j].endTime)) {
                    freeSlots[i] = false;
                }
            }
            if(freeSlots[i]) {
                indexs.append(i);
            }
        }

        tableView.reloadData();
        configBtn()

    }

    @IBAction func submitBtnAction(_ sender: Any) {
        guard let date = currentDate else {
            return
        }
        var nextDay = date.tomorrow;
        if(!(nextDay?.isValidDay(startingDay: startingDay, endingDay: endingDay, interval: interval) ?? true)) {
            nextDay = nextDay?.getNextDate(startingDay: startingDay, endingDay: endingDay, interval: interval)

        }
        guard let nextdate = nextDay else {
            return
        }
        getSchedules(nextdate.getFullDate(), nextDay);
    }
    func getSchedules(_ date: String, _ currentDate: Date? = Date()) {
        ScheduleManager.getSchedules(with: date) { [weak self] (schedules) -> Void? in

            guard let schedules = schedules else {
                self?.presentAlert(alertTitle: "Some error occured", alertMessage:  "")

                return nil}
            UserDefaults.standard.set(currentDate?.timeIntervalSince1970, forKey: "date")

            self?.currentDate = currentDate

            guard schedules.count > 0 else {
                self?.presentAlert(alertTitle: "No data Available", alertMessage:  "")

                return nil
            }
            self?.refreshFreeslot(schedules: schedules)

            return nil
        }
    }

    @objc func leftButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

}

extension SlotsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(indexs.count)
        return indexs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SlotTableViewCell.self), for: indexPath) as! SlotTableViewCell
        cell.configure(schedule: Schedule.init(startTime: slots[indexs[indexPath.row]][0], endTime: slots[indexs[indexPath.row]][1], description: "ded", participants: "dwd"));

            return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var schedule = Schedule.init(startTime: slots[indexs[indexPath.row]][0], endTime: slots[indexs[indexPath.row]][1], description: "ded", participants: "dwd");
        let exitAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in

        })
        presentAlert(alertTitle: schedule.startTime.getTime() + " - " + schedule.endTime.getTime(), alertMessage: "confirm for this slot", actionTitle: "OK", actionHandler: { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }, dismiss: false, persistenceTime: 1200, exitAction: exitAction)
    }
}
