//
//  TranslateUseCase.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/05.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class TranslateUseCase {
    
    let request: Request = Request()
    
    func translate(text: String, to: String, completion: @escaping (_ result: String?, _ error: ApiError?) -> Void) {
        self.getToken(text: text) { (token, error) in
            if error != nil {
                completion(nil, error!)
            } else if token != nil {
                self.translate(text: text, token: token!, to: to) { (result, error) in
                    if error != nil {
                        completion(nil, error!)
                    } else if result != nil {
                        completion(result!, nil)
                    }
                }
            }
        }
    }
    
    private func getToken(text: String, completion: @escaping (_ token: String?, _ error: ApiError?) -> Void) {
        let url: URL = URL(string: ApiConstants.tokenUrl)!
        let body: NSMutableDictionary = NSMutableDictionary()
        
        request.getToken(url: url, body: body, completion: completion)
        
    }
    
    private func translate(text: String, token: String, to: String, completion: @escaping (_ result: String?, _ error: ApiError?) -> Void) {
        let url: URL = URL(string: ApiConstants.translateUrl)!
        let appidPrefix = ApiConstants.appidPrefix
        let params: [String: String] = [
            "appid": appidPrefix + token,
            "text": text,
            "to": to
        ]
        request.translate(url: url, parameters: params as [String : AnyObject], completion: completion)
    }
    
}
