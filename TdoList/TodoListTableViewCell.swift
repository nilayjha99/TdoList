//
//  TodoListTableViewCell.swift
//  TdoList
//
//  Created by Nilaykumar Jha on 2018-10-26.
//  Copyright © 2018 Nilaykumar Jha. All rights reserved.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var priorityIndicator: UIButton!
    @IBOutlet weak var taskThumbnail: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
