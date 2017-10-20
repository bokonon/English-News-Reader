//
//  TranslateHistoryDao.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/14.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TranslateHistoryDao: NSObject {
    
    var readDataList = [NSManagedObject]()
    
    class var sharedInstance :TranslateHistoryDao {
        struct Static {
            static let instance = TranslateHistoryDao()
        }
        return Static.instance
    }
    
    // find all
    func findAll() ->  [TranslateHistory] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TranslateHistory")
        
        // sort by date
        let sortDescriptor = NSSortDescriptor(key: "update_time", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let histories = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as! [TranslateHistory]
            for history in histories {
                print("\(String(describing: history.original_text)) \(String(describing: history.translated_text)) \(String(describing: history.update_time))")
            }
            return histories
            
        } catch let error as NSError {
            print(error)
        }
        return [TranslateHistory]()
    }
    
    // find with original word
    func find(_ originalText: String) -> [TranslateHistory] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TranslateHistory")
        let predicate = NSPredicate(format: "original_text = %@", originalText)
        fetchRequest.predicate = predicate
        
        do {
            let histories = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as! [TranslateHistory]
            print("histories", histories)
            for history in histories {
                print("\(String(describing: history.original_text)) \(String(describing: history.translated_text)) \(String(describing: history.update_time))")
            }
            return histories
            
        } catch let error as NSError {
            print(error)
        }
        return [TranslateHistory]()
    }
    
    // insert
    func insert(_ originalText: String, translatedText: String) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let history = NSEntityDescription.insertNewObject(forEntityName: "TranslateHistory", into: appDelegate.persistentContainer.viewContext) as! TranslateHistory
            history.original_text = originalText
            history.translated_text = translatedText
            history.update_time = Date()
            
            appDelegate.saveContext()
        }
    }
    
    // update if exist
    func updateIfExistOrInsert(_ originalText: String, translatedText: String) {
        let histories = find(originalText)
        
        for history in histories {
            print("\(String(describing: history.original_text)) \(String(describing: history.translated_text)) \(String(describing: history.update_time))")
        }
        
        if histories.isEmpty {
            print("insert : ", originalText)
            insert(originalText, translatedText: translatedText)
        } else {
            print("update : ", originalText)
            update(originalText)
        }
        
    }
    
    // update
    func update(_ originalText: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TranslateHistory")
        let predicate = NSPredicate(format: "original_word = %@", originalText)
        fetchRequest.predicate = predicate
        
        do {
            let histories = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as! [TranslateHistory]
            for history in histories {
                history.update_time = Date()
            }
        } catch let error as NSError {
            print(error)
        }
        appDelegate.saveContext()
    }
    
    // delete
    func delete(_ originalText: String) {
        print("remove", "originalText : "+originalText)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TranslateHistory")
        let predicate = NSPredicate(format: "original_text = %@", originalText)
        fetchRequest.predicate = predicate
        
        do {
            let histories = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as! [TranslateHistory]
            
            print("remove", "histories.count : "+histories.count.description)
            
            for history in histories {
                print("remove", "history.original_text : "+history.original_text!)
                appDelegate.persistentContainer.viewContext.delete(history)
            }
        } catch let error as NSError {
            print(error)
        }
        appDelegate.saveContext()
    }
    
}
