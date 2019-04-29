//
//  LanguageUtil.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/18.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class LanguageUtil {
    
  static var toLanguage: Dictionary = [
    "Arabic": "ar",
    "Bulgarian": "bg",
    "Catalan": "ca",
    "ChineseSimplified": "zh-CHS",
    "ChineseTraditional": "zh-CHT",
    "Czech": "cs",
    "Danish": "da",
    "Dutch": "nl",
    "English": "en",
    "Estonian": "et",
    "Finnish": "fi",
    "French": "fr",
    "German": "de",
    "Greek": "el",
    "HaitianCreole": "ht",
    "Hebrew": "he",
    "Hindi": "hi",
    "HmongDaw": "mww",
    "Hungarian": "hu",
    "Indonesian": "id",
    "Italian": "it",
    "Japanese": "ja",
    "Klingon": "tlh",
    "KlingonPiqad": "tlh-Qaak",
    "Korean": "ko",
    "Latvian": "lv",
    "Lithuanian": "lt",
    "Malay": "ms",
    "Maltese": "mt",
    "Norwegian": "no",
    "Persian": "fa",
    "Polish": "pl",
    "Portuguese": "pt",
    "Romanian": "ro",
    "Russian": "ru",
    "Slovak": "sk",
    "Slovenian": "sl",
    "Spanish": "es",
    "Swedish": "sv",
    "Thai": "th",
    "Turkish": "tr",
    "Ukrainian": "uk",
    "Urdu": "ur",
    "Vietnamese": "vi",
    "Welsh": "cy"
    ] as [String : String]
  
  static func getKeys() -> [String] {
    return Array(toLanguage.keys)
  }
  
  static func getValues() -> [String] {
    return Array(toLanguage.values)
  }
  
  static func getValue(key: String) -> String {
    return toLanguage[key]!
  }
  
  static func getKey(value: String) -> String? {
    for (k, v) in toLanguage {
      if v == value {
        return k
      }
    }
    return nil
  }
    
}
