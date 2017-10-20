//
//  TranslateHistoryCell.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/14.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import UIKit

class TranslateHistoryCell: UITableViewCell {
    
    @IBOutlet weak var original_text: UILabel!
    @IBOutlet weak var translated_text: UILabel!
    @IBOutlet weak var update_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("TranslateHistoryCell awakeFromNib")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(entity :TranslateHistory) {
        self.original_text!.text = entity.original_text
        self.translated_text!.text = entity.translated_text
        self.update_time!.text = convertDateToString(date: entity.update_time! as Date)
    }
    
    private func convertDateToString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM d, yyyy"
        return dateFormatter.string(from: date)
        
    }
}
