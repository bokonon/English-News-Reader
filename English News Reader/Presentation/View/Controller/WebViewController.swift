//
//  WebViewController.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/07.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    @IBOutlet weak var translateView: UIView!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var tutorialView: UIView!
    
    @IBOutlet weak var languageButton: UIBarButtonItem!
    
    @IBAction func backPage(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    @IBAction func forwardPage(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        startIndicator(self.view)
        self.webView.reload()
    }
    
    @IBAction func changeLanguage(_ sender: UIBarButtonItem) {
        showSelectLanguageActionSheet()
    }
    
    var webViewUrl: URL!
    
    var timer: Timer = Timer()
    
    var userDefault = UserDefaults.standard
    
    var toLanguage: String = "ja"
    
    let presenter: WebViewControllerPresenter = WebViewControllerPresenter()
    
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startIndicator(self.view)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        // allow swipe
        webView.allowsBackForwardNavigationGestures = true

        let req = URLRequest(url: webViewUrl)
        webView.load(req)

        // init translate view
        translateView.isHidden = true
        tutorialView.isHidden = true

        initTranslateLanguage()
        if !userDefault.bool(forKey: "is_show_tutorial") {
            showTutorial()
            userDefault.set(true, forKey: "is_show_tutorial")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
        if let url = webView.url?.absoluteString {
            print("url : ", url)
            if let url = webView.url?.absoluteString {
                print("url : ", url)
                if "https://www.ys.enr/touchend" == url {
                    print("touchend")
                    //            translate()
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
    
    @objc func translate() {
        let script = "window.getSelection().toString();"
        webView.evaluateJavaScript(script, completionHandler: { (html, error) -> Void in
            if let text = html as? String {
                print("text : ", text)
                if 0 < text.characters.count {
                    self.showTranslateView(text)
                } else {
                    if !self.translateView.isHidden {
                        self.hideTranslateView()
                    }
                }
            } else {
                if !self.translateView.isHidden {
                    self.hideTranslateView()
                }
            }
        })
    }
    
    func initTranslateLanguage() {
        if let toLanguageKey = userDefault.string(forKey: "to_language") {
            toLanguage = toLanguageKey
            if let languageButtonTitle = LanguageUtil.getKey(value: toLanguageKey) {
                languageButton.title = languageButtonTitle
            }
        }
    }
    
    func showTranslateView(_ srcText: String) {

        // guard called twice
        if sourceLabel.text == srcText {
            return
        }

        sourceLabel.text = srcText
        translate(srcText, label: destinationLabel)

        if !translateView.isHidden {
            return
        }
        // init animation
        translateView.center = CGPoint(x: translateView.center.x,y: self.webView.frame.height + self.translateView.frame.height/2);
        translateView.isHidden = false

        UIView.animate(withDuration: TimeInterval(CGFloat(0.6)),
                       animations: {() -> Void in
                        // translate to
                        self.translateView.center = CGPoint(x: self.translateView.center.x,
                                                            y: self.webView.frame.height - self.translateView.frame.height/2);

        }, completion: {(Bool) -> Void in
            // animation end
        })
    }
    
    func hideTranslateView() {
        UIView.animate(withDuration: TimeInterval(CGFloat(0.6)),
                       animations: {() -> Void in

                        // translate to
                        self.translateView.center = CGPoint(x: self.translateView.center.x,
                                                            y: self.webView.frame.height + self.translateView.frame.height);

        }, completion: {(Bool) -> Void in
            // animation end
            self.translateView.isHidden = true
            self.sourceLabel.text = ""
            self.destinationLabel.text = ""
        })
    }
    
    func translate(_ srcText: String, label: UILabel) {
        self.startIndicator(destinationLabel)
        presenter.translate(text: srcText, to: toLanguage) { text, error in
            self.stopIndicator()
            if error != nil {
                self.updateLabel(label: label, text: ErrorMessageConstants.translateErrorMessage)
            } else if text != nil {
                self.updateLabel(label: label, text: text!)
                if (text! != "") {
                    // save data
                    self.presenter.saveHistory(srcText, translatedText: text!)
                }
            }
        }
    }
    
    func startIndicator(_ targetView: UIView) {
        loadingIndicator.center.x = targetView.frame.width/2
        loadingIndicator.center.y = targetView.center.y;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        targetView.addSubview(loadingIndicator)
    }
    
    func stopIndicator() {
        DispatchQueue.main.async(){
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // show select Language ActionSheet
    func showSelectLanguageActionSheet() {
        let alert: UIAlertController = getAlertAction("Select language for translate")
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)

        let cancelAction:UIAlertAction = getCancelActionSheet(self.languageButton)
        alert.addAction(cancelAction)

        let items: [String] = LanguageUtil.getKeys()
        var i = 0
        for item in items {
            let itemAction:UIAlertAction = getActionSheet(self.languageButton, title: item, key: "to_language", position: i)
            alert.addAction(itemAction)
            i += 1
        }

        present(alert, animated: true, completion: nil)
    }
    
    // return action sheet
    func getAlertAction(_ title: String) -> UIAlertController {
        return UIAlertController(title:title,
                                 message: "",
                                 preferredStyle: UIAlertControllerStyle.actionSheet)
    }
    
    // return cancel action sheet
    func getCancelActionSheet(_ barButton: UIBarButtonItem) -> UIAlertAction {
        return UIAlertAction(title: "Cancel",
                             style: UIAlertActionStyle.cancel,
                             handler:{
                                (action:UIAlertAction!) -> Void in
                                print("Cancel")
                                // do nothing
        })
    }
    
    // return alert action
    func getActionSheet(_ barButton: UIBarButtonItem, title: String, key: String, position: Int) -> UIAlertAction {
        return UIAlertAction(title: title,
                             style: UIAlertActionStyle.default,
                             handler:{
                                (action:UIAlertAction!) -> Void in
                                barButton.title = title
                                
                                self.toLanguage = LanguageUtil.getValue(key: title)
                                self.userDefault.setValue(self.toLanguage, forKeyPath: "to_language")
        })

    }
    
    func showTutorial(){
        showTranslateView("translate")

        tutorialView.isHidden = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(WebViewController.tutorialTapped(_:)))
        tutorialView.addGestureRecognizer(gesture)
    }
    
    @objc func tutorialTapped(_ gesture: UITapGestureRecognizer) {
        hideTranslateView()
        tutorialView.isHidden = true
    }
    
    func updateLabel(label: UILabel, text: String) {
        DispatchQueue.main.async(){
            label.text = text
        }
    }
    
}
