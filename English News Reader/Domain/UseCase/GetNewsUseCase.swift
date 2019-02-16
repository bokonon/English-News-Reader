//
//  GetNewsUseCase.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/08.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class GetNewsUseCase {
    
    let request: Request = Request()
    
    func getNews(currentPage: Int, completion: @escaping (_ result: Array<NewsApiModel>?, _ error: ApiError?) -> Void) {
        
        if let apiKey = KeyManager().getValue(key: ApiConstants.getNewsApiKey) as? String {
            let url: URL = URL(string: ApiConstants.newsUrl)!
            let params: [String: String] = [
                "page": String(currentPage),
                "country": "us",
                "apiKey": apiKey
            ]
            request.getNews(url: url, parameters: params as [String : AnyObject], completion: completion)
        } else {
            completion(nil, ApiError.internalError)
        }
    }
    
}
