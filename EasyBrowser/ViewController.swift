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
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addOpenButton()
        loadUrlToWebView()
    }
    
    func loadUrlToWebView() {
        let url = URL(string: "https://atinagnihotri.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func addOpenButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
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

