//
//  Request.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/02.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

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

class Request: NSObject, XMLParserDelegate {
    
    let session: URLSession = URLSession.shared
    
    var translatedResult: String?
    
    /// Public Method
    
    func getNews(url: URL, parameters: [String: AnyObject], completion: @escaping (_ result: Array<NewsApiModel>?, _ error: ApiError?) -> Void) {
        
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = URL(string: url.absoluteString + "?" + parameterString)!
        
        self.get(url: requestURL, completionHandler: { data, response, error in
            if error != nil {
                print("\(error! as Error)")
                completion(nil, ApiError.requestError)
            } else if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse)")
                if 200 <= httpResponse.statusCode
                    && httpResponse.statusCode < 300 {
                    if data != nil {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                            let results: NSArray = json.object(forKey: "articles") as! NSArray
                            completion(Parser().parseData(results: results), nil)
                        } catch {
                            completion(nil, ApiError.parseError)
                        }
                    } else {
                        completion(nil, ApiError.unknownError)
                    }
                } else {
                    completion(nil, ApiError.responseError)
                }
            }
        })
    }
    
    func getToken(url: URL, body: NSMutableDictionary, completion: @escaping (_ token: String?, _ error: ApiError?) -> Void) {
        
        if let apiKey = KeyManager().getValue(key: ApiConstants.translateApiKey1) as? String {
            let header: [String: String] = [
                apiKey: ApiConstants.apiKeyField,
                "application/json": "Content-Type",
                "Content-Type": "Accept"
            ]
            do {
                try self.post(url: url, header: NSMutableDictionary(dictionary: header), body: body, completionHandler: { data, response, error in
                    if error != nil {
                        print("\(error! as Error)")
                        completion(nil, ApiError.requestError)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        print("\(httpResponse)")
                        if 200 <= httpResponse.statusCode
                            && httpResponse.statusCode < 300 {
                            if data != nil {
                                let token = String(data: data!, encoding: .utf8)!
                                print(token)
                                completion(token, nil)
                            } else {
                                completion(nil, ApiError.unknownError)
                            }
                        } else {
                            completion(nil, ApiError.responseError)
                        }
                    }
                })
            } catch {
                completion(nil, ApiError.unknownError)
            }
        } else {
            completion(nil, ApiError.internalError)
        }
    }
    
    func translate(url: URL, parameters: [String: AnyObject], completion: @escaping (_ result: String?, _ error: ApiError?) -> Void) {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = URL(string: url.absoluteString + "?" + parameterString)!
        
        self.get(url: requestURL, completionHandler: { data, response, error in
            if error != nil {
                print("\(error! as Error)")
                completion(nil, ApiError.requestError)
            } else if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse)")
                if 200 <= httpResponse.statusCode
                    && httpResponse.statusCode < 300 {
                    if data != nil {
                        let parser = XMLParser(data: data!)
                        parser.delegate = self
                        if parser.parse() {
                            completion(self.translatedResult, nil)
                        } else {
                            completion(nil, ApiError.parseError)
                        }
                        
                    } else {
                        completion(nil, ApiError.unknownError)
                    }
                } else {
                    completion(nil, ApiError.responseError)
                }
            }
        })
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
