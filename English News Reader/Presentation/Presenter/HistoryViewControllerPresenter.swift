//
//  HistoryViewControllerPresenter.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class HistoryViewControllerPresenter {
    
  func getHistory() -> [TranslateHistory] {
    return TranslateHistoryDao.sharedInstance.findAll()
  }
  
  func delete(originalText: String) {
    TranslateHistoryDao.sharedInstance.delete(originalText)
  }
    
}
