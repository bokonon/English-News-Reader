//
//  NewYorkTimesModelCell.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/09.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import UIKit

class NewYorkTimesModelCell: UITableViewCell {
    
    @IBOutlet weak var headline_main: UILabel!
    @IBOutlet weak var snippet: UILabel!
    @IBOutlet weak var pub_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("NewYorkTimesModelCell awakeFromNib")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    func setCell(model :NewYorkTimesModel) {
        self.headline_main!.text = model.headline.main as String
        self.snippet!.text = model.snippet as String
        self.pub_date!.text = model.pub_date as String
    }
}
