//
//  URLTableView.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 04.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import UIKit

class URLTableView: UITableView {
    var urlDataSource: URLShortDataSource!
    var shortUrlIndexPathForCopy: IndexPath?
    var selectedUrlShortItem: URLShortItem!
    override var canBecomeFirstResponder: Bool {return true}
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(gestureRecognizer:)))
        addGestureRecognizer(longTap)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(gestureRecognizer:)))
        addGestureRecognizer(tap)
    }
    
    @objc func longTap(gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.becomeFirstResponder()
            let location = gestureRecognizer.location(in: self)
            if let indexPath = self.indexPathForRow(at: location) {
                shortUrlIndexPathForCopy = indexPath
                let menu = UIMenuController.shared
                menu.menuItems = [UIMenuItem(title: NSLocalizedString("Copy", comment: "Copy short URL"), action: #selector(self.copyShortUrl(sender:)))]
                menu.showMenu(from: self, rect: CGRect(x: location.x, y: location.y - 16, width: 4, height: 2))
            }
        default:
            break
        }
    }

    @objc func copyShortUrl(sender: UIMenuItem) {
        guard let urlShortItem = findUrlShortItemBy(indexPath: shortUrlIndexPathForCopy) else {
            return
        }
        
        let pasteBoard = UIPasteboard.general
        pasteBoard.url = urlShortItem.shortenedUrl
        
        hideMenu()
    }
    
    @objc func tap(gestureRecognizer: UIGestureRecognizer) {
        if !hideMenu() {
            let location = gestureRecognizer.location(in: self)
            guard let indexPath = self.indexPathForRow(at: location) else {
                return
            }
        
            openUrlFrom(indexPath: indexPath)
        }
    }
    
    @discardableResult func hideMenu() -> Bool {
        let menu = UIMenuController.shared
        let isVisible = menu.isMenuVisible
        if isVisible {
            menu.hideMenu(from: self)
        }
        
        return isVisible
    }
    
    func findUrlShortItemBy(indexPath: IndexPath?) -> URLShortItem? {
        guard let urlIndexPath = indexPath else {
            return nil
        }
        
        return self.urlDataSource.urlShortItem(at: urlIndexPath)
    }
    
    func openUrlFrom(indexPath: IndexPath) {
        guard let urlShortItem = findUrlShortItemBy(indexPath: indexPath) else {
            return
        }
        
        let url = urlShortItem.shortenedUrl
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
