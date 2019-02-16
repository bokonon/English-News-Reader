//
//  NewYorkTimesModelCell.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/09.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import UIKit

class NewsApiModelCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("NewYorkTimesModelCell awakeFromNib")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    func setCell(model :NewsApiModel) {
        self.title!.text = model.title as String
        self.desc!.text = model.description as String
        self.publishedAt!.text = model.publishedAt as String
    }
}
