//
//  NewsViewController+UITableViewDelegate.swift
//  English News Reader
//
//  Created by yuji shimada on 4/29/19.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import UIKit

extension NewsViewController: UITableViewDelegate {
  
  func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
    print("performSegue")
    let url = newsApiModels[indexPath.row].url
    print(url)
    webViewUrl = URL(string: url)
    // launch webview
    performSegue(withIdentifier: "segue_for_webview", sender: self)
  }
  
}
