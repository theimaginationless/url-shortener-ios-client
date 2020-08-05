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
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        URLDataSource.inSearching = searchBar.isUserInteractionEnabled && !searchText.isEmpty
        let urls = URLDataSource.urlStore.filter {
            return $0.sourceUrl.absoluteString.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        print("isEmpty: \(urls.isEmpty)")
        self.URLDataSource.searchUrlStore = urls
        self.URLTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.URLDataSource.resetFindedData()
        self.URLTableView.reloadData()
        print("cancel")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CreateUrl":
            print("Create!")
            let createViewController = segue.destination as! URLShortCreateViewController
            createViewController.shortenerStore = shortenerStore
            createViewController.URLDataSource = URLDataSource
            createViewController.reloadDataDelegate = self
        default:
            print("NO!")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.URLDataSource.urlStore.remove(at: indexPath.row)
        default:
            break
        }
    }
    
    func reloadDataNotify() {
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
