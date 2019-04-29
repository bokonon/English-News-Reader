//
//  DateUtil.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/08.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class DateUtil {
    
  static func getToday() -> Date {
    return Date()
  }
  
  static func getYesterday() -> Date {
    let today: Date = Date()
    let daysToAdd:Int = -1
  
    // Set up date components
    var dateComponents: DateComponents = DateComponents()
    dateComponents.day = daysToAdd
  
    // Create a calendar
    let gregorianCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let yesterdayDate: Date = (gregorianCalendar as NSCalendar).date(byAdding: dateComponents, to: today, options:NSCalendar.Options(rawValue: 0))!
  
    return yesterdayDate
  }
  
  // return formated date
  static func getFormatedDate(_ date: Date, dateFormat: String, timeZone: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    dateFormatter.timeZone = TimeZone(identifier: timeZone)
    return dateFormatter.string(from: date)
  }
}
