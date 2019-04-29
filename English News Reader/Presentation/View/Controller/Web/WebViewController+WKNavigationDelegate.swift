//
//  WebViewController+WKNavigationDelegate.swift
//  English News Reader
//
//  Created by yuji shimada on 4/29/19.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import WebKit

extension WebViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("didStartProvisionalNavigation")
    if let url = webView.url?.absoluteString {
      print("url : ", url)
      if let url = webView.url?.absoluteString {
        print("url : ", url)
        if "https://www.ys.enr/touchend" == url {
          print("touchend")
//          translate()
        }
        else if "https://www.ys.enr/selectionchange" == url {
          print("selectionchange")
          // when timer is running
          if timer.isValid == true {
            // stop timer
            timer.invalidate()
          }
          // timer excute after 0.5senconds
          timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(WebViewController.translate as (WebViewController) -> () -> ()), userInfo: nil, repeats: false)
        }
      }
    }
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    stopIndicator()
    print("WebView loaded")
    let touchListenercript = "document.addEventListener(\"touchend\", function(){document.location.href = \"https://www.ys.enr/touchend\"}, false);"
    webView.evaluateJavaScript(touchListenercript, completionHandler: { (html, error) -> Void in
      if error != nil {
        print("error : ", error!)
      }
    })
    
    let changeListenerScript = "document.addEventListener(\"selectionchange\", function(){document.location.href = \"https://www.ys.enr/selectionchange\"}, false);"
    webView.evaluateJavaScript(changeListenerScript, completionHandler: { (html, error) -> Void in
      if error != nil {
        print("error : ", error!)
      }
    })
    
    self.backButton.isEnabled = self.webView.canGoBack
    self.forwardButton.isEnabled = self.webView.canGoForward
  }
  
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    //        print("WebView error : ", error)
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    print("decidePolicyFor")
    if let url = webView.url?.absoluteString {
      
      print(url)
      
      if(url.hasPrefix("https://www.ys.enr/")){
        decisionHandler(WKNavigationActionPolicy.allow)
      }else if(url.hasPrefix("https")){
        decisionHandler(WKNavigationActionPolicy.allow)
      }else{
        decisionHandler(WKNavigationActionPolicy.cancel)
      }
    }
  }
  
  func webView(_: WKWebView, didCommit: WKNavigation!) {
    print("didCommit")
  }
  
  func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    print("didReceiveServerRedirectForProvisionalNavigation")
  }
  
}
