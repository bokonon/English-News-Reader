//
//  UpdateHistoryUseCase.swift
//  English News Reader
//
//  Created by yuji shimada on 4/28/19.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import Foundation

import BrightFutures

class UpdateHistoryUseCase {
    
  let request: Request = Request()
  
  func updateHistory(source: String, destination: String) -> Future<String, ApiError> {
    let url: URL = URL(string: ApiConstants.updateHistoryUrl)!
    let parameters:[String: Any] = [
      "source": source,
      "destination": destination
    ]
    return request.updateHistory(url: url, parameters: parameters)
  }
    
}
