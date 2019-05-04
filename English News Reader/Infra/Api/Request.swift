//
//  Request.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/02.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

import Alamofire
import BrightFutures

extension String {
    
  /// Percent escapes values to be added to a URL query as specified in RFC 3986
  ///
  /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
  ///
  /// http://www.ietf.org/rfc/rfc3986.txt
  ///
  /// - returns: Returns percent-escaped string.
  
  func addingPercentEncodingForURLQueryValue() -> String? {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
  
    var allowed = CharacterSet.urlQueryAllowed
    allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
  
    return addingPercentEncoding(withAllowedCharacters: allowed)
  }
    
}

extension Dictionary {
    
  /// Build string representation of HTTP parameter dictionary of keys and objects
  ///
  /// This percent escapes in compliance with RFC 3986
  ///
  /// http://www.ietf.org/rfc/rfc3986.txt
  ///
  /// - returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
  
  func stringFromHttpParameters() -> String {
    let parameterArray = map { key, value -> String in
      let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
      let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
      return "\(percentEscapedKey)=\(percentEscapedValue)"
    }
    return parameterArray.joined(separator: "&")
  }
    
}

struct NewResponseObject: Codable {
  var status: String
  var totalResults: Int
  var articles: [Article]
}

class Request: NSObject, XMLParserDelegate {
    
  let session: URLSession = URLSession.shared
  
  var translatedResult: String?
  
  /// Public Method
  
  func getNews(url: URL, parameters: [String: AnyObject]) -> Future<[Article], ApiError> {
    let promise = Promise<[Article], ApiError>()
    
    let parameterString = parameters.stringFromHttpParameters()
    let requestURL = URL(string: url.absoluteString + "?" + parameterString)!
    
    Alamofire.request(requestURL).responseJSON { response in
      guard let result = response.data else {
        promise.failure(ApiError.unknownError)
        print("unknownError")
        return
      }

      if let error = response.result.error as? AFError {
        print("\(error)")
        promise.failure(ApiError.responseError)
        return
      }
      
      do {
        let newsApiModels = try JSONDecoder().decode(NewResponseObject.self, from: result)
//        print("newsApiModels: \(newsApiModels)")
        promise.success(newsApiModels.articles)
      } catch {
        promise.failure(ApiError.parseError)
        print("error: \(error)")
      }
      
    }
    return promise.future
  }
  
  func getToken(url: URL) -> Future<String, ApiError> {
    let promise = Promise<String, ApiError>()
    
    if let apiKey = KeyManager().getValue(key: ApiConstants.translateApiKey1) as? String {
      let headers: HTTPHeaders = [
        ApiConstants.apiKeyField: apiKey,
        "Content-Type" : "application/json",
        "Accept" : "Content-Type"
      ]
      
      Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).response { response in
      
//        print("token response: \(response)")
        
        guard let result = response.data else {
          promise.failure(ApiError.unknownError)
          print("unknownError")
          return
        }
        
        if let token = String(data: result, encoding: .utf8) {
          print("token: \(token)")
          promise.success(token)
        } else {
          promise.failure(ApiError.parseError)
        }
        
      }
    } else {
      promise.failure(ApiError.internalError)
    }
    return promise.future
  }
  
  func translate(url: URL, parameters: [String: AnyObject]) -> Future<String, ApiError> {
    let promise = Promise<String, ApiError>()
    let parameterString = parameters.stringFromHttpParameters()
    let requestURL = URL(string: url.absoluteString + "?" + parameterString)!
  
    Alamofire.request(requestURL).response { response in
      
      print("translate response: \(response)")
      
      guard let result = response.data else {
        promise.failure(ApiError.unknownError)
        print("unknownError")
        return
      }
      
      let parser = XMLParser(data: result)
      parser.delegate = self
      if parser.parse() {
        if let translatedResult = self.translatedResult {
          promise.success(translatedResult)
        } else {
          promise.failure(ApiError.unknownError)
        }
      } else {
        promise.failure(ApiError.parseError)
      }

    }
    return promise.future
  }
  
  func updateHistory(url: URL, parameters: [String: Any]) -> Future<String, ApiError> {
    let promise = Promise<String, ApiError>()
    if let apiKey = KeyManager().getValue(key: ApiConstants.updateHistoryApiKey) as? String {
      let headers: HTTPHeaders = [
        apiKey: ApiConstants.translateHistoryApiKeyField,
        "application/json": "Content-Type",
        "Content-Type": "Accept"
      ]
      
      Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
        guard let result = response.data else {
          promise.failure(ApiError.unknownError)
          print("unknownError")
          return
        }
        
        if let error = response.result.error as? AFError {
          print("\(error)")
          promise.failure(ApiError.responseError)
          return
        }
        
        do {
          let result = try JSONDecoder().decode(String.self, from: result)
          print("result: \(result)")
          promise.success(result)
        } catch {
          promise.failure(ApiError.parseError)
          print("error: \(error)")
        }
        
      }
    } else {
      promise.failure(ApiError.internalError)
    }
    return promise.future
  }
  
  /// Private Method
  
  private func get(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var request: URLRequest = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    session.dataTask(with: request, completionHandler: completionHandler).resume()
  }
  
  private func post(url: URL, header: NSMutableDictionary, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    var request: URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    for (value, field) in header {
        request.addValue(value as! String, forHTTPHeaderField: field as! String)
    }
    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
  
    session.dataTask(with: request, completionHandler: completionHandler).resume()
  }
  
  // parser delegate
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    translatedResult = string
  }
    
}
