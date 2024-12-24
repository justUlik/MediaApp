//
//  WebViewController.swift
//  MediaApp
//
//  Created by Ulyana Eskova on 23.12.2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    // MARK: - Variables
    var url: URL?
    
    private let webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .white
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
    
    // MARK: - Configures
    private func configureUI() {
        view.addSubview(webView)
        webView.pin(to: view)
    }
}
