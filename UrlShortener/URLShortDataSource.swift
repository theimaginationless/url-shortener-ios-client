//
//  URLShortDataSource.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 04.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import UIKit

class URLShortDataSource: NSObject, UITableViewDataSource {
    var urlStore = [URLShortItem]()
    var searchUrlStore = [URLShortItem]()
    var inSearching = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUrlStore.isEmpty ? urlStore.count : searchUrlStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "URLShortTableViewCell", for: indexPath) as! URLShortTableViewCell
        let shortUrl = searchUrlStore.isEmpty ? urlStore[indexPath.row] : searchUrlStore[indexPath.row]
        
        if !(searchUrlStore.isEmpty && inSearching) {
            print(inSearching)
//            cell.sourceUrlLabel.text = shortUrl.sourceUrl.absoluteString
            cell.titleUrlLabel.text = shortUrl.title
            cell.shortUrlLabel.text = shortUrl.shortenedUrl.absoluteString
        }
        else {
//            cell.sourceUrlLabel.text = " "
            cell.titleUrlLabel.text = " "
            cell.shortUrlLabel.text = " "
        }
        
        return cell
    }
    
    func resetFindedData() {
        searchUrlStore.removeAll()
        inSearching = false
    }
}
