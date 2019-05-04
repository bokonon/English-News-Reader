//
//  GetNewsUseCase.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/08.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

import BrightFutures

class GetNewsUseCase {
    
  let request: Request = Request()
  
  func getNews() -> Future<[Article], ApiError> {
    let promise = Promise<[Article], ApiError>()
    if let apiKey = KeyManager().getValue(key: ApiConstants.getNewsApiKey) as? String {
      let url: URL = URL(string: ApiConstants.newsUrl)!
      let parameters: [String: String] = [
        "country": "us",
        "apiKey": apiKey
      ]
      request.getNews(url: url, parameters: parameters as [String : AnyObject])
        .onSuccess(DispatchQueue.main.context) { articles in
          promise.success(articles)
        }.onFailure(DispatchQueue.main.context) { error in
          promise.failure(error)
      }
    } else {
      promise.failure(ApiError.internalError)
    }
    return promise.future
  }
    
}
