//
//  URLItem.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 04.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import UIKit

class URLShortItem: NSObject {
    var sourceUrl: URL
    var shortenedUrl: URL
    var title: String
    var id: String
    
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
