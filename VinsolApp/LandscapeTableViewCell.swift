//
//  LandscapeTableViewCell.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import UIKit

class LandscapeTableViewCell: UITableViewCell {

    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel! 

    @IBOutlet weak var participantsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(rgb: 0xF3F3F3)
        // Initialization code
    }

    func configure(_ schedule: Schedule) {
        startTimeLabel.text = schedule.startTime.getTime();
        endTimeLabel.text = schedule.endTime.getTime();
        descriptionLabel.text = schedule.description;
        participantsLabel.text = schedule.participants.joined(separator: " ,");
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
