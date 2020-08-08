//
//  ShortenerAPI.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 05.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import Foundation

enum URLResult {
    case Success(URLShortItem)
    case Failure(Error)
}

enum ShortenerError: Error {
    case InvalidJSONData
    case EmptyJSONData
    case ProcessingJSONError
}

struct ShortenerAPI {
    private static let baseURLString = UserDefaults.standard.string(forKey: SettingsKey.UrlApiEndpoint)!
    
    static func shortenerUrl(parameters: [String:String]?) -> URL? {
        guard var urlComponents = URLComponents(string: baseURLString) else {
            return nil
        }
        
        var queryItems = [URLQueryItem]()
        if let additionalParams = parameters {
            queryItems += additionalParams.map{URLQueryItem(name: $0.key, value: $0.value)}
        }
        
        urlComponents.queryItems = queryItems
        print("Final request: \(urlComponents.url!)")
        
        return urlComponents.url!
    }

    private static func processingJSON(dict: [String:AnyObject]) -> URLShortItem? {
        guard
            let sourceUrl = dict["sourceUrl"] as? String,
            let shortenedUrl = dict["shortenedUrl"] as? String else {
                return nil
        }
        
        return URLShortItem(title: "", sourceUrlString: sourceUrl, shortenedUrlString: shortenedUrl)
    }
    
    static func URLFromJSON(data: Data) -> URLResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonDict = jsonObject as? [String:AnyObject] else {
                return .Failure(ShortenerError.InvalidJSONData)
            }
            
            guard let item = processingJSON(dict: jsonDict) else {
                return .Failure(ShortenerError.ProcessingJSONError)
            }
            
            return .Success(item)
        }
        catch let error {
            return .Failure(error)
        }
    }
}
