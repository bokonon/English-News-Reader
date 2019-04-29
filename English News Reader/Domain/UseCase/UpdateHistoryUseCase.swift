//
//  UpdateHistoryUseCase.swift
//  English News Reader
//
//  Created by yuji shimada on 4/28/19.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import Foundation

class UpdateHistoryUseCase {
    
  let request: Request = Request()
  
  func updateHistory(source: String, destination: String, completion: @escaping (_ result: String?, _ error: ApiError?) -> Void) {
    let url: URL = URL(string: ApiConstants.updateHistoryUrl)!
    let body: NSMutableDictionary = NSMutableDictionary()
    body.setValue(source, forKey: "source")
    body.setValue(destination, forKey: "destination")
    request.updateHistory(url: url, body: body, completion: completion)
  }
    
}
