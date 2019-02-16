//
//  Parser.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/09.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class Parser {
    
    func parseData(results: NSArray) -> Array<NewsApiModel> {
        var models: Array<NewsApiModel> = [NewsApiModel]()
        for result in results {
            
            var model: NewsApiModel = NewsApiModel(author: "", content: "", description: "", publishedAt: "", source: NewsApiModel.Source(id: "", name: ""), title: "", url: "", urlToImage: "")
            
            if let dictionary = result as? NSDictionary {
                if let author = dictionary["author"] as? String {
                    model.author = author
                }
                if let content = dictionary["content"] as? String {
                    model.content = content
                }
                if let description = dictionary["description"] as? String {
                    model.description = description
                }
                if let publishedAt = dictionary["publishedAt"] as? String {
//                    model.publishedAt = publishedAt
                    model.publishedAt = getFormatedDate(srcDate: publishedAt)
                }
                
                if let sourceDic = dictionary["source"] as? NSDictionary {
                    if let id = sourceDic["id"] as? String {
                        model.source.id = id
                    }
                    if let name = sourceDic["name"] as? String {
                        model.source.name = name
                    }
                }
                if let title = dictionary["title"] as? String {
                    model.title = title
                }
                if let url = dictionary["url"] as? String {
                    model.url = url
                }
                if let urlToImage = dictionary["urlToImage"] as? String {
                    model.urlToImage = urlToImage
                }
                print("dictionary : ", "\(dictionary)")
            }
            models.append(model)
        }
        return models
    }
    
    private func getFormatedDate(srcDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: srcDate)
        dateFormatter.dateFormat = "MM d, yyyy"
        let dstDate = dateFormatter.string(from: date!)
        return dstDate
    }
    
}

