//
//  AlarmDetailTableViewCell.swift
//  SWAlarm
//
//  Created by Amesten Systems on 25/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit

class AlarmDetailTableViewCell: UITableViewCell {
    
    weak var cellDelegate: cellDelegateProtocol?

    
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var subTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet var onButtonOutlet: UIButton!
    @IBAction func onButtonAction(_ sender: AnyObject) {
        
        cellDelegate?.didPressButton(sender.tag)

    }
}
