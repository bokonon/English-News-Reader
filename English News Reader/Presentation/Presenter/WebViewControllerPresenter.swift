//
//  WebViewControllerPresenter.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

import BrightFutures

class WebViewControllerPresenter {
    
  func translate(text: String, to: String) -> Future<String, ApiError> {
     return TranslateUseCase().translate(text: text, to: to)
  }
  
}
