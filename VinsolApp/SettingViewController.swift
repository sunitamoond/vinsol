//
//  SettingViewController.swift
//  VinsolApp
//
//  Created by Sunita Moond on 14/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import UIKit

protocol selectSettiongData {
    func initData(result: [Int])
}

class SettingViewController: UIViewController {
    var obj: [[Int]] = [[0,1,2,3,4,5,6],[0,1,2,3,4,5,6],[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],[15, 30]]
    var days = [0,1,2,3,4,5,6]
    var diff = [15, 30]
    var time = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    var st = 0;
    var en = 0;
    var d = 30;
    var stT = 0
    var enT = 0;
    var result = [0,0,0,0,30]
    let str:[String] = ["Sun", "Mon", "Tue", "Wedn", "Thu", "Fri", "Sat"];

    @IBOutlet weak var startDay: UIPickerView!{
        didSet{
            startDay.dataSource = self;
            startDay.delegate = self;
            startDay.isUserInteractionEnabled = true
            startDay.tag = 0;
        }
    }

    @IBOutlet weak var endDay: UIPickerView! {
        didSet{
            endDay.dataSource = self;
            endDay.delegate = self;
            endDay.isUserInteractionEnabled = true
            endDay.tag = 1
        }
    }

    @IBOutlet weak var startTime: UIPickerView!{
        didSet{
            startTime.dataSource = self;
            startTime.delegate = self;
            startTime.isUserInteractionEnabled = true
            startTime.tag = 2
        }
    }

    @IBOutlet weak var endTime: UIPickerView!{
        didSet{
            endTime.dataSource = self;
            endTime.delegate = self;
            endTime.isUserInteractionEnabled = true
            endTime.tag = 3
        }
    }


    @IBOutlet weak var slotDiff: UIPickerView!{
        didSet{
            slotDiff.dataSource = self;
            slotDiff.delegate = self;
            slotDiff.isUserInteractionEnabled = true
            slotDiff.tag = 4
        }
    }

    @IBOutlet weak var submitBtn: UIButton!{
        didSet{
            submitBtn.setTitle(("Submit").uppercased(), for: .normal)
            submitBtn.backgroundColor = UIColor.init(rgb: 0x00A799)
            submitBtn.setTitleColor(.white, for: .normal)
            submitBtn.layer.cornerRadius = 8
        }
    }

    @IBAction func submitBtnAction(_ sender: Any) {
        if((result[2] == result[3]) || (result[2] > result[3])) {
           presentAlert(alertTitle: "please select valid start and end time", alertMessage:  "")
        } else {
            delegate?.initData(result: result);
            navigationController?.popViewController(animated: true)
        }
    }
    var delegate: selectSettiongData?

    convenience init(delegate: selectSettiongData) {
        self.init()

        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    func configureNavigationBar() {
        title = "Settings"
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
}

extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  obj[pickerView.tag].count;
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1;
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        result[pickerView.tag] = obj[pickerView.tag][row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0 || pickerView.tag == 1){
            return str[row]
        }

        return "\(obj[pickerView.tag][row])"
    }
}
