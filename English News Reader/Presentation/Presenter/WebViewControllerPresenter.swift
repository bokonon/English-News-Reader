//
//  WebViewControllerPresenter.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class WebViewControllerPresenter {
    
  func translate(text: String, to: String, completion: @escaping (_ result: String?, _ error: ApiError?) -> Void) {
    TranslateUseCase().translate(text: text, to: to) { text, error in
      completion(text!, error)
    }
  }
  
  func saveHistory(_ originalText: String, translatedText: String) {
    TranslateHistoryDao.sharedInstance.insert(originalText, translatedText: translatedText)
  }
    
}
