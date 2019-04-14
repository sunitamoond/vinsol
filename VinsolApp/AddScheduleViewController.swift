//
//  AddScheduleViewController.swift
//  VinsolApp
//
//  Created by Sunita Moond on 14/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import UIKit
extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
extension UIToolbar {

    func ToolbarPiker(mySelect : Selector, cancelAction: Selector) -> UIToolbar {

        let toolBar = UIToolbar()

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: cancelAction);


        toolBar.setItems([ spaceButton, doneButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar
    }

}

class AddScheduleViewController: UIViewController {

    @IBOutlet weak var btnBottom: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView! {
        didSet{
            textView.text = ""
            textView.textColor = .black
            textView.layer.borderWidth = 3;
            textView.layer.cornerRadius = 10;

        }
    }
   var slots = [[String]]()
    @IBOutlet weak var dateTop: NSLayoutConstraint!
    @IBOutlet weak var descTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet{
            descriptionTextField.layer.borderWidth = 3;
            descriptionTextField.layer.cornerRadius = 10;
             descriptionTextField.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }

    @IBOutlet weak var startTimeTextFeild: UITextField!{
        didSet{
            startTimeTextFeild.isUserInteractionEnabled = true;
            startTimeTextFeild.layer.borderWidth = 3;
            startTimeTextFeild.layer.cornerRadius = 10;
            startTimeTextFeild.textAlignment = .center
            startTimeTextFeild.layer.backgroundColor = UIColor.lightGray.cgColor
            startTimeTextFeild.text = nil
            startTimeTextFeild.placeholder = "Select Start Time"
        }
    }

    @IBOutlet weak var dateTextField: UITextField! {
        didSet{
            dateTextField.isUserInteractionEnabled = false;
            dateTextField.backgroundColor = UIColor.gray;
            dateTextField.layer.borderWidth = 3;
            dateTextField.layer.cornerRadius = 10;
            dateTextField.textAlignment = .center
            dateTextField.layer.backgroundColor = UIColor.lightGray.cgColor
            dateTextField.text = "02-03-2015"
        }
    }


    func isOccupied(sch: Schedule, s: String, e: String) -> Bool {
        if((sch.startTime.isGreater(str: s) && sch.startTime.isGreater(str: e)) || (s.isGreater(str: sch.endTime) && e.isGreater(str: sch.endTime))) {
            return false
        }

        return true;

    }
    @IBAction func submitBtnAction(_ sender: Any) {
        var start = startTimeTextFeild.text ?? "";
        var end = isPortrait ? (endTimePortTextFeild.text ?? "") : (endTimeTextField.text ?? "")
        if(start.isEmpty || end.isEmpty || textView.text.isEmpty) {
            presentAlert(alertTitle: "fill all the filled", alertMessage:  "")

            return
        } else if(start.isGreater(str: end)) {
            presentAlert(alertTitle: "select valid interval", alertMessage:  "")

            return
        }
        else if(!start.isGreaterThanInt(str: slotStartTime) || !end.isLessThanInt(str: slotEndTime)) {
            presentAlert(alertTitle: "slect slot b/w \(slotStartTime) to \(slotEndTime)", alertMessage:  "")
        }
        var isexist = false
        for i in 0...schedules.count-1 {
            if(isOccupied(sch: schedules[i], s: start, e: end)){
               isexist = true
            }
        }
        if(isexist) {
            let exitAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in

            })
            presentAlert(alertTitle: "this slot not avaiable try others", alertMessage:  "", actionTitle: "ok", actionHandler: { [weak self]
                action in
                var indexs:[Int] = [];
                guard let slots = self?.slots, let schedules = self?.schedules else {return}
                for i in 0...(self?.slots.count ?? 0)-1{
                    self?.freeSlots[i] = true;
                    for j in 0...schedules.count-1 {
                        if(self?.isOccupied(sch: Schedule.init(startTime: slots[i][0], endTime: slots[i][1], description: "ded", participants: "dwd"), s: schedules[j].startTime, e: schedules[j].endTime)  ?? false) {
                            self?.freeSlots[i] = false;
                        }
                    }
                    if(self?.freeSlots[i] ?? true) {
                        indexs.append(i);
                    }
                }

                var slotvc = SlotsViewController.init(freeSlots: self?.freeSlots ?? [], indexs: indexs, currentdate: self?.currentdate, slots: slots,startingDay: self?.startingDay ?? 0, endingDay: self?.endingDay ?? 0,interval: self?.interval ?? 0)
                self?.navigationController?.pushViewController(slotvc, animated: true)

                }, dismiss: false, persistenceTime: 1100000, exitAction: exitAction)
        } else {


        presentAlert(alertTitle: "alloted", alertMessage:  "",actionTitle: "Ok", actionHandler: { [weak self]
            action in
            self?.navigationController?.popViewController(animated: true)
        })
    }

    }


    @IBOutlet weak var submitBtn: UIButton!{
        didSet{
            submitBtn.setTitle(("submit").uppercased(), for: .normal)
            submitBtn.backgroundColor = UIColor.init(rgb: 0x00A799)
            submitBtn.setTitleColor(.white, for: .normal)
            submitBtn.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var endTimePortTextFeild: UITextField!{
        didSet{
            endTimePortTextFeild.isUserInteractionEnabled = true;
//            endTimePortTextFeild.backgroundColor = UIColor.black;
            endTimePortTextFeild.layer.borderWidth = 3;
            endTimePortTextFeild.layer.cornerRadius = 10;
            endTimePortTextFeild.textAlignment = .center
            endTimePortTextFeild.layer.backgroundColor = UIColor.lightGray.cgColor
            endTimePortTextFeild.text = nil
            endTimePortTextFeild.placeholder = "Select End Time"
        }
    }

    @IBOutlet weak var endTimeTextField: UITextField!{
        didSet{
            endTimeTextField.placeholder = "Select End Time"
            endTimeTextField.isUserInteractionEnabled = true;

            endTimeTextField.layer.borderWidth = 3;
            endTimeTextField.layer.cornerRadius = 10;
            endTimeTextField.textAlignment = .center
            endTimeTextField.layer.backgroundColor = UIColor.lightGray.cgColor
            endTimeTextField.text = nil
        }
    }

    var datePicker = UIDatePicker();
     var currentdate: Date? = nil
    var schedules:[Schedule] = [];

    var isPortrait = true;
    var slotStartTime = 9;
    var slotEndTime = 17;
    var diff = 30
    var freeSlots: [Bool] = []
    var startingDay = 1
    var endingDay = 5
    var  interval = 2

    convenience init(isPortrait: Bool, currentdate: Date?, schedules:[Schedule], startingDay: Int, endingDay: Int, interval: Int, slotStartTime: Int, slotEndTime: Int, diff: Int) {
        self.init()

        self.slotStartTime = slotStartTime;
        self.slotEndTime = slotEndTime
        self.diff = diff
        self.startingDay = startingDay
        self.endingDay = endingDay;
        self.interval = interval;
        self.currentdate = currentdate
        self.isPortrait = isPortrait
        self.schedules = schedules;
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let someDoubleFormat = ".2"
        var abc = Double(slotStartTime)
        var newdiff = diff
        while Int(abc) < slotEndTime {
            print(abc);
            var new = Double(slotStartTime) + Double(newdiff % 60) / Double(100) + Double(Int(newdiff / 60))
            newdiff += diff;
             print(new);
            print( Double(diff % 60))
            print(Double(Int(diff / 60)))
            var st = "\(abc.format(f: someDoubleFormat))"
            var en = "\(new.format(f: someDoubleFormat))"
            slots.append([st, en])

            abc = new;
        }

        for i in 0...slots.count-1{
            freeSlots.append(true)
            slots[i][0] = slots[i][0].replacingOccurrences(of: ".", with: ":")
            slots[i][1] = slots[i][1].replacingOccurrences(of: ".", with: ":")
        }

        print(slots);
         getOrientation()
        configureNavigationBar()
        registerForKeyboardNotifications()


        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(self.donedatePicker), cancelAction: #selector(self.cancelDatePicker))
//        datePicker.locale = Locale(identifier: "en_GB")
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat =  "HH:mm"
//
//        let date = dateFormatter.date(from: "00:00")
//        if let a = date {
//
//            datePicker.date = a
//        }

        endTimeTextField.inputAccessoryView = toolBar
        startTimeTextFeild.inputAccessoryView = toolBar
        endTimePortTextFeild.inputAccessoryView = toolBar
        startTimeTextFeild.inputView = datePicker
        endTimeTextField.inputView = datePicker
        endTimePortTextFeild.inputView = datePicker
        datePicker.datePickerMode = .time

        datePicker.minuteInterval = diff
        print(diff)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        getOrientation()
    }


    func configureLayout(flag: Bool) {
        endTimeTextField.isHidden = flag;
        endTimePortTextFeild.isHidden = !flag
        descTop.constant =  flag ? 16 : -32
        dateTop.constant = flag ? 30 : 12
    }
    fileprivate func getOrientation() {
        dateTextField.text = currentdate?.getFullDate(true, isPortrait ?? true)
        if UIDevice.current.orientation.isLandscape {
            isPortrait = false

            configureLayout(flag: false)

        } else {
            endTimeTextField.isHidden = true;
            endTimePortTextFeild.isHidden = false
            isPortrait = true
            configureLayout(flag: true)
        }
    }

    func configureNavigationBar() {
        title = ("Scehdule a Meeting").uppercased()
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

    @objc func leftButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @objc func dismissPicker() {

    view.endEditing(true)

}
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            dateTop.constant = isPortrait ? 30 : 12
        } else {
            var b = btnBottom.constant - keyboardViewEndFrame.height + view.safeAreaInsets.bottom;
            dateTop.constant = ( b > 0) ?  dateTop.constant : ( isPortrait ? (30 - keyboardViewEndFrame.height + view.safeAreaInsets.bottom - b) : (30 - keyboardViewEndFrame.height + view.safeAreaInsets.bottom));
        }
    }

    private func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func donedatePicker(){

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        print(datePicker.date.getTime());
        var time = datePicker.date.getTime();
        print(startTimeTextFeild.isEditing)
        if(startTimeTextFeild.isEditing) {
            startTimeTextFeild.text = time
        } else if(endTimePortTextFeild.isEditing) {
            endTimePortTextFeild.text = time
        } else if(endTimeTextField.isEditing) {
            endTimeTextField.text = time
        }

        self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

extension AddScheduleViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat =  "HH : mm"
//
//        let date = dateFormatter.date(from: startTimeTextFeild.text ?? "00:00")
//        if let a = date {
//
//            datePicker.date = a
//        }
//        if(textView.tag == 0) {
//
//        } else if(textView.tag == 1) {
//            dat
//
//        } else if(textView.tag == 2) {
//
//        }
    }
}
