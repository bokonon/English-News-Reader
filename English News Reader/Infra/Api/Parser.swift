//
//  Parser.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/09.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class Parser {
    
    func parseData(results: NSArray) -> Array<NewYorkTimesModel> {
        var models: Array<NewYorkTimesModel> = [NewYorkTimesModel]()
        for result in results {
            let model: NewYorkTimesModel = NewYorkTimesModel()
            let dictionary = result as! NSDictionary
            
            if let id = dictionary["_id"] as? NSString {
                model._id = id
            }
            if let headline = dictionary["headline"] as? NSDictionary {
                if let main = headline["main"] as? NSString {
                    model.headline.main = main
                }
                if let print_headline = headline["print_headline"] as? NSString {
                    model.headline.print_headline = print_headline
                }
            }
            if let abstract = dictionary["abstract"] as? NSString {
                model.abstract = abstract
            }
            if let lead_paragraph = dictionary["lead_paragraph"] as? NSString {
                model.lead_paragraph = lead_paragraph
            }
            if let news_desk = dictionary["news_desk"] as? NSString {
                model.news_desk = news_desk
            }
            if let pub_date = dictionary["pub_date"] as? NSString {
                model.pub_date = getFormatedDate(srcDate: pub_date as String) as NSString
            }
            if let snippet = dictionary["snippet"] as? NSString {
                model.snippet = snippet
            }
            if let type_of_material = dictionary["type_of_material"] as? NSString {
                model.type_of_material = type_of_material
            }
            if let web_url = dictionary["web_url"] as? NSString {
                model.web_url = web_url
            }
            models.append(model)
            
            print("dictionary : ", "\(dictionary)")
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

