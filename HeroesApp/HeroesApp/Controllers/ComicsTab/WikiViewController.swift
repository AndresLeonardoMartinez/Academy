//
//  WikiViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 14/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit
import WebKit

class WikiViewController: UIViewController {
    @IBOutlet weak var miFrame : WKWebView!
    @IBOutlet weak var loadingIndicator : UIActivityIndicatorView!
    var url : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        miFrame.navigationDelegate = self
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        if let urlString = self.url{
            let myUrl = URL (string: urlString)
            miFrame.load(URLRequest(url: myUrl!))
        }
        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func closeMe(_ sender: UISwipeGestureRecognizer) {
            self.dismiss(animated: true, completion : nil)
    }
    
}

extension WikiViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    

}
