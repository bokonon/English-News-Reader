//
//  HistoryViewController.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
  
  // MARK: - Properties -

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var noDataLabel: UILabel!
  
  var translateHistoryEntities: [TranslateHistory] = []
  
  var indicator = UIActivityIndicatorView()
  
  let presenter: HistoryViewControllerPresenter = HistoryViewControllerPresenter()
  
  // MARK: - Life cycle events -
    
  override func viewDidLoad() {
    super.viewDidLoad()
//    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  
    indicator.startAnimating()
    loadData()
    self.indicator.stopAnimating()
    self.indicator.hidesWhenStopped = true
  }
  
  // MARK: - Private Method -
    
  func loadData() {
    translateHistoryEntities = presenter.getHistory()
    
    DispatchQueue.main.async(execute: {
      self.tableView.reloadData()
      if self.translateHistoryEntities.isEmpty {
        self.tableView.isHidden = true
        self.noDataLabel.isHidden = false
      } else {
        self.tableView.isHidden = false
        self.noDataLabel.isHidden = true
      }
    })
    
  }
    
}
