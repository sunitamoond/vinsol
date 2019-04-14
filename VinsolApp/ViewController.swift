//
//  ViewController.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: String(describing: PortaitTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PortaitTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: LandscapeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LandscapeTableViewCell.self))

            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
        }
    }

    @IBOutlet weak var btnOuterView: UIView!
    @IBOutlet weak var addScheduleMeetingBtn: UIButton! {
        didSet{
            addScheduleMeetingBtn.setTitle(("Scehdule Company Meeting").uppercased(), for: .normal)
            addScheduleMeetingBtn.backgroundColor = UIColor.init(rgb: 0x00A799)
            addScheduleMeetingBtn.setTitleColor(.white, for: .normal)
            addScheduleMeetingBtn.layer.cornerRadius = 8
        }
    }

    var schedules:[Schedule] = []
    var currentDate: Date? = nil;
    private var refreshControl = UIRefreshControl()
    var isPortrait: Bool = true;
    var startingDay = 6 //Sunday
    var endingDay = 6
    var interval = 0;
    var slotStartTime = 9;//start hour
    var slotEndTime = 17;//end hour
    var diff = 30 //minute

    fileprivate func getOrientation() {
        if UIDevice.current.orientation.isLandscape {
            isPortrait = false
            print("Landscape")
            tableView.reloadData();
            configureTitle(currentDate?.getFullDate(true, isPortrait))
            //            imag eView.image = UIImage(named: const2)
        } else {
            isPortrait = true
            print("Portrait")
            configureTitle(currentDate?.getFullDate(true, isPortrait))
            tableView.reloadData();
            //            imageView.image = UIImage(named: const)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        getOrientation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        interval = 7 - (endingDay - startingDay + 1)
        var t = ["scd", "efdsf", "fsew"]
        let fullName    = t.joined(separator: ", ")
        let fullNameArr = fullName.components(separatedBy: ", ")
        print(fullNameArr)
        var time = UserDefaults.standard.double(forKey: "date") as? Double
        if(time != nil) {
            currentDate = Date.init(timeIntervalSince1970: time ?? Double())
        }
        print(currentDate)
        fetchData();
        configureRefreshControl()
        getOrientation()
        if(currentDate == nil) {
            currentDate = Date();
        }
        if(!(currentDate?.isValidDay(startingDay: startingDay, endingDay: endingDay, interval: interval) ?? true)) {
            currentDate = currentDate?.getNextDate(startingDay: startingDay, endingDay: endingDay, interval: interval)

        }

        getSchedules(currentDate?.getFullDate() ?? "", currentDate)
        configureNavigationBar()

    }

    @IBAction func addScheduleMeetingBtnAction(_ sender: Any) {
        let addScheduleVC = AddScheduleViewController(isPortrait: isPortrait, currentdate: currentDate, schedules: schedules,startingDay: startingDay, endingDay: endingDay, interval: interval, slotStartTime: slotStartTime, slotEndTime: slotEndTime, diff: diff)
        self.navigationController?.pushViewController(addScheduleVC, animated: true)
    }




    func createData(data: [Schedule]) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context1 = appDelegate?.persistentContainer.viewContext
        guard let context = context1 else {
            return
        }
        for i in 0...data.count-1 {
            let entity = NSEntityDescription.entity(forEntityName: "Meeting", in: context)
            let newMeeting = NSManagedObject(entity: entity!, insertInto: context)
           newMeeting.setValue(data[i].startTime, forKey: "startTime")
             newMeeting.setValue(data[i].endTime, forKey: "endTime")
             newMeeting.setValue(data[i].description, forKey: "desc")
            newMeeting.setValue(data[i].participants.joined(separator:", "), forKey: "participants")

        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        }

    func fetchData() {

            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let context1 = appDelegate?.persistentContainer.viewContext
            guard let context = context1 else {
                return
            }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meeting")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                var array:[Schedule] = [];
                for data in result as! [NSManagedObject] {
                    guard let t1 = data.value(forKey: "startTime") as? String,let t2 = data.value(forKey: "endTime") as? String,let t3 = data.value(forKey: "desc") as? String,let t4 = data.value(forKey: "participants") as? String else {
                        return
                    }

                    var ele = Schedule.init(startTime: t1, endTime: t2, description: t3, participants: t4)
                    array.append(ele)
                }
                displayData(array)

            } catch {

                print("Failed")
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }

    func emptyCoreData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context1 = delegate?.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Meeting")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        if let context = context1 {
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        }
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Meeting")
//        let request = NSBatchDeleteRequest(fetchRequest: fetch)
//        let result = try managedObjectContext.executeRequest(request)
    }
    func configureTitle(_ navigationTile: String?) {
         title = navigationTile
    }

    func configureNavigationBar() {
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x00A799)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        let leftButton = UIButton(type: .system)
        leftButton.semanticContentAttribute = .forceLeftToRight
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        leftButton.setTitle("PREV", for: .normal)
        leftButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
        leftButton.sizeToFit()
        leftButton.addTarget(self, action: #selector(leftButtonAction(sender:)), for: .touchUpInside)
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)

        let rightButton = UIButton(type: .system)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.semanticContentAttribute = .forceRightToLeft
//        rightButton.setImage(UIImage(named: "right-arrow"), for: .normal)
        rightButton.setTitle("NEXT", for: .normal)
        rightButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
        rightButton.addTarget(self, action: #selector(rightButtonAction(sender:)), for: .touchUpInside)
        rightButton.sizeToFit()
        let settingBtn = UIButton(type: .system)
        settingBtn.imageView?.contentMode = .scaleAspectFit
        settingBtn.semanticContentAttribute = .forceRightToLeft
//        settingBtn.setImage(UIImage(named: "right-arrow"), for: .normal)
        settingBtn.setTitle("SET", for: .normal)
        settingBtn.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
        settingBtn.addTarget(self, action: #selector(settingButtonAction(sender:)), for: .touchUpInside)
        settingBtn.sizeToFit()

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightButton),UIBarButtonItem(customView: settingBtn)]

    }
     @objc func settingButtonAction(sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(SettingViewController(delegate: self), animated: true)

    }
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        guard let date = currentDate else {
            return
        }
        var nextDay = date.tomorrow;
        print(startingDay)
        print(endingDay);
        print(interval);
        if(!(nextDay?.isValidDay(startingDay: startingDay, endingDay: endingDay, interval: interval) ?? true)) {
            nextDay = nextDay?.getNextDate(startingDay: startingDay, endingDay: endingDay, interval: interval)

        }
        guard let nextdate = nextDay else {
            return
        }
        getSchedules(nextdate.getFullDate(), nextDay);
    }
    @objc func leftButtonAction(sender: UIBarButtonItem) {
        guard let date = currentDate else {
            return
        }
        var nextDay = date.yesterday;

        if(!(nextDay?.isValidDay(startingDay: startingDay, endingDay: endingDay, interval: interval) ?? true)) {
            nextDay = nextDay?.getPrevDate(startingDay: startingDay, endingDay: endingDay, interval: interval)

        }
//        if(date.isMonday()) {
//            nextDay = nextDay?.prevYesterday;
//        }
        guard let nextdate = nextDay else {
            return
        }
        getSchedules(nextdate.getFullDate(), nextDay);
    }

    func getSchedules(_ date: String, _ currentDate: Date? = Date()) {
        ScheduleManager.getSchedules(with: date) { [weak self] (schedules) -> Void? in

            guard let schedules = schedules else {
                self?.presentAlert(alertTitle: "Some error occured", alertMessage:  "")
                self?.refreshControl.endRefreshing()
                return nil}
            UserDefaults.standard.set(currentDate?.timeIntervalSince1970, forKey: "date")

            self?.currentDate = currentDate
            self?.configureTitle(self?.currentDate?.getFullDate(true, self?.isPortrait ?? true))
            guard schedules.count > 0 else {
                self?.presentAlert(alertTitle: "No data Available", alertMessage:  "")
                self?.refreshControl.endRefreshing()
                return nil
            }
            self?.emptyCoreData()
            self?.createData(data: schedules)
            self?.displayData(schedules)
            print(schedules);
            self?.refreshControl.endRefreshing()
            return nil
        }
    }

    func displayData(_ schedules: [Schedule]) {
        var sortedArray = schedules;
        sortedArray.sort(by: { (item1, item2) -> Bool in
            print(item1.startTime.isLess(str: item2.startTime))
            return item1.startTime.isLess(str: item2.startTime)
        })
        self.schedules =  sortedArray;

        self.tableView.reloadData();
    }

    private func configureRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self, action: #selector(refreshSchedulesData(_:)), for: .valueChanged)
    }

    @objc private func refreshSchedulesData(_ sender: Any) {
            getSchedules(currentDate?.getFullDate() ?? "", currentDate)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isPortrait) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PortaitTableViewCell.self), for: indexPath) as! PortaitTableViewCell
            cell.configure(schedules[indexPath.row]);
             return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LandscapeTableViewCell.self), for: indexPath) as! LandscapeTableViewCell
            cell.configure(schedules[indexPath.row]);
             return cell
        }




    }
}

extension ViewController: selectSettiongData {
    func initData(result: [Int]) {
      startingDay = result[0] //Sunday
       endingDay = result[1]
        interval = 7 - (endingDay - startingDay + 1)
        slotStartTime = result[2];
        slotEndTime = result[3];
        diff = result[4];
        print(startingDay)
        print(endingDay);
        print(interval);
        print(diff);
        getSchedules(currentDate?.getFullDate() ?? "", currentDate)
    }
}




