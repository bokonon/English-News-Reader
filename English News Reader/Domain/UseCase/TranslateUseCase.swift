//
//  TranslateUseCase.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/05.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

import BrightFutures

class TranslateUseCase {
    
  let request: Request = Request()
  
  func translate(text: String, to: String) -> Future<String, ApiError> {
    let promise = Promise<String, ApiError>()
    self.getToken(text: text).flatMap { token -> Future<String, ApiError> in
      self.translate(text: text, token: token, to: to)
    }.onSuccess(DispatchQueue.main.context) { destination in
      TranslateHistoryDao.sharedInstance.upsert(originalText: text, translatedText: destination)
      UpdateHistoryUseCase().updateHistory(source: text, destination: destination)
        .onSuccess { result in
          print("result: \(result)")
        }.onFailure { error in
          print("error: \(error)")
      }
      promise.success(destination)
    }.onFailure(DispatchQueue.main.context) { error in
      promise.failure(error)
      print("error: \(error)")
    }
    return promise.future
  }
  
  private func getToken(text: String) -> Future<String, ApiError> {
    let url: URL = URL(string: ApiConstants.tokenUrl)!
    return request.getToken(url: url)
  }
  
  private func translate(text: String, token: String, to: String) -> Future<String, ApiError> {
    let url: URL = URL(string: ApiConstants.translateUrl)!
    let appidPrefix = ApiConstants.appidPrefix
    let parameters: [String: String] = [
      "appid": appidPrefix + token,
      "text": text,
      "to": to
    ]
    return request.translate(url: url, parameters: parameters as [String : AnyObject])
  }
    
}
