//
//  KeyManager.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

struct KeyManager {
    
    private let keyFilePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    
    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }
    
    func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys.value(forKey: key) as AnyObject
    }
    
}
