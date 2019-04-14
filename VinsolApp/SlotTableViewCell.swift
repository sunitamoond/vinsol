//
//  SlotTableViewCell.swift
//  VinsolApp
//
//  Created by Sunita Moond on 14/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import UIKit

class SlotTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.backgroundColor = UIColor.init(rgb: 0xF3F3F3)
    }

    func configure(schedule: Schedule) {
        titleLabel.text = schedule.startTime.getTime() + " - " + schedule.endTime.getTime();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
