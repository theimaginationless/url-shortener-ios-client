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
    var shortUrlRowForCopy: IndexPath?
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
            if let row = self.indexPathForRow(at: location) {
                shortUrlRowForCopy = row
                let menu = UIMenuController.shared
                menu.menuItems = [UIMenuItem(title: NSLocalizedString("Copy", comment: "Copy short URL"), action: #selector(self.copyShortUrl(sender:)))]
                menu.showMenu(from: self, rect: CGRect(x: location.x, y: location.y - 16, width: 4, height: 2))
            }
        default:
            break
        }
    }

    @objc func copyShortUrl(sender: UIMenuItem) {
        let pasteBoard = UIPasteboard.general
        if let row = shortUrlRowForCopy, let cell = self.cellForRow(at: row) as? URLShortTableViewCell {
            pasteBoard.string = cell.shortUrlLabel.text!
        }
        
        hideMenu()
    }
    
    @objc func tap(gestureRecognizer: UIGestureRecognizer) {
        hideMenu()
    }
    
    func hideMenu() {
        let menu = UIMenuController.shared
        if menu.isMenuVisible {
            menu.hideMenu(from: self)
        }
    }
}
