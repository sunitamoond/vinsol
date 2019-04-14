//
//  PortaitTableViewCell.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import UIKit

class PortaitTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel! {
        didSet{
            timeLabel.backgroundColor = UIColor.clear
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.backgroundColor = UIColor.clear
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.init(rgb: 0xF3F3F3)
        // Initialization code
    }

    func configure(_ schedule: Schedule){
//        let index = schedule.startTime.index(of: ":")!
//        let newStr = schedule.startTime.substring(to: index)
//        var key = Int(newStr) ?? 0 > 12
//        let  suffix = schedule.startTime.substring(from: index)

//        timeLabel.text = schedule.startTime + " - " + schedule.endTime;
        timeLabel.text =  schedule.startTime.getTime() + " - " + schedule.endTime.getTime();
//            .getTime(schedule)
        print(schedule);
        descriptionLabel.text = schedule.description

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
