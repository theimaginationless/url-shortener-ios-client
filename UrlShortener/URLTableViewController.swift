//
//  URLTableViewController.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 04.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import UIKit

class URLTableViewController: UITableViewController, UISearchBarDelegate, ReloadNotifyDelegate {
    @IBOutlet var URLTableView: URLTableView!
    var URLDataSource: URLShortDataSource!
    var shortenerStore: URLShortenerStore!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLTableView.dataSource = URLDataSource
        URLTableView.delegate = self
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        URLTableView.urlDataSource = URLDataSource
        URLDataSource.dataStore = shortenerStore
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        URLDataSource.inSearching = searchBar.isUserInteractionEnabled && !searchText.isEmpty
        let urls = shortenerStore.allUrls.filter {
            return $0.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
//        if urls.isEmpty {
//            urls = URLDataSource.urlStore.filter {
//                return $0.sourceUrl.absoluteString.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//            }
//        }
        
        self.URLDataSource.searchUrlStore = urls
        self.URLTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.URLDataSource.resetFoundedData()
        self.URLTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CreateUrl":
            let createViewController = segue.destination as! URLShortCreateViewController
            createViewController.shortenerStore = shortenerStore
            createViewController.URLDataSource = URLDataSource
            createViewController.reloadDataDelegate = self
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions = [UIContextualAction]()
        let removeAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Remove", comment: "Remove short url from table")) {[weak self] (action, view, complete) in
            self?.removeItem(at: indexPath, from: tableView)
        }
            
        removeAction.backgroundColor = .red
        removeAction.image = UIImage(systemName: "trash")
        actions.append(removeAction)
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    func removeItem(at indexPath: IndexPath, from tableView: UITableView) {
        //self.shortenerStore.allUrls.remove(at: indexPath.row)
        self.URLDataSource.remove(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func reloadDataNotify() {
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
