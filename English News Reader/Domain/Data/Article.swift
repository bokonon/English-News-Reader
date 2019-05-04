//
//  NewsApiModel.swift
//  English News Reader
//
//  Created by yuji shimada on 2019/02/16.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import Foundation

class Article: Codable {
  var author: String?
  var content: String?
  var description: String?
  var publishedAt: String?
  var source: Source
  var title: String?
  var url: String?
  var urlToImage: String?
  
  init(author: String, content: String, description: String, publishedAt: String,
       source: Source, title: String, url: String, urlToImage: String) {
    self.author = author
    self.content = content
    self.description = description
    self.publishedAt = publishedAt
    self.source = source
    self.title = title
    self.url = url
    self.urlToImage = urlToImage
  }
  
  class Source: Codable {
    var id: String?
    var name: String?
    init (id: String, name: String) {
      self.id = id
      self.name = name
    }
  }
}
