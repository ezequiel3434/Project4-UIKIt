//
//  ViewController.swift
//  Project4-UIKIt
//
//  Created by Ezequiel Parada Beltran on 03/08/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView = UIProgressView()
    
    // NavigationButtons
    var backBtn: UIBarButtonItem!
    var fowardBtn: UIBarButtonItem!
    
   
    
    
    let websites = [
    "hackingwithswift.com",
    "apple.com"
    
    ]
    var websiteSelected: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn = UIBarButtonItem(image: UIImage(named: "j5QrV"), style: .plain, target: self, action: #selector(goBack))
        fowardBtn = UIBarButtonItem(image: UIImage(named: "4QoSE"), style: .plain, target: self, action: #selector(goFoward))
        
        
        backBtn.isEnabled = false
        fowardBtn.isEnabled = false
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [backBtn, progressButton, spacer, refresh, fowardBtn]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new
            , context: nil)
        
        // Do any additional setup after loading the view.
        
        if let web = websiteSelected {
            let url = URL(string: "https://www.\(web)")!
            webView.load(URLRequest(url: url))
            
        } else {
            let url = URL(string: "https://www.hackingwithswift.com")!
            webView.load(URLRequest(url: url))
           
        }
        
        
        webView.allowsBackForwardNavigationGestures = true
        
        
        
        
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)

    }
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
       
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        backBtn.isEnabled = webView.canGoBack
        fowardBtn.isEnabled = webView.canGoForward
    }


    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            let denied = UIAlertController(title: "denied", message: "This site is not allowed", preferredStyle: .alert)
            denied.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            present(denied,animated: true)
            
        }
        decisionHandler(.cancel)
    }
    
    

    
    
    
    // Back and foward actions
    @objc func goBack() {
        webView.goBack()
    }
    @objc func goFoward() {
        webView.goForward()
    }
}




