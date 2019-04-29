//
//  NewsViewController.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
  
  // MARK: - Properties -
    
  @IBOutlet weak var tableView: UITableView!
  
  var newsApiModels: [NewsApiModel] = []
  
  var currentPage: Int = 0
  
  var refreshControl: UIRefreshControl = UIRefreshControl()
  
  var indicator = UIActivityIndicatorView()
  
  let presenter: NewsViewControllerPresenter = NewsViewControllerPresenter()
  
  var webViewUrl: URL?
  
  // MARK: - Life cycle events -
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.delegate = self
    tableView.dataSource = self
    
    refreshControl.addTarget(self, action: #selector(NewsViewController.refresh(sender:)), for: .valueChanged)
    tableView.addSubview(refreshControl)
    
    tableView.isHidden = true
    self.initIndicator()
    
    getNews(currentPage: currentPage)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  // when translate to search view
  override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
    if segue.identifier == "segue_for_webview" {
      let webViewController : WebViewController = segue.destination as! WebViewController
    
      webViewController.webViewUrl = self.webViewUrl
    }
  }
  
  // MARK: - Public Method -
  
  public func readMore() {
    print("readMore")
    currentPage += 1
    self.getNews(currentPage: currentPage)
  }
  
  // MARK: - Private Method -
  
  private func getNews(currentPage: Int) {
    indicator.startAnimating()
    presenter.getNews(currentPage: currentPage) { result, error in
      if error != nil {
        print("error on get news : \(error!)")
        // show error message
        self.indicator.stopAnimating()
      } else if result != nil {
        print("append")
        self.newsApiModels.append(contentsOf: result!)
      }
      DispatchQueue.global(qos: .default).async {
        DispatchQueue.main.async {
          self.tableView.isHidden = false
          self.tableView.reloadData()
          self.refreshControl.endRefreshing()
          self.indicator.stopAnimating()
        }
      }
    }
  }
  
  @objc func refresh(sender: UIRefreshControl) {
    print("refresh")
    currentPage = 0
    newsApiModels.removeAll()
    tableView.reloadData()
    self.getNews(currentPage: currentPage)
  }
  
  // prepare indicator
  private func initIndicator(){
    indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    indicator.center = self.view.center
    self.view.addSubview(indicator)
  }
    
}
