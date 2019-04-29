//
//  HistoryViewController+UITableViewDataSource.swift
//  English News Reader
//
//  Created by yuji shimada on 4/29/19.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import UIKit

extension HistoryViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return translateHistoryEntities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TranslateHistoryCell = tableView.dequeueReusableCell(withIdentifier: "TranslateHistoryCell", for: indexPath) as! TranslateHistoryCell
    cell.setCell(entity: translateHistoryEntities[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {
      // delete from DB
      presenter.delete(originalText: translateHistoryEntities[indexPath.row].original_text!)
      // remove from array
      translateHistoryEntities.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
      
      if translateHistoryEntities.isEmpty {
        self.tableView.isHidden = true
        self.noDataLabel.isHidden = false
      }
    }
  }
  
}
