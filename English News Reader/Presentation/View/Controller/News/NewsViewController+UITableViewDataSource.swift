//
//  NewsViewController+UITableViewDataSource.swift
//  English News Reader
//
//  Created by yuji shimada on 4/29/19.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import UIKit

extension NewsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("newsApiModels.count", newsApiModels.count)
    return newsApiModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: NewsApiModelCell = tableView.dequeueReusableCell(withIdentifier: "NewsApiModelCell", for: indexPath) as! NewsApiModelCell
    
    print("newsApiModels.count", newsApiModels.count)
    print("indexPath.row", indexPath.row)
    
    cell.setCell(model: newsApiModels[indexPath.row])
    
    // when cell is almost last
    if(newsApiModels.count - 1 <= indexPath.row) {
      readMore()
    }
    
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
}
