//
//  URLShortCreateViewController.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 05.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import UIKit

protocol ReloadNotifyDelegate {
    func reloadDataNotify()
}

extension UIBarButtonItem {
    func setTarget(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}

class URLShortCreateViewController: UIViewController {
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var titleUrlTextField: UITextField!
    @IBOutlet var URLTextField: UITextField!
    var doneBarButtonItem: UIBarButtonItem!
    
    var shortenerStore: URLShortenerStore!
    var URLDataSource: URLShortDataSource!
    
    var reloadDataDelegate: ReloadNotifyDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButtonItem = navigationBar.items?.first?.rightBarButtonItem!
        doneBarButtonItem.action = #selector(self.doneProcessing(action:))
    }
    
    @objc func doneProcessing(action: UIBarButtonItem) {
        let urlString = URLTextField.text!
        let titleUrlString = titleUrlTextField.text!
        
        if urlString.isEmpty || titleUrlString.isEmpty {
            print("Title or URL is empty!")
            return
        }
        
        shortenerStore.fetchShortenerFor(url: urlString) {
            (urlResult) in
            
            OperationQueue.main.addOperation {
                self.doneBarButtonItem.isEnabled = false
                switch urlResult {
                case let .Success(urlShortItem):
                    let item = urlShortItem
                    item.title = titleUrlString
                    self.shortenerStore.allUrls.append(urlShortItem)
                    self.reloadDataDelegate.reloadDataNotify()
                    self.dismiss(animated: true, completion: nil)
                case let .Failure(error):
                    print("Error: \(error)")
                }
                self.doneBarButtonItem.isEnabled = true
            }
        }
    }
}
