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
    var id: String
    
    init(source: URL, shortened: URL) {
        self.sourceUrl = source
        self.shortenedUrl = shortened
        self.id = UUID().uuidString
    }
    
    convenience init?(sourceUrlString: String, shortenedUrlString: String) {
        if
            let sourceUrl = URL(string: sourceUrlString),
            let shortenedUrl = URL(string: shortenedUrlString) {
            self.init(source: sourceUrl, shortened: shortenedUrl)
        }
        else {
            return nil
        }
    }
}
