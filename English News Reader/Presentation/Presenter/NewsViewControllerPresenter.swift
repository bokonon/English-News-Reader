//
//  NewsViewControllerPresenter.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class NewsViewControllerPresenter {
    
    func getNews(currentPage: Int, completion: @escaping (_ result: Array<NewsApiModel>?, _ error: ApiError?) -> Void) {
        GetNewsUseCase().getNews(currentPage: currentPage) { result, error in
            if error != nil {
                completion(nil, error)
            } else if result != nil {
                completion(result!, nil)
            }
        }
    }
    
}
