//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Atin Agnihotri on 09/07/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var progressBarButtonItem: UIBarButtonItem!
    var spacerBarButtonItem: UIBarButtonItem!
    var refreshBarButtonItem: UIBarButtonItem!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addNavigationItems()
        loadUrlToWebView()
    }
    
    func loadUrlToWebView() {
        let url = URL(string: "https://atinagnihotri.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func addNavigationItems() {
        addOpenButton()
        addItemsToToolBar()
    }
    
    func addOpenButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }
    
    func addItemsToToolBar() {
        // Add Progress View
        addProgressBar()
        // Adds Spacer and refresh
        spacerBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        // Setup Toolbar
        toggleToolBarButtonItems(showProgressBar: true)
        navigationController?.isToolbarHidden = false
    }
    
    func toggleToolBarButtonItems(showProgressBar: Bool) {
        if showProgressBar {
            toolbarItems = [progressBarButtonItem, spacerBarButtonItem, refreshBarButtonItem]
        } else {
            toolbarItems = [spacerBarButtonItem, refreshBarButtonItem]
        }
    }
    
    func addProgressBar() {
        // Create Brogress Bar Button Item
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        progressBarButtonItem = UIBarButtonItem(customView: progressView)
        // Add KVO to Web View loading
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress == 1 {
                toggleToolBarButtonItems(showProgressBar: false)
            } else {
                toggleToolBarButtonItems(showProgressBar: true)
            }
        }
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page . . .", message: nil, preferredStyle: .actionSheet)
        let sites = ["atinagnihotri.com", "hackingwithswift.com", "apple.com", "google.com"]
        for eachSite in sites {
            ac.addAction(UIAlertAction(title: eachSite, style: .default, handler: openPage))
        }
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
    }

}

