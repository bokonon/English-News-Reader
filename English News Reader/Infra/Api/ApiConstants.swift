//
//  ApiConstants.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

struct ApiConstants {
  static let newsUrl = "https://newsapi.org/v2/top-headlines"
  static let tokenUrl = "https://api.cognitive.microsoft.com/sts/v1.0/issueToken"
  static let translateUrl = "https://api.microsofttranslator.com/V2/Http.svc/Translate"
  
  // for post
  static let apiKeyField = "Ocp-Apim-Subscription-Key"
  static let getNewsApiKey = "GetNewsApiKey1"
  static let translateApiKey1 = "TranslateApiKey1"
  static let translateApiKey2 = "TranslateApiKey2"
  static let appidPrefix = "Bearer "
  
  static let updateHistoryUrl = "http://13.231.173.184/translate-history/history/update"
  static let translateHistoryApiKeyField = "Translate-History-Api-Key"
  static let updateHistoryApiKey = "UpdateHistoryApiKey"
}

struct ErrorMessageConstants {
  static let translateErrorMessage = "An error occurred. Please select the text again."
}

enum ApiError: Error {
  case requestError
  case responseError
  case parseError
  case internalError
  case unknownError
}

extension ApiError: LocalizedError{
  var errorDescription:String? {
    switch self {
    case .requestError:
      return "request param is invalid"
    case .responseError:
      return "response value is invalid"
    case .parseError:
      return "parse failed"
    case .internalError:
      return "requied param is not enough"
    case .unknownError:
      return "unknown error"
    }
  }
}

enum StorageError: Error {
  case dbError
  case unknownError
}

extension StorageError: LocalizedError{
  var errorDescription:String? {
    switch self {
    case .dbError:
      return "db error"
    case .unknownError:
      return "unknown error"
    }
  }
}
