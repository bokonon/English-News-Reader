//
//  V3TokenDao.swift
//  English News Reader
//
//  Created by yuji shimada on 5/5/19.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import CoreData
import UIKit

import BrightFutures

class V3TokenDao: NSObject {
  
  class var sharedInstance :V3TokenDao {
    struct Static {
      static let instance = V3TokenDao()
    }
    return Static.instance
  }
  
  func findAsync() -> Future<V3Token?, StorageError> {
    let promise = Promise<V3Token?, StorageError>()
    
    DispatchQueue.global(qos: .default).async {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "V3Token")
      
      do {
        let v3Tokens = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as! [V3Token]
        if v3Tokens.count == 1 {
          promise.success(v3Tokens[0])
        } else {
          promise.success(nil)
        }
        
      } catch let error as NSError {
        print(error)
      }
      promise.failure(.dbError)
    }
    
    return promise.future
  }
  
  // update if exist
  func upsert(token: String, createdAt: Date) {
    if find() != nil {
      update(token: token, createdAt: createdAt)
    } else {
      insert(token: token, createdAt: createdAt)
    }
  }
  
  private func find() -> V3Token? {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "V3Token")
    
    do {
      let v3Tokens = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as! [V3Token]
      if v3Tokens.count == 1 {
        return v3Tokens[0]
      }
    } catch let error as NSError {
      print("find error: \(error)")
    }
    return nil
  }
  
  // insert
  private func insert(token: String, createdAt: Date) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let v3Token = NSEntityDescription.insertNewObject(forEntityName: "V3Token", into: appDelegate.persistentContainer.viewContext) as! V3Token
    v3Token.token = token
    v3Token.created_at = createdAt
    
    appDelegate.saveContext()
  }
  
  // update
  private func update(token: String, createdAt: Date) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "V3Token")
    
    do {
      let v3Tokens = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as! [V3Token]
      for v3Token in v3Tokens {
        v3Token.token = token
        v3Token.created_at = createdAt
      }
    } catch let error as NSError {
      print("update error: \(error)")
    }
    appDelegate.saveContext()
  }
  
}
