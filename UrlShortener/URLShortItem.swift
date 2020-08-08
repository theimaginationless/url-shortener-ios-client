//
//  URLItem.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 04.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import UIKit

extension URLShortItem {}
func == (lhs: URLShortItem, rhs: URLShortItem) -> Bool {
    return lhs.id == rhs.id
}

class URLShortItem: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {return true}
    
    var sourceUrl: URL
    var shortenedUrl: URL
    var title: String
    var id: String
    
    func encode(with coder: NSCoder) {
        coder.encode(sourceUrl, forKey: "sourceUrl")
        coder.encode(shortenedUrl, forKey: "shortenedUrl")
        coder.encode(title, forKey: "title")
        coder.encode(id, forKey: "id")
    }
    
    required init?(coder: NSCoder) {
        self.sourceUrl = coder.decodeObject(forKey: "sourceUrl") as! URL
        self.shortenedUrl = coder.decodeObject(forKey: "shortenedUrl") as! URL
        self.title = coder.decodeObject(forKey: "title") as! String
        self.id = coder.decodeObject(forKey: "id") as! String
    }
    
    init(title: String, source: URL, shortened: URL) {
        self.title = title
        self.sourceUrl = source
        self.shortenedUrl = shortened
        self.id = UUID().uuidString
    }
    
    convenience init?(title: String, sourceUrlString: String, shortenedUrlString: String) {
        if
            let sourceUrl = URL(string: sourceUrlString),
            let shortenedUrl = URL(string: shortenedUrlString) {
            self.init(title: title, source: sourceUrl, shortened: shortenedUrl)
        }
        else {
            return nil
        }
    }
}
