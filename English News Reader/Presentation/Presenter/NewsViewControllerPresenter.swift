//
//  NewsViewControllerPresenter.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

import BrightFutures

class NewsViewControllerPresenter {
    
  func getNews() -> Future<[Article], ApiError> {
    return GetNewsUseCase().getNews()
  }
    
}
