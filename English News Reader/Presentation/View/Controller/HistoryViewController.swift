//
//  HistoryViewController.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var translateHistoryEntities: [TranslateHistory] = [TranslateHistory]()
    
    var indicator = UIActivityIndicatorView()
    
    let presenter: HistoryViewControllerPresenter = HistoryViewControllerPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        indicator.startAnimating()
        loadData()
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translateHistoryEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TranslateHistoryCell = tableView.dequeueReusableCell(withIdentifier: "TranslateHistoryCell", for: indexPath) as! TranslateHistoryCell
        cell.setCell(entity: translateHistoryEntities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // delete from DB
            presenter.delete(originalText: translateHistoryEntities[indexPath.row].original_text!)
            // remove from array
            translateHistoryEntities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            if translateHistoryEntities.isEmpty {
                self.tableView.isHidden = true
                self.noDataLabel.isHidden = false
            }
        }
    }
    
    func loadData() {
        translateHistoryEntities = presenter.getHistory()
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            if self.translateHistoryEntities.isEmpty {
                self.tableView.isHidden = true
                self.noDataLabel.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.noDataLabel.isHidden = true
            }
        })
        
    }
    
}
