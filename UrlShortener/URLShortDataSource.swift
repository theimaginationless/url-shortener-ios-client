//
//  URLShortDataSource.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 04.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import UIKit

class URLShortDataSource: NSObject, UITableViewDataSource {    
    var dataStore: URLShortenerStore!
    var searchUrlStore = [URLShortItem]()
    var inSearching = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUrlStore.isEmpty && !inSearching ? dataStore.allUrls.count : searchUrlStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "URLShortTableViewCell", for: indexPath) as! URLShortTableViewCell
        let shortUrl = searchUrlStore.isEmpty ? dataStore.allUrls[indexPath.row] : searchUrlStore[indexPath.row]
        
        if !(searchUrlStore.isEmpty && inSearching) {
//            cell.sourceUrlLabel.text = shortUrl.sourceUrl.absoluteString
            cell.titleUrlLabel.text = shortUrl.title
            cell.shortUrlLabel.text = shortUrl.shortenedUrl.absoluteString
        }
        
        return cell
    }
    
    func resetFoundedData() {
        searchUrlStore.removeAll()
        inSearching = false
    }
    
    /*
     * Using for get URLShortItem from current context
     */
    func urlShortItem(at indexPath: IndexPath) -> URLShortItem {
        let items = self.inSearching ? searchUrlStore : dataStore.allUrls
        return items[indexPath.row]
    }
    
    func remove(at indexPath: IndexPath) {
        var sourceIndex: Int = indexPath.row
        
        if self.inSearching {
            let searchItem = self.searchUrlStore[indexPath.row]
            self.searchUrlStore.remove(at: indexPath.row)
            
            if let index = dataStore.allUrls.firstIndex(of: searchItem) {
                sourceIndex = index
            }
        }
        
        dataStore.allUrls.remove(at: sourceIndex)
    }
}
